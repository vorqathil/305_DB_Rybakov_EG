package ru.vorqathil.db_lab8.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.vorqathil.db_lab8.entity.Group;

public interface GroupRepository extends JpaRepository<Group, Long> {
}