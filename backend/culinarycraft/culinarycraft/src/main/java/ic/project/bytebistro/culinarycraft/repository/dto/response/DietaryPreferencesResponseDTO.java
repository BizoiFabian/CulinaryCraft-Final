package ic.project.bytebistro.culinarycraft.repository.dto.response;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class DietaryPreferencesResponseDTO {
    private boolean completed;
    private List<String> restrictions;
    private List<Long> excludedIngredientIds;
    private int excludedCount;
    private boolean aiPowered;
    private String aiSummary;
}
