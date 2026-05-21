package ic.project.bytebistro.culinarycraft.service.implementation;



import ic.project.bytebistro.culinarycraft.exception.UserNotFoundException;

import ic.project.bytebistro.culinarycraft.repository.IngredientRepository;

import ic.project.bytebistro.culinarycraft.repository.UserRepository;

import ic.project.bytebistro.culinarycraft.repository.dto.request.DietaryPreferencesRequestDTO;

import ic.project.bytebistro.culinarycraft.repository.dto.response.DietaryPreferencesResponseDTO;

import ic.project.bytebistro.culinarycraft.repository.entity.Ingredient;

import ic.project.bytebistro.culinarycraft.repository.entity.User;

import ic.project.bytebistro.culinarycraft.service.DietaryAiAnalyzer;

import ic.project.bytebistro.culinarycraft.service.DietaryPreferenceService;

import ic.project.bytebistro.culinarycraft.service.dto.DietaryAiAnalysisResult;

import ic.project.bytebistro.culinarycraft.utils.DietaryRestrictionKeywords;

import jakarta.transaction.Transactional;

import org.slf4j.Logger;

import org.slf4j.LoggerFactory;

import org.springframework.stereotype.Service;



import java.util.ArrayList;

import java.util.HashMap;

import java.util.HashSet;

import java.util.List;

import java.util.Map;

import java.util.Set;

@Service

@Transactional

public class DietaryPreferenceServiceImpl implements DietaryPreferenceService {



    private static final Logger log = LoggerFactory.getLogger(DietaryPreferenceServiceImpl.class);



    private final UserRepository userRepository;

    private final IngredientRepository ingredientRepository;

    private final DietaryAiAnalyzer dietaryAiAnalyzer;



    public DietaryPreferenceServiceImpl(UserRepository userRepository,

                                        IngredientRepository ingredientRepository,

                                        DietaryAiAnalyzer dietaryAiAnalyzer) {

        this.userRepository = userRepository;

        this.ingredientRepository = ingredientRepository;

        this.dietaryAiAnalyzer = dietaryAiAnalyzer;

    }



    @Override

    public DietaryPreferencesResponseDTO getPreferences(Long userId) {

        User user = getUser(userId);

        List<String> restrictions = user.getDietaryRestrictions() == null

                ? List.of()

                : user.getDietaryRestrictions();

        return buildResponse(user, restrictions, null, false);

    }



    @Override

    @Transactional

    public DietaryPreferencesResponseDTO savePreferences(Long userId, DietaryPreferencesRequestDTO request) {

        User user = getUser(userId);

        List<String> restrictions = request.getRestrictions() == null

                ? List.of()

                : request.getRestrictions();

        String freeText = request.getFreeText() == null ? "" : request.getFreeText().trim();



        boolean aiPowered = false;

        String aiSummary = null;

        List<Ingredient> excluded;



        if (shouldUseAi(restrictions, freeText)) {

            try {

                AiResolution aiResolution = resolveWithAi(restrictions, freeText);

                excluded = aiResolution.ingredients();

                aiPowered = true;

                aiSummary = aiResolution.summary();

            } catch (Exception e) {

                log.warn("AI dietary analysis failed, using rule-based fallback: {}", e.getMessage());

                excluded = resolveExcludedIngredientsRuleBased(restrictions, freeText);

                aiSummary = "AI unavailable — rule-based filter applied.";

            }

        } else {

            excluded = resolveExcludedIngredientsRuleBased(restrictions, freeText);

        }



        user.setDietaryRestrictions(new ArrayList<>(restrictions));

        user.setExcludedIngredients(excluded);

        user.setDietaryPreferencesCompleted(true);

        userRepository.save(user);



        return buildResponse(user, restrictions, aiSummary, aiPowered);

    }



    @Override

    public List<Long> getExcludedIngredientIds(Long userId) {

        User user = getUser(userId);

        if (user.getExcludedIngredients() == null) {

            return List.of();

        }

        return user.getExcludedIngredients().stream()

                .map(Ingredient::getId)

                .toList();

    }



    private boolean shouldUseAi(List<String> restrictions, String freeText) {

        if (!dietaryAiAnalyzer.isAvailable()) {

            return false;

        }

        return !freeText.isBlank() || !restrictions.isEmpty();

    }



    private AiResolution resolveWithAi(List<String> restrictions, String freeText) {

        List<Ingredient> allIngredients = ingredientRepository.findAll();

        List<String> catalogNames = allIngredients.stream()

                .map(i -> i.getName().toLowerCase())

                .distinct()

                .sorted()

                .toList();



        DietaryAiAnalysisResult aiResult =

                dietaryAiAnalyzer.analyze(restrictions, freeText, catalogNames);



        Map<String, Ingredient> byName = new HashMap<>();

        for (Ingredient ingredient : allIngredients) {

            byName.put(ingredient.getName().toLowerCase(), ingredient);

        }



        Set<Ingredient> matched = new HashSet<>();

        for (String name : aiResult.excludedIngredientNames()) {

            Ingredient ingredient = byName.get(name.toLowerCase());

            if (ingredient != null) {

                matched.add(ingredient);

            }

        }



        return new AiResolution(new ArrayList<>(matched), aiResult.summary());

    }



    private List<Ingredient> resolveExcludedIngredientsRuleBased(List<String> restrictions, String freeText) {

        Set<Long> matchedIds = new HashSet<>();

        List<String> keywords = DietaryRestrictionKeywords.resolveKeywords(restrictions);



        if (!freeText.isBlank()) {

            String[] tokens = freeText.toLowerCase().split("[,;\\s]+");

            for (String token : tokens) {

                if (token.length() >= 3) {

                    keywords = new ArrayList<>(keywords);

                    keywords.add(token);

                }

            }

        }



        if (keywords.isEmpty()) {

            return List.of();

        }



        List<Ingredient> allIngredients = ingredientRepository.findAll();

        for (Ingredient ingredient : allIngredients) {

            String name = ingredient.getName().toLowerCase();

            for (String keyword : keywords) {

                if (name.contains(keyword)) {

                    matchedIds.add(ingredient.getId());

                    break;

                }

            }

        }



        return ingredientRepository.findAllById(matchedIds);

    }



    private DietaryPreferencesResponseDTO buildResponse(

            User user,

            List<String> restrictions,

            String aiSummary,

            boolean aiPowered) {

        List<Ingredient> excluded = user.getExcludedIngredients() == null

                ? List.of()

                : user.getExcludedIngredients();



        return DietaryPreferencesResponseDTO.builder()

                .completed(Boolean.TRUE.equals(user.getDietaryPreferencesCompleted()))

                .restrictions(restrictions)

                .excludedIngredientIds(excluded.stream().map(Ingredient::getId).toList())

                .excludedCount(excluded.size())

                .aiPowered(aiPowered)

                .aiSummary(aiSummary)

                .build();

    }



    private User getUser(Long userId) {

        return userRepository.findById(userId).orElseThrow(UserNotFoundException::new);

    }



    private record AiResolution(List<Ingredient> ingredients, String summary) {}

}


