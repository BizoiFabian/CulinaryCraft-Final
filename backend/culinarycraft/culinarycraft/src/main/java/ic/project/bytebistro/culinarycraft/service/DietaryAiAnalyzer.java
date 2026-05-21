package ic.project.bytebistro.culinarycraft.service;

import ic.project.bytebistro.culinarycraft.service.dto.DietaryAiAnalysisResult;

import java.util.List;

public interface DietaryAiAnalyzer {
    boolean isAvailable();

    DietaryAiAnalysisResult analyze(List<String> restrictions, String freeText, List<String> catalogIngredientNames);
}
