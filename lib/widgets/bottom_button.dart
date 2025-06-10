import 'package:concert_schedule/const/colors.dart';
import 'package:concert_schedule/const/text_style.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double? width, height;
  final String text;

  const BottomButton
      ({
        super.key,
        this.width,
        this.height,
        required this.text,
        this.onTap
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ContiColors.orange200,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          text,
          style: ContiTextStyle.loginJoinButton,
        ),
      ),
    );
  }
}
