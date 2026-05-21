import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart';

class DietaryPreferencesData {
  DietaryPreferencesData({
    required this.completed,
    required this.restrictions,
    required this.excludedIngredientIds,
    required this.excludedCount,
    this.aiPowered = false,
    this.aiSummary,
  });

  final bool completed;
  final List<String> restrictions;
  final List<int> excludedIngredientIds;
  final int excludedCount;
  final bool aiPowered;
  final String? aiSummary;

  factory DietaryPreferencesData.fromJson(Map<String, dynamic> json) {
    return DietaryPreferencesData(
      completed: json['completed'] == true,
      restrictions: (json['restrictions'] as List<dynamic>?)
              ?.map((dynamic e) => e.toString())
              .toList() ??
          <String>[],
      excludedIngredientIds: (json['excludedIngredientIds'] as List<dynamic>?)
              ?.map((dynamic e) => (e as num).toInt())
              .toList() ??
          <int>[],
      excludedCount: (json['excludedCount'] as num?)?.toInt() ?? 0,
      aiPowered: json['aiPowered'] == true,
      aiSummary: json['aiSummary'] as String?,
    );
  }
}

class DietaryPreferenceService {
  static Future<DietaryPreferencesData> getPreferences(int userId) async {
    final uri = Uri.parse('$baseURL/users/$userId/dietary-preferences');
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return DietaryPreferencesData.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Failed to load dietary preferences');
  }

  static Future<DietaryPreferencesData> savePreferences(
    int userId,
    List<String> restrictions, {
    String freeText = '',
  }) async {
    final uri = Uri.parse('$baseURL/users/$userId/dietary-preferences');
    final response = await http.put(
      uri,
      headers: headers,
      body: json.encode(<String, dynamic>{
        'restrictions': restrictions,
        'freeText': freeText,
      }),
    );
    if (response.statusCode == 200) {
      return DietaryPreferencesData.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Failed to save dietary preferences');
  }
}
