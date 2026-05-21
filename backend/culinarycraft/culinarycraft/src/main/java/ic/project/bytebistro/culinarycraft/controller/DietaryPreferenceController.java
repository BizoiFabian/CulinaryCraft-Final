package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.dto.request.DietaryPreferencesRequestDTO;
import ic.project.bytebistro.culinarycraft.repository.dto.response.DietaryPreferencesResponseDTO;
import ic.project.bytebistro.culinarycraft.service.DietaryPreferenceService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("${apiVersion}/users/{userId}/dietary-preferences")
public class DietaryPreferenceController {

    private final DietaryPreferenceService dietaryPreferenceService;

    public DietaryPreferenceController(DietaryPreferenceService dietaryPreferenceService) {
        this.dietaryPreferenceService = dietaryPreferenceService;
    }

    @GetMapping
    public ResponseEntity<DietaryPreferencesResponseDTO> getPreferences(@PathVariable Long userId) {
        return new ResponseEntity<>(dietaryPreferenceService.getPreferences(userId), HttpStatus.OK);
    }

    @PutMapping
    public ResponseEntity<DietaryPreferencesResponseDTO> savePreferences(
            @PathVariable Long userId,
            @RequestBody DietaryPreferencesRequestDTO request) {
        return new ResponseEntity<>(
                dietaryPreferenceService.savePreferences(userId, request),
                HttpStatus.OK);
    }
}
