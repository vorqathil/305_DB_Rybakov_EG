package ru.vorqathil.db_lab7.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Entity
@Table(name = "groups")
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class Group {
    @Id
    @GeneratedValue(strategy = GenerationType. IDENTITY)
    private Long id;

    @Column(name = "group_number", nullable = false, unique = true)
    private String groupNumber;

    @Column(name = "program", nullable = false)
    private String program;

    @Column(name = "graduation_year", nullable = false)
    private Integer graduationYear;

    @OneToMany(mappedBy = "group", cascade = CascadeType.ALL)
    private List<Student> students;
}