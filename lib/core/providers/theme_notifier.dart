import 'package:flutter/material.dart';

/// Global theme notifier — toggle between dark and light modes.
/// Use anywhere: `themeNotifier.value = ThemeMode.light;`
final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);
