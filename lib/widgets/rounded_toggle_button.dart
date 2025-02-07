import 'package:flutter/material.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';

class RoundedToggleButton extends StatelessWidget {
  final String text;
  final String option;
  final bool isSelected;
  final Function(String) onTap;

  const RoundedToggleButton({
    super.key,
    required this.text,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(option),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).selectedToggleBorder
                : Theme.of(context).unSelectedToggleBorder,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: Font.kDefaultFont,
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Theme.of(context).selectedToggleText
                : Theme.of(context).unSelectedToggleText,
          ),
        ),
      ),
    );
  }
}
