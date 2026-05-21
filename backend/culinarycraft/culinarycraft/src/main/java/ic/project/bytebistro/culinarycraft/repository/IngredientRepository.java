package ic.project.bytebistro.culinarycraft.repository;

import ic.project.bytebistro.culinarycraft.repository.dto.response.IngredientDTO;
import ic.project.bytebistro.culinarycraft.repository.entity.Ingredient;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IngredientRepository extends JpaRepository<Ingredient, Long> {
    Ingredient findByName(String ingredientName);

    @Query("SELECT new ic.project.bytebistro.culinarycraft.repository.dto.response.IngredientDTO(" +
            "i.id, i.name, i.urlImage) " +
            "FROM Ingredient i " +
            "WHERE LOWER(i.name) LIKE LOWER(CONCAT('%', :query, '%'))")
    Page<IngredientDTO> searchByName(@Param("query") String query, Pageable pageable);

    @Query("SELECT new ic.project.bytebistro.culinarycraft.repository.dto.response.IngredientDTO(" +
            "i.id, i.name, i.urlImage) " +
            "FROM Ingredient i " +
            "WHERE i.id NOT IN :excludedIds")
    Page<IngredientDTO> findAllExcludingIds(@Param("excludedIds") List<Long> excludedIds, Pageable pageable);

    @Query("SELECT new ic.project.bytebistro.culinarycraft.repository.dto.response.IngredientDTO(" +
            "i.id, i.name, i.urlImage) " +
            "FROM Ingredient i " +
            "WHERE LOWER(i.name) LIKE LOWER(CONCAT('%', :query, '%')) " +
            "AND i.id NOT IN :excludedIds")
    Page<IngredientDTO> searchByNameExcludingIds(
            @Param("query") String query,
            @Param("excludedIds") List<Long> excludedIds,
            Pageable pageable);
}
