import 'package:flutter/material.dart';
import 'package:concert_schedule/const/colors.dart';

const TextStyle _baseTextStyle = TextStyle(
  fontFamily: 'Inter',
  overflow: TextOverflow.ellipsis,
);

abstract final class ContiTextStyle {
  /// Login/Join
  static TextStyle loginJoinText = _baseTextStyle.copyWith(
    color: ContiColors.mainBlack,
    fontSize: 10,
    fontWeight: FontWeight.w100,
  );

  static TextStyle loginJoinField = _baseTextStyle.copyWith(
    color: ContiColors.mainBlack,
    fontSize: 24,
    fontWeight: FontWeight.w200,
  );

  static TextStyle loginJoinButton = _baseTextStyle.copyWith(
    color: ContiColors.white,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  /// Warning
  static TextStyle warning(Color color) => _baseTextStyle.copyWith(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );

  static TextStyle smallWarn(Color color) => _baseTextStyle.copyWith(
        color: color,
        fontSize: 7,
        fontWeight: FontWeight.w500,
      );

  /// Main
  static TextStyle mainTab = _baseTextStyle.copyWith(
    color: ContiColors.mainOrange,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static TextStyle mainRecommend = _baseTextStyle.copyWith(
    color: ContiColors.white,
    fontSize: 5,
    fontWeight: FontWeight.w600,
  );

  /// Search
  static TextStyle searchText = _baseTextStyle.copyWith(
    color: ContiColors.mainBlack,
    fontSize: 7,
    fontWeight: FontWeight.w500,
  );

  /// Hint
  static TextStyle hint = _baseTextStyle.copyWith(
    color: ContiColors.black500,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle noResult(Color color) => _baseTextStyle.copyWith(
        color: color,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      );

  /// Slide
  static TextStyle slideLocation = _baseTextStyle.copyWith(
    color: ContiColors.white,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle slideDate = _baseTextStyle.copyWith(
    color: ContiColors.white,
    fontSize: 8,
    fontWeight: FontWeight.w500,
  );

  static TextStyle slideTitle = _baseTextStyle.copyWith(
    color: ContiColors.white,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  /// Calendar
  static TextStyle calendarDate = _baseTextStyle.copyWith(
    color: ContiColors.black700,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  /// Titles
  static TextStyle title = _baseTextStyle.copyWith(
    color: ContiColors.mainBlack,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static TextStyle listTitle = _baseTextStyle.copyWith(
    color: ContiColors.mainOrange,
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  /// List Items
  static TextStyle listLocationDate = _baseTextStyle.copyWith(
    color: ContiColors.mainBlack,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle locationDateTitle = _baseTextStyle.copyWith(
    color: ContiColors.mainOrange,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static TextStyle locationDate = _baseTextStyle.copyWith(
    color: ContiColors.mainBlack,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  /// Buttons
  static TextStyle button = _baseTextStyle.copyWith(
    color: ContiColors.white,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static TextStyle thinButton(Color color) => _baseTextStyle.copyWith(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );

  static TextStyle modifyDelete = _baseTextStyle.copyWith(
    color: ContiColors.mainBlack,
    fontSize: 8,
    fontWeight: FontWeight.w500,
  );

  /// Others
  static TextStyle modifyText = _baseTextStyle.copyWith(
    color: ContiColors.black500,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle id = _baseTextStyle.copyWith(
    color: ContiColors.black,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static TextStyle editLogout = _baseTextStyle.copyWith(
    color: ContiColors.mainBlack,
    fontSize: 8,
    fontWeight: FontWeight.w500,
  );
}
