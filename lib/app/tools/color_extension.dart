import 'package:flutter/material.dart';

extension ColorExtension on Color {

  MaterialColor materialColor() {
    return MaterialColor(value, {
      50: withAlpha((255*0.1).round()),
      100: withAlpha((255*0.2).round()),
      200: withAlpha((255*0.3).round()),
      300: withAlpha((255*0.4).round()),
      400: withAlpha((255*0.5).round()),
      500: withAlpha((255*0.6).round()),
      600: withAlpha((255*0.7).round()),
      700: withAlpha((255*0.8).round()),
      800: withAlpha((255*0.9).round()),
      900: withAlpha(255),
    });
  }
}
