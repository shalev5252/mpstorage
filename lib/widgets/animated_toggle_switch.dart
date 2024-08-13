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

class _ToggleSwitchState extends State<ToggleSwitch> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  var value = 0.0;
  Color addColor = oliveGreenColor;
  String addText = 'החתמה';
  IconData addIcon = Icons.add;

  Color removeColor = redColor;
  String removeText = 'זיכוי';
  IconData removeIcon = Icons.remove;
  bool isAdd = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: Duration(milliseconds: 500),
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    animationController.addListener(() {
      setState(() {
        value = animation.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          if (isAdd) {
            animationController.reverse();
          } else {
            animationController.forward();
          }
          setState(() {
            isAdd = !isAdd;
            widget.onChanged(isAdd); // Notify the parent widget about the change
          });
        },
        child: Container(
          padding: EdgeInsets.all(5),
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color.lerp(addColor,removeColor, value),
            border: Border.all(color: backgroundColor),
          ),
          child: Stack(
            children: <Widget>[
              Center(
                child: Opacity(
                  opacity: 1.0 - value,
                  child: Text(
                    addText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: Opacity(
                  opacity: value,
                  child: Text(
                    removeText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                left: value * 145,
                top: 5,
                child: Transform.rotate(
                  angle: lerpDouble(0, 2 * pi, value)!,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
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
            ],
          ),
        ),
      ),
    );
  }
}
