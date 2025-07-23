import 'package:flutter/material.dart';
import 'package:bizsignal_app/constants/app_colors.dart';

class CommonToggleButton extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double height;
  final double borderRadius;
  final double fontSize;

  const CommonToggleButton({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    this.height = 36,
    this.borderRadius = 8,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(options.length, (idx) {
        final bool isSelected = idx == selectedIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(idx),
            child: Container(
              height: height,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: idx == 0 ? 0 : 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.white : AppColors.gray100,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Text(
                options[idx],
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.gray600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
