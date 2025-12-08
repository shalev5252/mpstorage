import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mpstorage/design_features.dart';

class ToggleSwitch extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const ToggleSwitch({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> with TickerProviderStateMixin {
  // בקר להזזה (0..1)
  late final AnimationController _slideCtrl;
  late final Animation<double> _slide;

  // בקר לסיבוב מלא בכל לחיצה (0..1 נכפול ב-2π)
  late final AnimationController _spinCtrl;
  late final Animation<double> _spin;

  bool isAdd = false;

  // טקסט/אייקונים/צבעים (מתוך design_features.dart)
  final Color addColor = oliveGreenColor;
  final String addText = 'החתמה';
  final IconData addIcon = Icons.add;

  final Color removeColor = redColor;
  final String removeText = 'זיכוי';
  final IconData removeIcon = Icons.remove;

  @override
  void initState() {
    super.initState();

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 0.0, // מתחיל בצד "החתמה"
    );
    _slide = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeInOut);

    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _spin = CurvedAnimation(parent: _spinCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _spinCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    // סיבוב מלא בכל לחיצה
    _spinCtrl.forward(from: 0);

    // הזזה לצד הבא
    if (isAdd) {
      _slideCtrl.reverse();
    } else {
      _slideCtrl.forward();
    }

    setState(() => isAdd = !isAdd);
    widget.onChanged(isAdd);
  }

  @override
  Widget build(BuildContext context) {
    // ממדים קבועים (ניתן להחליף ל-MediaQuery אם תרצה רספונסיבי)
    const double totalWidth = 200;
    const double totalHeight = 60;
    const double paddingAll = 5.0;
    const double knobSize = 40.0;

    return Center(
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedBuilder(
          animation: Listenable.merge([_slideCtrl, _spinCtrl]),
          builder: (context, _) {
            final double t = _slide.value;              // 0..1 להזזה/טקסט/צבע
            final double angle = _spin.value * 2 * pi;  // 0..2π לכל לחיצה

            return Container(
              width: totalWidth,
              height: totalHeight,
              padding: const EdgeInsets.all(paddingAll),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.lerp(addColor, removeColor, t),
                border: Border.all(color: backgroundColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Stack(
                children: <Widget>[
                  // טקסט "החתמה" (נעלם עם ההתקדמות)
                  Center(
                    child: Opacity(
                      opacity: 1.0 - t,
                      child: const Text(
                        'החתמה',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  // טקסט "זיכוי" (מופיע עם ההתקדמות)
                  Center(
                    child: Opacity(
                      opacity: t,
                      child: const Text(
                        'זיכוי',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  // הנוב המסתובב — שימוש ב-Align + Padding כדי לא להיחתך בקצוות
                  Align(
                    alignment: Alignment.lerp(
                      Alignment.centerLeft,
                      Alignment.centerRight,
                      t,
                    )!,
                    child: Padding(
                      // מרווח נשימה מהקצוות כדי שלא ייראה "חתוך"
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Transform.rotate(
                        angle: angle,
                        child: Container(
                          height: knobSize,
                          width: knobSize,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            isAdd ? removeIcon : addIcon,
                            color: isAdd ? removeColor : addColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
