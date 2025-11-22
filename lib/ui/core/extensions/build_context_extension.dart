import 'package:flutter/material.dart';
import 'package:best_practices/ui/core/extensions/new_color_extension.dart';
import 'package:best_practices/ui/core/themes/custom_text_style.dart';
import 'package:best_practices/ui/core/themes/dimens.dart';


extension CustomTextThemeContextExtension on BuildContext {
  NewAppColorTheme get customColorTheme => Theme.of(this).extension<NewAppColorTheme>() ?? NewAppColorTheme();
  TextTheme get textTheme => Theme.of(this).textTheme; 
  ColorScheme get colorTheme => Theme.of(this).colorScheme;
  CustomTextTheme get customTextTheme => const CustomTextTheme();
  Dimens get dimens => Dimens.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
}