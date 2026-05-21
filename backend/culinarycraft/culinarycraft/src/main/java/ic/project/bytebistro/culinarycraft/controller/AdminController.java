package ic.project.bytebistro.culinarycraft.controller;

import ic.project.bytebistro.culinarycraft.utils.DataLoaderUtils;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("${apiVersion}/admin")
public class AdminController {

    private final DataLoaderUtils dataLoaderUtils;

    public AdminController(DataLoaderUtils dataLoaderUtils) {
        this.dataLoaderUtils = dataLoaderUtils;
    }

    @PostMapping("/reload-recipes")
    public ResponseEntity<String> reloadRecipes() {
        int imported = dataLoaderUtils.reloadAllRecipesSync();
        return ResponseEntity.ok("Imported " + imported + " recipes");
    }
}
