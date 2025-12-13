package ru.vorqathil.db_lab7.console;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import ru.vorqathil.db_lab7.entity.Group;
import ru.vorqathil.db_lab7.entity.Student;
import ru.vorqathil.db_lab7.services.StudentService;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Scanner;

@Component
@ConditionalOnProperty(name = "app.mode", havingValue = "console")
public class ConsoleApplication implements CommandLineRunner {

    private final StudentService studentService;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd. MM.yyyy");

    public ConsoleApplication(StudentService studentService) {
        this.studentService = studentService;
    }

    @Override
    public void run(String... args) {
        Scanner scanner = new Scanner(System.in);

        List<Group> activeGroups = studentService.getActiveGroups();

        if (activeGroups.isEmpty()) {
            System.out.println("В базе данных нет действующих групп.");
            return;
        }

        System.out.println("Действующие группы:");
        for (Group group : activeGroups) {
            System.out.println("  - " + group.getGroupNumber() +
                    " (" + group.getProgram() + ", выпуск " +
                    group.getGraduationYear() + ")");
        }

        System.out.println("\nВведите номер группы для фильтрации (или нажмите Enter для вывода всех студентов):");
        String input = scanner.nextLine().trim();

        List<Student> students;

        if (input. isEmpty()) {
            students = studentService.getAllActiveStudents();
            System.out.println("\nСписок всех студентов из действующих групп:\n");
        } else {
            if (! studentService.isValidGroupNumber(input)) {
                System.out.println("Ошибка: группа с номером '" + input + "' не найдена.");
                return;
            }

            students = studentService.getStudentsByGroupNumber(input);
            System. out.println("\nСписок студентов группы " + input + ":\n");
        }

        if (students.isEmpty()) {
            System.out.println("Студенты не найдены.");
            return;
        }

        printStudentsTable(students);
    }

    private void printStudentsTable(List<Student> students) {
        int groupWidth = 10;
        int programWidth = 30;
        int nameWidth = 40;
        int genderWidth = 6;
        int dateWidth = 12;
        int cardWidth = 15;

        printLine(groupWidth, programWidth, nameWidth, genderWidth, dateWidth, cardWidth, '┌', '┬', '┐', '─');

        printRow(groupWidth, programWidth, nameWidth, genderWidth, dateWidth, cardWidth,
                "Группа", "Направление", "ФИО", "Пол", "Дата рожд.", "№ студ.  билета");

        printLine(groupWidth, programWidth, nameWidth, genderWidth, dateWidth, cardWidth, '├', '┼', '┤', '─');

        for (Student student : students) {
            printRow(groupWidth, programWidth, nameWidth, genderWidth, dateWidth, cardWidth,
                    student.getGroup().getGroupNumber(),
                    student.getGroup().getProgram(),
                    student.getFullName(),
                    student.getGender(),
                    student.getBirthDate().format(DATE_FORMATTER),
                    student.getStudentCardNumber());
        }

        printLine(groupWidth, programWidth, nameWidth, genderWidth, dateWidth, cardWidth, '└', '┴', '┘', '─');
    }

    private void printLine(int w1, int w2, int w3, int w4, int w5, int w6,
                           char left, char middle, char right, char line) {
        System.out. print(left);
        System.out.print(repeat(line, w1));
        System.out.print(middle);
        System.out.print(repeat(line, w2));
        System.out.print(middle);
        System.out.print(repeat(line, w3));
        System.out.print(middle);
        System.out. print(repeat(line, w4));
        System.out.print(middle);
        System.out.print(repeat(line, w5));
        System.out. print(middle);
        System.out.print(repeat(line, w6));
        System.out.println(right);
    }

    private void printRow(int w1, int w2, int w3, int w4, int w5, int w6,
                          String c1, String c2, String c3, String c4, String c5, String c6) {
        System.out.print("│");
        System.out.print(padRight(c1, w1));
        System.out.print("│");
        System.out.print(padRight(c2, w2));
        System.out. print("│");
        System.out.print(padRight(c3, w3));
        System.out.print("│");
        System.out.print(padRight(c4, w4));
        System.out.print("│");
        System.out. print(padRight(c5, w5));
        System.out.print("│");
        System.out.print(padRight(c6, w6));
        System.out.println("│");
    }

    private String repeat(char ch, int count) {
        return String.valueOf(ch).repeat(count);
    }

    private String padRight(String text, int length) {
        if (text.length() >= length) {
            return text. substring(0, length);
        }
        return text + " ".repeat(length - text.length());
    }
}