package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.dto.response.IngredientDTO;
import org.springframework.data.domain.Page;

import java.awt.print.Pageable;
import java.util.List;

public interface IngredientService {
    Page<IngredientDTO> getIngredients(int pageNumber, int pageSize, Long userId);
    Page<IngredientDTO> getIngredientsSortedByName(int pageNumber, int pageSize, Long userId);
    Page<IngredientDTO> getIngredientsSortedByNameDescending(int pageNumber, int pageSize, Long userId);
    IngredientDTO getIngredientByName(String name);
    Page<IngredientDTO> searchIngredients(String query, int pageNumber, int pageSize, Long userId);
}
