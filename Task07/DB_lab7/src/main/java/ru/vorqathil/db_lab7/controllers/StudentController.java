package ru.vorqathil.db_lab7.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ru.vorqathil.db_lab7.entity.Group;
import ru.vorqathil.db_lab7.entity.Student;
import ru.vorqathil.db_lab7.services.StudentService;

import java.util.List;

@Controller
public class StudentController {

    private final StudentService studentService;

    public StudentController(StudentService studentService) {
        this.studentService = studentService;
    }

    @GetMapping("/")
    public String index(@RequestParam(name = "groupNumber", required = false) String groupNumber, Model model) {

        List<Group> activeGroups = studentService.getActiveGroups();
        model.addAttribute("groups", activeGroups);

        List<Student> students;
        if (groupNumber != null && !groupNumber.isEmpty()) {
            students = studentService.getStudentsByGroupNumber(groupNumber);
            model.addAttribute("selectedGroup", groupNumber);
        } else {
            students = studentService.getAllActiveStudents();
            model.addAttribute("selectedGroup", "");
        }

        model.addAttribute("students", students);

        return "index";
    }
}
