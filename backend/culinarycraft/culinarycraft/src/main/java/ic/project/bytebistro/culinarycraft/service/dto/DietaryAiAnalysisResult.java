package ic.project.bytebistro.culinarycraft.service.dto;

import java.util.List;

public record DietaryAiAnalysisResult(
        List<String> excludedIngredientNames,
        String summary
) {
}
