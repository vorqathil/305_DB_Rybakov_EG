package ru.vorqathil.db_lab7.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import ru.vorqathil.db_lab7.entity.Group;

import java.util.List;
import java.util.Optional;

@Repository
public interface GroupRepository extends JpaRepository<Group, Long> {

    @Query("SELECT g FROM Group g WHERE g. graduationYear >= YEAR(CURRENT_DATE) ORDER BY g.groupNumber")
    List<Group> findActiveGroups();

    Optional<Group> findByGroupNumber(String groupNumber);
}
