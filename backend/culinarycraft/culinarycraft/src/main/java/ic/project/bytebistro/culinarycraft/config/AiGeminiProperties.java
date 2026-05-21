package ic.project.bytebistro.culinarycraft.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
@Data
@ConfigurationProperties(prefix = "ai.gemini")
public class AiGeminiProperties {
    private boolean enabled = false;
    private String apiKey = "";
    private String model = "gemini-1.5-flash";
}
