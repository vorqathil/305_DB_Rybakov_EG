package ru.vorqathil.db_lab8.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.vorqathil.db_lab8.entity.ExamResult;
import java.util.List;

public interface ExamResultRepository extends JpaRepository<ExamResult, Long> {
    List<ExamResult> findByStudentIdOrderByExamDateAsc(Long studentId);
}