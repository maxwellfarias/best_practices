import 'package:flutter/material.dart';

@immutable
class CustomTextTheme {
  final TextStyle displayMd;
  final TextStyle displayMdMedium;
  final TextStyle displayMdSemibold;
  final TextStyle displayMdBold;
  final TextStyle displaySm;
  final TextStyle displaySmMedium;
  final TextStyle displaySmSemibold;
  final TextStyle displaySmBold;
  final TextStyle displayXs;
  final TextStyle displayXsMedium;
  final TextStyle displayXsSemibold;
  final TextStyle displayXsBold;
  final TextStyle textXl;
  final TextStyle textXlMedium;
  final TextStyle textXlSemibold;
  final TextStyle textXlBold;
  final TextStyle textLg;
  final TextStyle textLgMedium;
  final TextStyle textLgSemibold;
  final TextStyle textLgBold;
  final TextStyle textMd;
  final TextStyle textMdMedium;
  final TextStyle textMdSemibold;
  final TextStyle textMdBold;
  final TextStyle textSm;
  final TextStyle textSmMedium;
  final TextStyle textSmSemibold;
  final TextStyle textSmBold;
  final TextStyle textXs;
  final TextStyle textXsMedium;
  final TextStyle textXsSemibold;
  final TextStyle textXsBold;

  const CustomTextTheme({
    this.displayMd = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 36, height: 44 / 36,
    ),
    this.displayMdMedium = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 36, height: 44 / 36,
    ),
    this.displayMdSemibold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 36, height: 44 / 36,
    ),
    this.displayMdBold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 36, height: 44 / 36,
    ),
    this.displaySm = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 30, height: 38 / 30,
    ),
    this.displaySmMedium = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 30, height: 38 / 30,
    ),
    this.displaySmSemibold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 30, height: 38 / 30,
    ),
    this.displaySmBold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 30, height: 38 / 30,
    ),
    this.displayXs = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 24, height: 32 / 24,
    ),
    this.displayXsMedium = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 24, height: 32 / 24,
    ),
    this.displayXsSemibold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 24, height: 32 / 24,
    ),
    this.displayXsBold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 24, height: 32 / 24,
    ),
    this.textXl = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 20, height: 30 / 20,
    ),
    this.textXlMedium = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 20, height: 30 / 20,
    ),
    this.textXlSemibold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 20, height: 30 / 20,
    ),
    this.textXlBold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 20, height: 30 / 20,
    ),
    this.textLg = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 18, height: 28 / 18,
    ),
    this.textLgMedium = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 18, height: 28 / 18,
    ),
    this.textLgSemibold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 18, height: 28 / 18,
    ),
    this.textLgBold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 18, height: 28 / 18,
    ),
    this.textMd = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 16, height: 24 / 16,
    ),
    this.textMdMedium = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 16, height: 24 / 16,
    ),
    this.textMdSemibold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16, height: 24 / 16,
    ),
    this.textMdBold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16, height: 24 / 16,
    ),
    this.textSm = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14,
    ),
    this.textSmMedium = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 14, height: 20 / 14,
    ),
    this.textSmSemibold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14,
    ),
    this.textSmBold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14, height: 20 / 14,
    ),
    this.textXs = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 12, height: 18 / 12,
    ),
    this.textXsMedium = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 12, height: 18 / 12,
    ),
    this.textXsSemibold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 12, height: 18 / 12,
    ),
    this.textXsBold = const TextStyle(
      fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12, height: 18 / 12,
    ),
  });

  CustomTextTheme copyWith({
    TextStyle? displayMd,
    TextStyle? displayMdMedium,
    TextStyle? displayMdSemibold,
    TextStyle? displayMdBold,
    TextStyle? displaySm,
    TextStyle? displaySmMedium,
    TextStyle? displaySmSemibold,
    TextStyle? displaySmBold,
    TextStyle? displayXs,
    TextStyle? displayXsMedium,
    TextStyle? displayXsSemibold,
    TextStyle? displayXsBold,
    TextStyle? textXl,
    TextStyle? textXlMedium,
    TextStyle? textXlSemibold,
    TextStyle? textXlBold,
    TextStyle? textLg,
    TextStyle? textLgMedium,
    TextStyle? textLgSemibold,
    TextStyle? textLgBold,
    TextStyle? textMd,
    TextStyle? textMdMedium,
    TextStyle? textMdSemibold,
    TextStyle? textMdBold,
    TextStyle? textSm,
    TextStyle? textSmMedium,
    TextStyle? textSmSemibold,
    TextStyle? textSmBold,
    TextStyle? textXs,
    TextStyle? textXsMedium,
    TextStyle? textXsSemibold,
    TextStyle? textXsBold,
  }) {
    return CustomTextTheme(
      displayMd: displayMd ?? this.displayMd,
      displayMdMedium: displayMdMedium ?? this.displayMdMedium,
      displayMdSemibold: displayMdSemibold ?? this.displayMdSemibold,
      displayMdBold: displayMdBold ?? this.displayMdBold,
      displaySm: displaySm ?? this.displaySm,
      displaySmMedium: displaySmMedium ?? this.displaySmMedium,
      displaySmSemibold: displaySmSemibold ?? this.displaySmSemibold,
      displaySmBold: displaySmBold ?? this.displaySmBold,
      displayXs: displayXs ?? this.displayXs,
      displayXsMedium: displayXsMedium ?? this.displayXsMedium,
      displayXsSemibold: displayXsSemibold ?? this.displayXsSemibold,
      displayXsBold: displayXsBold ?? this.displayXsBold,
      textXl: textXl ?? this.textXl,
      textXlMedium: textXlMedium ?? this.textXlMedium,
      textXlSemibold: textXlSemibold ?? this.textXlSemibold,
      textXlBold: textXlBold ?? this.textXlBold,
      textLg: textLg ?? this.textLg,
      textLgMedium: textLgMedium ?? this.textLgMedium,
      textLgSemibold: textLgSemibold ?? this.textLgSemibold,
      textLgBold: textLgBold ?? this.textLgBold,
      textMd: textMd ?? this.textMd,
      textMdMedium: textMdMedium ?? this.textMdMedium,
      textMdSemibold: textMdSemibold ?? this.textMdSemibold,
      textMdBold: textMdBold ?? this.textMdBold,
      textSm: textSm ?? this.textSm,
      textSmMedium: textSmMedium ?? this.textSmMedium,
      textSmSemibold: textSmSemibold ?? this.textSmSemibold,
      textSmBold: textSmBold ?? this.textSmBold,
      textXs: textXs ?? this.textXs,
      textXsMedium: textXsMedium ?? this.textXsMedium,
      textXsSemibold: textXsSemibold ?? this.textXsSemibold,
      textXsBold: textXsBold ?? this.textXsBold,
    );
  }
}