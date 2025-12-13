package ru.vorqathil.db_lab8.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.vorqathil.db_lab8.entity.Subject;
import java.util.List;

public interface SubjectRepository extends JpaRepository<Subject, Long> {
    List<Subject> findBySpecializationIdAndYearOfStudy(Long specializationId, Integer yearOfStudy);
}