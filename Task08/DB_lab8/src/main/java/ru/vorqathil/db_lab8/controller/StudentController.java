package ru.vorqathil.db_lab8.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import ru.vorqathil.db_lab8.entity.*;
import ru.vorqathil.db_lab8.repository.*;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class StudentController {

    private final StudentRepository studentRepository;
    private final GroupRepository groupRepository;
    private final SpecializationRepository specializationRepository;
    private final ExamResultRepository examResultRepository;
    private final SubjectRepository subjectRepository;

    @GetMapping("/")
    public String index(@RequestParam(required = false) Long groupId, Model model) {
        List<Student> students;
        if (groupId != null) {
            students = studentRepository.findByGroupIdOrderByLastName(groupId);
        } else {
            students = studentRepository.findAllByOrderByGroup_GroupNumberAscLastNameAsc();
        }
        model.addAttribute("students", students);
        model.addAttribute("groups", groupRepository.findAll());
        model.addAttribute("selectedGroupId", groupId);
        return "index";
    }

    @GetMapping("/student/add")
    public String addStudentForm(Model model) {
        model.addAttribute("student", new Student());
        model.addAttribute("groups", groupRepository.findAll());
        model.addAttribute("specializations", specializationRepository.findAll());
        return "student-form";
    }

    @GetMapping("/student/edit/{id}")
    public String editStudentForm(@PathVariable Long id, Model model) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Student not found"));
        model.addAttribute("student", student);
        model.addAttribute("groups", groupRepository.findAll());
        model.addAttribute("specializations", specializationRepository.findAll());
        return "student-form";
    }

    @PostMapping("/student/save")
    public String saveStudent(@ModelAttribute Student student) {
        studentRepository.save(student);
        return "redirect:/";
    }

    @GetMapping("/student/delete/{id}")
    public String deleteStudentConfirm(@PathVariable Long id, Model model) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Student not found"));
        model.addAttribute("student", student);
        return "student-delete";
    }

    @PostMapping("/student/delete/{id}")
    public String deleteStudent(@PathVariable Long id) {
        studentRepository.deleteById(id);
        return "redirect:/";
    }

    @GetMapping("/student/{id}/exams")
    public String studentExams(@PathVariable Long id, Model model) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Student not found"));
        List<ExamResult> results = examResultRepository.findByStudentIdOrderByExamDateAsc(id);
        model.addAttribute("student", student);
        model.addAttribute("examResults", results);
        return "exam-results";
    }

    @GetMapping("/exam/add/{studentId}")
    public String addExamForm(@PathVariable Long studentId, Model model) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));

        ExamResult examResult = new ExamResult();
        examResult.setStudent(student);

        model.addAttribute("examResult", examResult);
        model.addAttribute("student", student);
        model.addAttribute("subjects", subjectRepository.findAll());
        return "exam-form";
    }

    @GetMapping("/exam/edit/{id}")
    public String editExamForm(@PathVariable Long id, Model model) {
        ExamResult examResult = examResultRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Exam result not found"));
        model.addAttribute("examResult", examResult);
        model.addAttribute("student", examResult.getStudent());
        model.addAttribute("subjects", subjectRepository.findAll());
        return "exam-form";
    }

    @PostMapping("/exam/save")
    public String saveExam(@ModelAttribute ExamResult examResult, @RequestParam Long studentId) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));
        examResult.setStudent(student);
        examResultRepository.save(examResult);
        return "redirect:/student/" + studentId + "/exams";
    }

    @PostMapping("/exam/delete/{id}")
    public String deleteExam(@PathVariable Long id, @RequestParam Long studentId) {
        examResultRepository.deleteById(id);
        return "redirect:/student/" + studentId + "/exams";
    }

    @GetMapping("/exam/subjects")
    @ResponseBody
    public List<Subject> getSubjects(@RequestParam Long studentId, @RequestParam String examDate) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));

        LocalDate date = LocalDate.parse(examDate);
        int yearsSinceEnrollment = date.getYear() - student.getEnrollmentYear();
        int yearOfStudy = Math.min(yearsSinceEnrollment + 1, 6);

        return subjectRepository.findBySpecializationIdAndYearOfStudy(
                student.getSpecialization().getId(), yearOfStudy);
    }
}