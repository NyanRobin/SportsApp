import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppTheme {
  // Apple-inspired colors
  static const Color systemBlue = Color(0xFF007AFF);
  static const Color systemBlueLight = Color(0xFF5AC8FA);
  static const Color systemGray = Color(0xFF8E8E93);
  static const Color systemGray2 = Color(0xFFAEAEB2);
  static const Color systemGray3 = Color(0xFFC7C7CC);
  static const Color systemGray4 = Color(0xFFD1D1D6);
  static const Color systemGray5 = Color(0xFFE5E5EA);
  static const Color systemGray6 = Color(0xFFF2F2F7);
  
  // Primary colors
  static const Color primaryColor = systemBlue;
  static const Color accentColor = systemBlueLight;
  
  // Background colors
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  
  // Dark mode colors
  static const Color darkBackgroundColor = Color(0xFF000000);
  static const Color darkSurfaceColor = Color(0xFF1C1C1E);
  static const Color darkCardColor = Color(0xFF2C2C2E);
  
  // Text colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF3C3C43);
  static const Color textTertiary = Color(0xFF8E8E93);
  
  // Dark text colors
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFEBEBF5);
  static const Color darkTextTertiary = Color(0xFF8E8E93);
  
  // Semantic colors
  static const Color errorColor = Color(0xFFFF3B30);
  static const Color successColor = Color(0xFF30D158);
  static const Color warningColor = Color(0xFFFF9500);
  
  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      offset: const Offset(0, 2),
      blurRadius: 10,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      offset: const Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      offset: const Offset(0, 4),
      blurRadius: 20,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      offset: const Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  // Typography
  static const String primaryFontFamily = 'SF Pro Display';
  static const String bodyFontFamily = 'SF Pro Text';
  
  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: bodyFontFamily,
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: Colors.white,
        outline: systemGray4,
        outlineVariant: systemGray5,
      ),
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: textPrimary,
          size: 24,
        ),
        titleTextStyle: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.24,
        ),
      ),
      
      // Text theme
      textTheme: const TextTheme(
        // Large titles
        displayLarge: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.41,
          height: 1.18,
        ),
        displayMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.36,
          height: 1.21,
        ),
        displaySmall: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.26,
          height: 1.27,
        ),
        
        // Headlines
        headlineLarge: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.24,
          height: 1.30,
        ),
        headlineMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.24,
          height: 1.29,
        ),
        headlineSmall: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.23,
          height: 1.33,
        ),
        
        // Titles
        titleLarge: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          letterSpacing: -0.24,
          height: 1.29,
        ),
        titleMedium: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          letterSpacing: -0.23,
          height: 1.33,
        ),
        titleSmall: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          letterSpacing: -0.08,
          height: 1.38,
        ),
        
        // Body text
        bodyLarge: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          letterSpacing: -0.24,
          height: 1.29,
        ),
        bodyMedium: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          letterSpacing: -0.23,
          height: 1.33,
        ),
        bodySmall: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textTertiary,
          letterSpacing: -0.08,
          height: 1.38,
        ),
        
        // Labels
        labelLarge: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          letterSpacing: -0.23,
          height: 1.33,
        ),
        labelMedium: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textSecondary,
          letterSpacing: -0.08,
          height: 1.38,
        ),
        labelSmall: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textTertiary,
          letterSpacing: 0.07,
          height: 1.45,
        ),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: bodyFontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.24,
          ),
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: bodyFontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.24,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: const BorderSide(color: systemGray4, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: bodyFontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.24,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: bodyFontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.24,
          ),
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: systemGray6,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        hintStyle: const TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: systemGray,
          letterSpacing: -0.24,
        ),
        labelStyle: const TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          letterSpacing: -0.23,
        ),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: systemGray5,
        thickness: 0.5,
        space: 1,
      ),
      
      // List tile theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        horizontalTitleGap: 16,
        minLeadingWidth: 24,
        titleTextStyle: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          letterSpacing: -0.24,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          letterSpacing: -0.23,
        ),
      ),
      
      // Tab bar theme
      tabBarTheme: const TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: systemGray,
        indicatorColor: primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.23,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.23,
        ),
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: systemGray,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.07,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.07,
        ),
      ),
    );
  }
  
  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      fontFamily: bodyFontFamily,
      
      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: darkSurfaceColor,
        background: darkBackgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
        onBackground: darkTextPrimary,
        onError: Colors.white,
        outline: Color(0xFF545458),
        outlineVariant: Color(0xFF48484A),
      ),
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: darkTextPrimary,
          size: 24,
        ),
        titleTextStyle: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
          letterSpacing: -0.24,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: darkCardColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1C1C1E),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        hintStyle: const TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: systemGray,
          letterSpacing: -0.24,
        ),
        labelStyle: const TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: darkTextSecondary,
          letterSpacing: -0.23,
        ),
      ),
      
      // Update other themes for dark mode...
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: darkTextPrimary,
          letterSpacing: -0.41,
          height: 1.18,
        ),
        headlineMedium: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
          letterSpacing: -0.24,
          height: 1.29,
        ),
        bodyLarge: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: darkTextPrimary,
          letterSpacing: -0.24,
          height: 1.29,
        ),
        bodyMedium: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: darkTextSecondary,
          letterSpacing: -0.23,
          height: 1.33,
        ),
        bodySmall: TextStyle(
          fontFamily: bodyFontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: darkTextTertiary,
          letterSpacing: -0.08,
          height: 1.38,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: bodyFontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.24,
          ),
        ),
      ),
      
      dividerTheme: const DividerThemeData(
        color: Color(0xFF38383A),
        thickness: 0.5,
        space: 1,
      ),
    );
  }
}

// Custom widget extensions for Apple-style design
extension AppleWidgetExtensions on Widget {
  Widget appleCard({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color ?? AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: boxShadow ?? AppTheme.cardShadow,
      ),
      child: this,
    );
  }
  
  Widget appleElevated({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color ?? AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: this,
    );
  }
}