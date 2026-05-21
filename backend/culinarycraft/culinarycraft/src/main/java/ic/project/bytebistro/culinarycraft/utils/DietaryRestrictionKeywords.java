package ic.project.bytebistro.culinarycraft.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class DietaryRestrictionKeywords {

    private static final Map<String, List<String>> KEYWORDS = new HashMap<>();

    static {
        KEYWORDS.put("no_meat", List.of(
                "chicken", "beef", "pork", "lamb", "bacon", "ham", "sausage",
                "turkey", "duck", "mince", "steak", "venison", "goat", "rabbit", "meat"
        ));
        KEYWORDS.put("no_fish_seafood", List.of(
                "fish", "salmon", "tuna", "shrimp", "prawn", "crab", "lobster",
                "cod", "anchov", "sardine", "mussel", "oyster", "seafood",
                "haddock", "trout", "squid", "octopus", "crayfish", "scallop"
        ));
        KEYWORDS.put("no_dairy", List.of(
                "milk", "cheese", "butter", "cream", "yogurt", "yoghurt",
                "parmesan", "cheddar", "mozzarella", "feta", "ricotta",
                "sour cream", "gouda", "brie", "mascarpone", "dairy"
        ));
        KEYWORDS.put("no_eggs", List.of("egg"));
        KEYWORDS.put("no_gluten", List.of(
                "wheat", "flour", "bread", "pasta", "spaghetti", "noodle",
                "barley", "rye", "semolina", "couscous", "bulgur", "gluten"
        ));
        KEYWORDS.put("no_nuts", List.of(
                "almond", "peanut", "walnut", "cashew", "pistachio",
                "hazelnut", "pecan", "macadamia", "nut"
        ));
        KEYWORDS.put("no_pork", List.of("pork", "bacon", "ham", "prosciutto"));
        KEYWORDS.put("vegetarian", List.of());
        KEYWORDS.put("vegan", List.of());
        KEYWORDS.put("no_honey", List.of("honey"));
    }

    private DietaryRestrictionKeywords() {
    }

    public static List<String> resolveKeywords(List<String> restrictions) {
        List<String> expanded = new ArrayList<>(restrictions == null ? List.of() : restrictions);

        if (expanded.contains("vegetarian")) {
            expanded.add("no_meat");
            expanded.add("no_fish_seafood");
        }
        if (expanded.contains("vegan")) {
            expanded.add("no_meat");
            expanded.add("no_fish_seafood");
            expanded.add("no_dairy");
            expanded.add("no_eggs");
            expanded.add("no_honey");
        }

        List<String> keywords = new ArrayList<>();
        for (String restriction : expanded) {
            List<String> restrictionKeywords = KEYWORDS.get(restriction);
            if (restrictionKeywords != null && !restrictionKeywords.isEmpty()) {
                keywords.addAll(restrictionKeywords);
            }
        }
        return keywords.stream().distinct().toList();
    }
}
