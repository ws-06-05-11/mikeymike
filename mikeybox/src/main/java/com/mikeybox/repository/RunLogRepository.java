package com.mikeybox.repository;

import com.mikeybox.model.RunLog;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RunLogRepository extends JpaRepository<RunLog, Long> {
    List<RunLog> findByUsernameOrderByDateDesc(String username);
}
