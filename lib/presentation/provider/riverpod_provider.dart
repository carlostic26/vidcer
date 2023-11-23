import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/controller/theme_preferences.dart';

final darkTheme_rp = StateProvider((ref) => false);
final buttonEnabled_rp = StateProvider((ref) => false);

final themeStateProvider = StateNotifierProvider<ThemeProvider, String>((ref) {
  final themePreference = ThemePreference();
  return ThemeProvider(themePreference.getTheme());
});

class ThemeProvider extends StateNotifier<String> {
  ThemeProvider(String initialTheme) : super(initialTheme);

  void toggleTheme() {
    state = state == 'LIGHT' ? 'DARK' : 'LIGHT';
  }
}