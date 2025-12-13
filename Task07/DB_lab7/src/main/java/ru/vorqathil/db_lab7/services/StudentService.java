package ru.vorqathil.db_lab7.services;

import org.springframework.stereotype.Service;
import ru.vorqathil.db_lab7.entity.Group;
import ru.vorqathil.db_lab7.entity.Student;
import ru.vorqathil.db_lab7.repositories.GroupRepository;
import ru.vorqathil.db_lab7.repositories.StudentRepository;

import java.util.List;

@Service
public class StudentService {

    private final StudentRepository studentRepository;
    private final GroupRepository groupRepository;

    public StudentService(StudentRepository studentRepository, GroupRepository groupRepository) {
        this.studentRepository = studentRepository;
        this.groupRepository = groupRepository;
    }

    public List<Group> getActiveGroups() {
        return groupRepository.findActiveGroups();
    }

    public List<Student> getAllActiveStudents() {
        return studentRepository.findAllActiveStudents();
    }

    public List<Student> getStudentsByGroupNumber(String groupNumber) {
        return studentRepository.findStudentsByGroupNumber(groupNumber);
    }

    public boolean isValidGroupNumber(String groupNumber) {
        return groupRepository.findByGroupNumber(groupNumber).isPresent();
    }
}
