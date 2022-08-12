import 'package:flutter/material.dart';



class Indicator extends StatelessWidget {
  final int positionIndex, currentIndex;
  final Color color;
  const Indicator({required this.currentIndex, required this.positionIndex,required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 3,right: 3),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        // border: Border.all(color: AppColors.indicator),
          color: color == null ? positionIndex == currentIndex
              ? Colors.blue
              : Colors.white : positionIndex == currentIndex
              ? Colors.blue
              : Colors.white,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}

