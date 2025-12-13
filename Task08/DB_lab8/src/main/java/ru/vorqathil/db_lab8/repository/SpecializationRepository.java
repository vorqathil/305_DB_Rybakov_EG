package ru.vorqathil.db_lab8.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.vorqathil.db_lab8.entity.Specialization;

public interface SpecializationRepository extends JpaRepository<Specialization, Long> {
}