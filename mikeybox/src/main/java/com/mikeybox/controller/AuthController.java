package com.mikeybox.controller;

import com.mikeybox.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/")
    public String home() {
        return "redirect:/dashboard";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/register")
    public String registerForm() {
        return "register";
    }

    @PostMapping("/register")
    public String register(
        @RequestParam String username,
        @RequestParam String password,
        Model model
    ) {
        if (username.isBlank() || password.isBlank()) {
            model.addAttribute("error", "Vul alle velden in");
            return "register";
        }
        if (userService.exists(username)) {
            model.addAttribute("error", "Gebruikersnaam al in gebruik");
            return "register";
        }
        userService.register(username, password);
        return "redirect:/login?registered";
    }

    @GetMapping("/dashboard")
    public String dashboard() {
        return "dashboard";
    }
}
