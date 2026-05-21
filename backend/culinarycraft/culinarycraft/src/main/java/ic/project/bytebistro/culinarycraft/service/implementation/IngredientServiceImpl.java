package ic.project.bytebistro.culinarycraft.service.implementation;



import ic.project.bytebistro.culinarycraft.repository.IngredientRepository;

import ic.project.bytebistro.culinarycraft.repository.dto.response.IngredientDTO;

import ic.project.bytebistro.culinarycraft.repository.entity.Ingredient;

import ic.project.bytebistro.culinarycraft.service.DietaryPreferenceService;

import ic.project.bytebistro.culinarycraft.service.IngredientService;

import org.springframework.data.domain.Page;

import org.springframework.data.domain.PageImpl;

import org.springframework.data.domain.PageRequest;

import org.springframework.data.domain.Sort;

import org.springframework.stereotype.Service;



import java.util.ArrayList;

import java.util.List;



@Service

public class IngredientServiceImpl implements IngredientService {

    private final IngredientRepository ingredientRepository;

    private final DietaryPreferenceService dietaryPreferenceService;



    public IngredientServiceImpl(IngredientRepository ingredientRepository,

                                 DietaryPreferenceService dietaryPreferenceService) {

        this.ingredientRepository = ingredientRepository;

        this.dietaryPreferenceService = dietaryPreferenceService;

    }



    @Override

    public Page<IngredientDTO> getIngredients(int pageNumber, int pageSize, Long userId) {

        List<Long> excludedIds = resolveExcludedIds(userId);

        if (excludedIds.isEmpty()) {

            return mapPage(ingredientRepository.findAll(PageRequest.of(pageNumber, pageSize, Sort.unsorted())));

        }

        return ingredientRepository.findAllExcludingIds(

                excludedIds,

                PageRequest.of(pageNumber, pageSize, Sort.unsorted()));

    }



    @Override

    public Page<IngredientDTO> getIngredientsSortedByName(int pageNumber, int pageSize, Long userId) {

        return getIngredientsHelper(pageNumber, pageSize, Sort.Direction.ASC, userId, "name");

    }



    @Override

    public Page<IngredientDTO> getIngredientsSortedByNameDescending(int pageNumber, int pageSize, Long userId) {

        return getIngredientsHelper(pageNumber, pageSize, Sort.Direction.DESC, userId, "name");

    }



    @Override

    public IngredientDTO getIngredientByName(String name) {

        Ingredient ingredient = ingredientRepository.findByName(name);

        return IngredientDTO.builder()

                .name(name)

                .id(ingredient.getId())

                .imageUrl(ingredient.getUrlImage())

                .build();

    }



    @Override

    public Page<IngredientDTO> searchIngredients(String query, int pageNumber, int pageSize, Long userId) {

        String safeQuery = query == null ? "" : query.trim();

        List<Long> excludedIds = resolveExcludedIds(userId);

        PageRequest pageRequest = PageRequest.of(pageNumber, pageSize, Sort.by("name").ascending());



        if (excludedIds.isEmpty()) {

            return ingredientRepository.searchByName(safeQuery, pageRequest);

        }

        return ingredientRepository.searchByNameExcludingIds(safeQuery, excludedIds, pageRequest);

    }



    private Page<IngredientDTO> getIngredientsHelper(

            int pageNumber, int pageSize, Sort.Direction direction, Long userId, String... properties) {

        List<Long> excludedIds = resolveExcludedIds(userId);

        PageRequest pageRequest = PageRequest.of(pageNumber, pageSize, Sort.by(direction, properties));



        if (excludedIds.isEmpty()) {

            return mapPage(ingredientRepository.findAll(pageRequest));

        }

        return ingredientRepository.findAllExcludingIds(excludedIds, pageRequest);

    }



    private Page<IngredientDTO> mapPage(Page<Ingredient> ingredients) {

        List<IngredientDTO> ingredientsDTO = new ArrayList<>();

        ingredients.stream()

                .map(ingredient -> new IngredientDTO(

                        ingredient.getId(), ingredient.getName(), ingredient.getUrlImage()))

                .forEach(ingredientsDTO::add);

        return new PageImpl<>(ingredientsDTO, ingredients.getPageable(), ingredients.getTotalElements());

    }



    private List<Long> resolveExcludedIds(Long userId) {

        if (userId == null) {

            return List.of();

        }

        return dietaryPreferenceService.getExcludedIngredientIds(userId);

    }

}


