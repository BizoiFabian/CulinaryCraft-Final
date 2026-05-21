package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.repository.dto.response.IngredientDTO;
import ic.project.bytebistro.culinarycraft.service.IngredientService;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("${apiVersion}/ingredients")
public class IngredientController {
    private final IngredientService ingredientService;

    public IngredientController(IngredientService ingredientService) {
        this.ingredientService = ingredientService;
    }

    @GetMapping()
    public ResponseEntity<Page<IngredientDTO>> getIngredients(@RequestParam int pageNumber,
                                                              @RequestParam int pageSize,
                                                              @RequestParam(required = false) Long userId) {
        return new ResponseEntity<>(ingredientService.getIngredients(pageNumber, pageSize, userId), HttpStatus.OK);
    }

    @GetMapping("/sort=name")
    public ResponseEntity<Page<IngredientDTO>> getIngredientsSortedByName(@RequestParam int pageNumber,
                                                              @RequestParam int pageSize,
                                                              @RequestParam(required = false) Long userId) {
        return new ResponseEntity<>(ingredientService.getIngredientsSortedByName(pageNumber, pageSize, userId), HttpStatus.OK);
    }

    @GetMapping("/sort=name/desc")
    public ResponseEntity<Page<IngredientDTO>> getIngredientsSortedByNameDescending(@RequestParam int pageNumber,
                                                                          @RequestParam int pageSize,
                                                                          @RequestParam(required = false) Long userId) {
        return new ResponseEntity<>(ingredientService.getIngredientsSortedByNameDescending(pageNumber, pageSize, userId), HttpStatus.OK);
    }

    @GetMapping("/search")
    public ResponseEntity<Page<IngredientDTO>> searchIngredients(@RequestParam String query,
                                                                 @RequestParam int pageNumber,
                                                                 @RequestParam int pageSize,
                                                                 @RequestParam(required = false) Long userId) {
        return new ResponseEntity<>(ingredientService.searchIngredients(query, pageNumber, pageSize, userId), HttpStatus.OK);
    }
}
