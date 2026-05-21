package ic.project.bytebistro.culinarycraft.service.implementation;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import ic.project.bytebistro.culinarycraft.config.AiGeminiProperties;
import ic.project.bytebistro.culinarycraft.service.DietaryAiAnalyzer;
import ic.project.bytebistro.culinarycraft.service.dto.DietaryAiAnalysisResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class GeminiDietaryAiAnalyzer implements DietaryAiAnalyzer {

    private static final Logger log = LoggerFactory.getLogger(GeminiDietaryAiAnalyzer.class);

    private final AiGeminiProperties properties;
    private final WebClient webClient;
    private final ObjectMapper objectMapper;

    public GeminiDietaryAiAnalyzer(AiGeminiProperties properties, WebClient.Builder webClientBuilder) {
        this.properties = properties;
        this.webClient = webClientBuilder.build();
        this.objectMapper = new ObjectMapper();
    }

    @Override
    public boolean isAvailable() {
        return properties.isEnabled()
                && properties.getApiKey() != null
                && !properties.getApiKey().isBlank();
    }

    @Override
    public DietaryAiAnalysisResult analyze(
            List<String> restrictions,
            String freeText,
            List<String> catalogIngredientNames) {

        if (!isAvailable()) {
            throw new IllegalStateException("Gemini AI is not configured");
        }

        String prompt = buildPrompt(restrictions, freeText, catalogIngredientNames);
        String responseText = callGemini(prompt);
        return parseAiResponse(responseText, catalogIngredientNames);
    }

    private String buildPrompt(List<String> restrictions, String freeText, List<String> catalog) {
        StringBuilder sb = new StringBuilder();
        sb.append("""
                You are an AI dietary assistant for a recipe mobile app.
                The user tells you what they do NOT eat. You must pick ingredient names to hide from the app catalog.

                Return ONLY valid JSON with this exact shape (no markdown):
                {"excludedIngredientNames":["exact_name_from_catalog"],"summary":"One short sentence explaining the filter"}

                Rules:
                - excludedIngredientNames must use ONLY names from the catalog below (exact lowercase spelling)
                - Include every catalog ingredient the user cannot eat (be thorough for categories like meat, dairy, nuts)
                - If user mentions a specific food, exclude matching catalog items (e.g. "turkey" -> "turkey" if in catalog)
                - summary: friendly, max 120 chars, same language as user input (Romanian or English)

                Selected preference tags:
                """);
        sb.append(restrictions == null || restrictions.isEmpty() ? "none" : String.join(", ", restrictions));
        sb.append("\n\nUser description (natural language):\n");
        sb.append(freeText == null || freeText.isBlank() ? "none" : freeText.trim());
        sb.append("\n\nIngredient catalog JSON array:\n");
        try {
            sb.append(objectMapper.writeValueAsString(catalog));
        } catch (Exception e) {
            sb.append(String.join(", ", catalog));
        }
        return sb.toString();
    }

    private String callGemini(String prompt) {
        String model = properties.getModel();
        String url = String.format(
                "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s",
                model,
                properties.getApiKey());

        Map<String, Object> body = Map.of(
                "contents", List.of(Map.of("parts", List.of(Map.of("text", prompt)))),
                "generationConfig", Map.of(
                        "temperature", 0.2,
                        "responseMimeType", "application/json"
                )
        );

        try {
            String response = webClient.post()
                    .uri(url)
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(body)
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();

            if (response == null || response.isBlank()) {
                throw new IllegalStateException("Empty Gemini response");
            }

            JsonNode root = objectMapper.readTree(response);
            JsonNode textNode = root.path("candidates").path(0).path("content").path("parts").path(0).path("text");
            if (textNode.isMissingNode() || textNode.asText().isBlank()) {
                throw new IllegalStateException("Gemini returned no text: " + response);
            }
            return textNode.asText();
        } catch (Exception e) {
            log.error("Gemini API call failed", e);
            throw new IllegalStateException("Gemini API call failed: " + e.getMessage(), e);
        }
    }

    private DietaryAiAnalysisResult parseAiResponse(String responseText, List<String> catalog) {
        try {
            String json = stripMarkdown(responseText.trim());
            JsonNode node = objectMapper.readTree(json);

            Set<String> catalogSet = new HashSet<>(catalog);
            List<String> excluded = new ArrayList<>();
            JsonNode namesNode = node.path("excludedIngredientNames");
            if (namesNode.isArray()) {
                for (JsonNode item : namesNode) {
                    String name = item.asText().trim().toLowerCase();
                    if (catalogSet.contains(name)) {
                        excluded.add(name);
                    }
                }
            }

            String summary = node.path("summary").asText("Preferences applied.");
            return new DietaryAiAnalysisResult(excluded, summary);
        } catch (Exception e) {
            log.error("Failed to parse Gemini JSON: {}", responseText, e);
            throw new IllegalStateException("Invalid AI response format", e);
        }
    }

    private String stripMarkdown(String text) {
        if (text.startsWith("```")) {
            text = text.replaceAll("^```json\\s*", "").replaceAll("^```\\s*", "");
            text = text.replaceAll("\\s*```$", "");
        }
        return text.trim();
    }
}
