// design_features.dart
import 'dart:ui';
import 'package:flutter/material.dart';

/// ===== Palette (עיצוב כחול מודרני על רקע כהה) =====
Color buttonsAppbarColors = const Color(0xFF1E3A8A); // כחול כהה - בסיס לכפתורים / AppBar
Color redColor            = const Color(0xFFB91C1C); // אדום נקי וקריא (אפשר להשאיר את הישן אם חייבים)
Color oliveGreenColor     = const Color(0xFF10B981); // "הצלחה" ירקרק-טורקיז רגוע (החלפה נעימה ל-olive)
Color textColorStyle      = const Color(0xFFFFFFFF); // טקסט לבן לקריאות על רקע כהה
Color backgroundColor     = const Color(0xFF0F172A); // רקע מסך כהה (slate-900)

/// אופציונלי: קווי מתאר/מסגרת עדינים
const Color borderColor = Colors.white24;

/// ===== Gradients תואמי-עיצוב (לשימוש חופשי) =====
const LinearGradient appBarGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)], // כחול כהה → כחול בהיר
);

const LinearGradient cardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
);

const LinearGradient pageBackgroundGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF0F172A), Color(0xFF1E293B)], // רקע מסך כהה נעים
);

/// ===== Typography =====
/// שים לב: שמרתי על אותם שמות משתנים כדי לא לשבור קוד קיים.
/// אם תרצה, אפשר לכוונן את הגדלים בהמשך.

TextStyle labelTextStyle = TextStyle(
  color: textColorStyle,
  fontSize: 26,
  fontWeight: FontWeight.w800, // מעט יותר מודגש כדי לבלוט על כרטיסים כחולים
  letterSpacing: 0.2,
);

TextStyle inputTextStyle = TextStyle(
  color: textColorStyle,
  fontSize: 20, // מעט צנוע יותר לקריאות בשדות
  fontWeight: FontWeight.w600,
  letterSpacing: 0.1,
);

TextStyle inputTextStyleUserdata = TextStyle(
  color: textColorStyle,
  fontSize: 20,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.1,
);

TextStyle userMenuTextStyle = TextStyle(
  color: textColorStyle,
  fontSize: 20,
  fontWeight: FontWeight.w700,
);

TextStyle userTakeoutTextStyle = TextStyle(
  color: backgroundColor,
  fontSize: 20,
  fontWeight: FontWeight.w700,
);

TextStyle tableTextStyle = TextStyle(
  color: textColorStyle.withValues(alpha: 0.85), // קצת רך לטבלאות/טקסט משני
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

TextStyle userMenuTextStyleColorless = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
);

/// ===== Helpers (לא חובה) =====
/// קישוט סטנדרטי לכרטיסים (אפשר להשתמש היכן שנוח)
final BoxDecoration cardDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(14),
  gradient: cardGradient,
  border: Border.all(color: borderColor, width: 1),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha:0.25),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
);
