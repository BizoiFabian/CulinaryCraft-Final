package ic.project.bytebistro.culinarycraft;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@AllArgsConstructor
@Data
@Builder
public class UserDTO {
    private String name;
    private int age;
}
