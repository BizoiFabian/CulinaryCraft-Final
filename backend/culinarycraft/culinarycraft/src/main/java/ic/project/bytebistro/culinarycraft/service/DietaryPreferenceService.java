package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.repository.dto.request.DietaryPreferencesRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.DietaryPreferencesResponseDTO;

import java.util.List;

public interface DietaryPreferenceService {
    DietaryPreferencesResponseDTO getPreferences(Long userId);

    DietaryPreferencesResponseDTO savePreferences(Long userId, DietaryPreferencesRequestDTO request);

    List<Long> getExcludedIngredientIds(Long userId);
}
