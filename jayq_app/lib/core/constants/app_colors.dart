import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Modern Blue
  static const Color primary = Color(0xFF1E3A8A); // Deep Blue
  static const Color primaryLight = Color(0xFF3B82F6); // Bright Blue
  static const Color primaryDark = Color(0xFF1E40AF); // Darker Blue

  // Secondary Colors
  static const Color secondary = Color(0xFF6366F1); // Indigo
  static const Color accent = Color(0xFF8B5CF6); // Purple

  // Background Colors
  static const Color background = Color(0xFFF8FAFC); // Light Gray
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceLight = Color(0xFFF1F5F9); // Very Light Gray

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Almost Black
  static const Color textSecondary = Color(0xFF64748B); // Gray
  static const Color textLight = Color(0xFF94A3B8); // Light Gray
  static const Color textWhite = Color(0xFFFFFFFF); // White

  // Status Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Orange
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
  );

  // Shadow Colors
  static const Color shadow = Color(0x1A000000); // 10% Black
  static const Color shadowLight = Color(0x0D000000); // 5% Black

  // Border Colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // Role Colors
  static const Color adminColor = Color(0xFFEF4444); // Red
  static const Color dosenColor = Color(0xFF3B82F6); // Blue
  static const Color mahasiswaColor = Color(0xFF10B981); // Green
}
