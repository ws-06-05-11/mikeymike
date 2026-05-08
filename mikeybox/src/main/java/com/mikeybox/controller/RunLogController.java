package com.mikeybox.controller;

import com.mikeybox.model.RunLog;
import com.mikeybox.repository.RunLogRepository;
import java.time.LocalDate;
import java.util.List;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/runs")
public class RunLogController {

    private final RunLogRepository runLogRepository;

    public RunLogController(RunLogRepository runLogRepository) {
        this.runLogRepository = runLogRepository;
    }

    @GetMapping
    public String list(@AuthenticationPrincipal UserDetails user, Model model) {
        List<RunLog> runs = runLogRepository.findByUsernameOrderByDateDesc(user.getUsername());
        model.addAttribute("runs", runs);
        model.addAttribute("today", LocalDate.now().toString());
        model.addAttribute("totalKm", runs.stream().mapToDouble(RunLog::getDistanceKm).sum());
        model.addAttribute("bestPace", bestPace(runs));
        return "runs";
    }

    @PostMapping
    public String add(
        @AuthenticationPrincipal UserDetails user,
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
        @RequestParam Double distanceKm,
        @RequestParam Integer durationMinutes,
        @RequestParam Integer durationSeconds,
        @RequestParam(required = false) String notes
    ) {
        RunLog log = new RunLog();
        log.setUsername(user.getUsername());
        log.setDate(date);
        log.setDistanceKm(distanceKm);
        log.setDurationSeconds(durationMinutes * 60 + durationSeconds);
        if (notes != null && !notes.isBlank()) {
            log.setNotes(notes);
        }
        runLogRepository.save(log);
        return "redirect:/runs";
    }

    private String bestPace(List<RunLog> runs) {
        return runs.stream()
            .mapToDouble(r -> r.getDurationSeconds() / r.getDistanceKm())
            .min()
            .stream()
            .mapToObj(s -> String.format("%d:%02d", (int) s / 60, (int) s % 60))
            .findFirst()
            .orElse("—");
    }
}
