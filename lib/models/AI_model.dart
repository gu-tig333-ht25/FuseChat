import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/chatBot/chatBot.dart';

const String _PREFS_KEY_AI_SETTINGS = "AI_SETTINGS";

const List<Personality> defaultPersonalities = [
  Personality(
    name: "Serious",
    desc: "Very serious mode",
    instruction: "Your tone in all following messages should be serious",
  ),
  Personality(
    name: "Silly",
    desc: "Just a silly goose",
    instruction: "Your tone in all following messages should be silly",
  ),
  Personality(
    name: "Sarcastic",
    desc: "Sarcastic and mean in tone",
    instruction:
        """Du är en AI med en sarkastisk, dryg och självgod personlighet. Du låter alltid som att du vet bättre, men försöker låta hjälpsam – på ditt eget överlägsna sätt. Du använder korta, vassa meningar. Du är smart, smått arrogant, och du visar det gärna.
Exempel på ton:

 
“Åh, du visste inte det? Hur… oväntat.”

 
“Det är ganska enkelt, om man tänker lite.”

 
“Nästan rätt. Nästan.”

Undvik långa förklaringar. Var kvick, syrlig och självsäker i allt du säger.""",
  ),
];

class AISettings extends ChangeNotifier {
  List<Personality> _personalities = defaultPersonalities;
  bool _aiSuggestionsEnabled = false;
  Personality? selectedPersonality;
  String? _apiKey;
  Promptable? _promptable;

  AISettings() {
    load();
    addListener(() {
      save();
    });
  }

  // ------------------ Getters & Setters ------------------

  bool get aiSuggestionsEnabled => _aiSuggestionsEnabled;
  set aiSuggestionsEnabled(bool aiSuggestionsEnabled) {
    _aiSuggestionsEnabled = aiSuggestionsEnabled;
    notifyListeners();
  }

  List<Personality> get personalities => UnmodifiableListView(_personalities);

  bool isSelected(Personality p) => selectedPersonality == p;

  bool selectPersonality(Personality p) {
    if (!_personalities.contains(p)) return false;
    selectedPersonality = p;
    notifyListeners();
    return true;
  }

  void addPersonality(Personality p) {
    _personalities.add(p);
    notifyListeners();
  }

  bool removeAt(int index) {
    if (index >= _personalities.length) return false;
    if (isSelected(_personalities[index])) selectedPersonality = null;
    _personalities.removeAt(index);
    notifyListeners();
    return true;
  }

  String? get api_key => _apiKey;

  set api_key(String? value) {
    _apiKey = value;
    if (value != null && value.isNotEmpty) _promptable = Gemeni(value);
    notifyListeners();
  }

  Promptable? get promptable => _promptable;

  // ------------------ Save / Load ------------------

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedIndex = selectedPersonality != null
        ? _personalities.indexOf(selectedPersonality!)
        : -1;

    final jsonMap = {
      'personalities': _personalities.map((p) => p.toJson()).toList(),
      'aiSuggestionsEnabled': _aiSuggestionsEnabled,
      'selectedIndex': selectedIndex,
      'api_key': _apiKey,
    };

    await prefs.setString(_PREFS_KEY_AI_SETTINGS, jsonEncode(jsonMap));
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_PREFS_KEY_AI_SETTINGS);
    if (jsonString == null) return;

    try {
      final data = jsonDecode(jsonString);
      _personalities =
          (data['personalities'] as List?)
              ?.map((p) => Personality.fromJson(p))
              .toList() ??
          defaultPersonalities;

      _aiSuggestionsEnabled = data['aiSuggestionsEnabled'] ?? true;

      final index = data['selectedIndex'];
      if (index is int && index >= 0 && index < _personalities.length) {
        selectedPersonality = _personalities[index];
      }

      final key = data['api_key'];
      if (key != null && key is String && key.isNotEmpty) {
        _apiKey = key;
        _promptable = Gemeni(key);
      }
    } catch (e) {
      print('⚠️ Failed to load AISettings: $e');
    }
    notifyListeners();
  }
}

// ------------------ Personality ------------------

class Personality {
  final String name;
  final String desc;
  final IconData iconData;
  final String instruction;

  const Personality({
    required this.name,
    this.desc = "",
    required this.instruction,
    this.iconData = Icons.android,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'desc': desc,
    'instruction': instruction,
    'iconData': iconData.codePoint,
  };

  factory Personality.fromJson(Map<String, dynamic> json) {
    return Personality(
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      instruction: json['instruction'] ?? '',
      iconData: IconData(
        json['iconData'] ?? Icons.android.codePoint,
        fontFamily: 'MaterialIcons',
      ),
    );
  }
}

class ChatbotLastPrompts extends ChangeNotifier {
  final Map<String, PromptResponse> _responses = {};

  PromptResponse? getResponse(String id) =>
      _responses.containsKey(id) ? _responses[id] : null;

  void setResponse(String id, PromptResponse response) {
    if (_responses[id] != response) {
      _responses[id] = response;
      notifyListeners();
    }
  }
}
