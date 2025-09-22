
import 'package:flutter/material.dart';
import 'package:mastering_tests/ui/core/extensions/color_extension.dart';
import 'package:mastering_tests/ui/core/themes/custom_text_style.dart';
import 'package:mastering_tests/ui/core/themes/dimens.dart';

extension CustomTextThemeContextExtension on BuildContext {
  AppColorTheme get customColorTheme => Theme.of(this).extension<AppColorTheme>() ?? AppColorTheme();
  TextTheme get textTheme => Theme.of(this).textTheme; 
  ColorScheme get colorTheme => Theme.of(this).colorScheme;
  CustomTextTheme get customTextTheme => const CustomTextTheme();
  Dimens get dimens => Dimens.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
}