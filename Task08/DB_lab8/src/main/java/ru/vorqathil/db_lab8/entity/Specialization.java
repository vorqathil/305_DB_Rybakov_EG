package ru.vorqathil.db_lab8.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "specializations")
@Data
public class Specialization {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;
}