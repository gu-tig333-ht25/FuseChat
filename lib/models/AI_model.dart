import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

import 'package:template/chatBot/chatBot.dart';

const List<Personality> defaultPersonalities = [
  Personality(
    name: "Serious",
    desc: "Very serious mode",
    instruction: "Your tone in all following messages should be serious",
  ),
  Personality(
    name: "Silly",
    desc: "Just a silly goose",
    instruction: "Your tone in all following messages should be Silly",
  ),
];

class AISettings extends ChangeNotifier {
  final List<Personality> _personalities;
  bool _aiSuggestionsEnabled;
  Personality? selectedPersonality;
  String? _api_key;

  AISettings({
    List<Personality> personalities = defaultPersonalities,
    bool aiSuggestionsEnabled = true,
  }) : _personalities = personalities,
       _aiSuggestionsEnabled = aiSuggestionsEnabled;

  set aiSuggestionsEnabled(bool enabled) {
    if (_aiSuggestionsEnabled != enabled) {
      _aiSuggestionsEnabled = enabled;
      notifyListeners();
    }
  }

  get aiSuggestionsEnabled => _aiSuggestionsEnabled;

  List<Personality> get personalities => UnmodifiableListView(_personalities);

  bool isSelected(Personality personality) =>
      personality == selectedPersonality;

  bool selectPersonality(Personality pi) {
    if (!_personalities.contains(pi)) return false;
    selectedPersonality = pi;
    notifyListeners();
    return true;
  }

  void addPersonality(Personality personality) {
    _personalities.add(personality);
    notifyListeners();
  }

  bool removeAt(int index) {
    if (index >= _personalities.length) return false;
    if (isSelected(_personalities[index])) {
      selectedPersonality = null;
    }
    _personalities.removeAt(index);
    notifyListeners();
    return true;
  }

  String? get api_key => _api_key;
  Promptable? _promptable;

  set api_key(String apiKey){
    _promptable = Gemeni(apiKey);
    _api_key = apiKey;
    notifyListeners();
  }

  Promptable? get promptable => _promptable;
}





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
}
