package ru.vorqathil.db_lab8.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "groups")
@Data
public class Group {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "group_number", unique = true, nullable = false)
    private String groupNumber;
}