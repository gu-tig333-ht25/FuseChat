import 'package:flutter/material.dart';
import '../theme/themedata.dart';

class ThemeSettings extends ChangeNotifier {
  ThemeData _data;
  ThemeSettings(this._data);

  set isDarkMode(bool b) {
    ThemeData newData = b ? fuseChatDarkTheme : fuseChatLightTheme;
    if (newData != _data){
      _data = newData;
      notifyListeners();
    }
  }
  get isDarkMode => _data == fuseChatDarkTheme;

  ThemeData get theme => _data.copyWith();
}
