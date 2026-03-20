import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Hero / Display
  static TextStyle get heroName => GoogleFonts.inter(
        fontSize: 72,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        letterSpacing: -2,
        height: 1.0,
      );

  static TextStyle get heroNameMobile => GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        letterSpacing: -1,
        height: 1.0,
      );

  static TextStyle get heroTitle => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: AppColors.accent,
        letterSpacing: 0.5,
      );

  static TextStyle get heroTitleMobile => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.accent,
        letterSpacing: 0.5,
      );

  static TextStyle get heroSubtitle => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        letterSpacing: 2,
      );

  // Section
  static TextStyle get sectionTitle => GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -1,
      );

  static TextStyle get sectionSubtitle => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // Counter
  static TextStyle get counterValue => GoogleFonts.jetBrainsMono(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: AppColors.accent,
        letterSpacing: -1,
      );

  static TextStyle get counterValueMobile => GoogleFonts.jetBrainsMono(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.accent,
        letterSpacing: -1,
      );

  static TextStyle get counterLabel => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 1.5,
      );

  // Body
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.7,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  // Code / Terminal
  static TextStyle get code => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textTerminal,
      );

  static TextStyle get terminalInput => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textTerminal,
      );

  static TextStyle get terminalPrompt => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.accent,
      );

  // Button
  static TextStyle get buttonLabel => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  // Nav
  static TextStyle get navLink => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.3,
      );

  static TextStyle get navLinkActive => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.accent,
        letterSpacing: 0.3,
      );
}
