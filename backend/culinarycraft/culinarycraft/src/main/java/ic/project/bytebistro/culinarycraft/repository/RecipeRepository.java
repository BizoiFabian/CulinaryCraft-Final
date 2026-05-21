package ic.project.bytebistro.culinarycraft.repository;

import ic.project.bytebistro.culinarycraft.repository.entity.Recipe;
import ic.project.bytebistro.culinarycraft.repository.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RecipeRepository extends JpaRepository<Recipe, Long> {
    Page<Recipe> findAllByUser(User user, Pageable pageable);
    Page<Recipe> findAllByLikesContaining(User user, Pageable pageable);

    @Query(value = "SELECT r FROM Recipe r JOIN r.ingredients i " +
            "WHERE i.id IN :ingredientsID " +
            "GROUP BY r " +
            "ORDER BY COUNT(DISTINCT i.id) DESC, r.id ASC",
           countQuery = "SELECT COUNT(DISTINCT r) FROM Recipe r JOIN r.ingredients i " +
                    "WHERE i.id IN :ingredientsID")
    Page<Recipe> findByIngredientsContaining(@Param("ingredientsID") List<Long> ingredientsID, Pageable pageable);

    @Query(value = "SELECT r FROM Recipe r JOIN r.ingredients i " +
            "WHERE i.id IN :ingredientsID " +
            "AND NOT EXISTS (" +
            "  SELECT 1 FROM Recipe r2 JOIN r2.ingredients ex " +
            "  WHERE r2 = r AND ex.id IN :excludedIds" +
            ") " +
            "GROUP BY r " +
            "ORDER BY COUNT(DISTINCT i.id) DESC, r.id ASC",
           countQuery = "SELECT COUNT(DISTINCT r) FROM Recipe r JOIN r.ingredients i " +
                    "WHERE i.id IN :ingredientsID " +
                    "AND NOT EXISTS (" +
                    "  SELECT 1 FROM Recipe r2 JOIN r2.ingredients ex " +
                    "  WHERE r2 = r AND ex.id IN :excludedIds" +
                    ")")
    Page<Recipe> findByIngredientsContainingExcluding(
            @Param("ingredientsID") List<Long> ingredientsID,
            @Param("excludedIds") List<Long> excludedIds,
            Pageable pageable);
}
