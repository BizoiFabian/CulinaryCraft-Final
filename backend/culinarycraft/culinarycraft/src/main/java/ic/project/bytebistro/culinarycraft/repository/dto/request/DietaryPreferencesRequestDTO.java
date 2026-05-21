package ic.project.bytebistro.culinarycraft.repository.dto.request;

import lombok.Data;

import java.util.List;

@Data
public class DietaryPreferencesRequestDTO {
    private List<String> restrictions;
    /** Natural language: what the user does not eat (processed by AI when enabled). */
    private String freeText;
}
