package ru.vorqathil.db_lab7.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import ru.vorqathil.db_lab7.entity.Student;

import java.util.List;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {

    @Query("SELECT s FROM Student s JOIN s.group g " +
            "WHERE g.graduationYear >= YEAR(CURRENT_DATE) " +
            "ORDER BY g.groupNumber, s.lastName, s.firstName")
    List<Student> findAllActiveStudents();

    @Query("SELECT s FROM Student s JOIN s.group g " +
            "WHERE g.groupNumber = :groupNumber AND g.graduationYear >= YEAR(CURRENT_DATE) " +
            "ORDER BY s.lastName, s.firstName")
    List<Student> findStudentsByGroupNumber(@Param("groupNumber") String groupNumber);
}
