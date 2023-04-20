import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String buttonTitle;
  final Color backgroundColor;
  final Color textColor;
  final Function() onPress;
  final double height;
  final double? width;
  final IconData? icon;
  final Color? iconColor;
  final bool disabled;
  final InteractiveInkFeatureFactory? splashFactory;
  const CustomButton(
      {required this.buttonTitle,
      required this.backgroundColor,
      required this.textColor,
      required this.onPress,
      this.width,
      required this.disabled,
      required this.height,
      this.icon,
      this.splashFactory,
      this.iconColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? 40, height),
        splashFactory: splashFactory,
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      onPressed: disabled ? null : onPress,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          buttonTitle,
          style: GoogleFonts.lato(
              textStyle: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              icon,
              color: iconColor ?? Colors.white,
            ),
          )
      ]),
    );
  }
}
