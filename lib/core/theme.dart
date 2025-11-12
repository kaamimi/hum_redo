import 'package:flutter/material.dart';

import './constants.dart';
import './colors.dart';

NavigationBarThemeData _navBarThemeBuilder({required Color selectedIconColor}) {
  return NavigationBarThemeData(
    height: navBarHeight,
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    indicatorColor: Colors.transparent,
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.selected)) {
        return IconThemeData(size: navBarIconSize, color: selectedIconColor);
      }
      return IconThemeData(size: navBarIconSize);
    }),
  );
}

final ThemeData humLightTheme = ThemeData(
  navigationBarTheme: _navBarThemeBuilder(
    selectedIconColor: humLightColorScheme.onSurface,
  ),
  colorScheme: humLightColorScheme,
);

final ThemeData humDarkTheme = ThemeData(
  navigationBarTheme: _navBarThemeBuilder(
    selectedIconColor: humDarkColorScheme.onSurface,
  ),
  colorScheme: humDarkColorScheme,
);
