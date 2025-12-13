package ru.vorqathil.db_lab8.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.vorqathil.db_lab8.entity.Student;
import java.util.List;

public interface StudentRepository extends JpaRepository<Student, Long> {
    List<Student> findByGroupIdOrderByLastName(Long groupId);
    List<Student> findAllByOrderByGroup_GroupNumberAscLastNameAsc();
}