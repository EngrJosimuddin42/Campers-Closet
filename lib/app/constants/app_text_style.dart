import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle title30_400({Color? color}) => GoogleFonts.sora(
    fontSize: 30.sp,
    fontWeight: FontWeight.w400,
    color: color,
  );

  static TextStyle title25_500({Color? color}) => GoogleFonts.sora(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: color,
  );
  static TextStyle title26_600({Color? color}) => GoogleFonts.sora(
    fontSize: 26.sp,
    fontWeight: FontWeight.w600,
    color: color,
  );
  static TextStyle title27_600({Color? color}) => GoogleFonts.sora(
    fontSize: 27.sp,
    fontWeight: FontWeight.w600,
    color: color,
  );
  static TextStyle title28_600({Color? color}) => GoogleFonts.sora(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    color: color,
  );
  static TextStyle title23_500({Color? color}) => GoogleFonts.sora(
    fontSize: 23.sp,
    fontWeight: FontWeight.w500,
    color: color,
  );
  static TextStyle title26_500({Color? color}) => GoogleFonts.sora(
    fontSize: 26.sp,
    fontWeight: FontWeight.w500,
    color: color,
  );
  static TextStyle title14_500({Color? color}) => GoogleFonts.sora(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: color,
  );
  static TextStyle title14_400({Color? color}) => GoogleFonts.sora(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: color,
  );
  static TextStyle title16_500({Color? color}) => GoogleFonts.sora(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: color,
  );
  static TextStyle title20_500({Color? color}) => GoogleFonts.sora(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: color,
  );
  static TextStyle title20_400({Color? color}) => GoogleFonts.sora(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: color,
  );
  static TextStyle title16_800({Color? color}) => GoogleFonts.sora(
    fontSize: 16.sp,
    fontWeight: FontWeight.w800,
    color: color,
  );
  static TextStyle title16_600({Color? color}) => GoogleFonts.sora(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: color,
  );
  static TextStyle title16_400({Color? color}) => GoogleFonts.sora(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: color,
  );
  static TextStyle title12_500({Color? color}) => GoogleFonts.sora(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: color,
  );
  static TextStyle title12_400({Color? color}) => GoogleFonts.sora(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: color,
  );
  static TextStyle title12_600({Color? color}) => GoogleFonts.sora(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: color,
  );
  static TextStyle title20_600({Color? color}) => GoogleFonts.sora(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: color,
  );
  static TextStyle title22_600({Color? color}) => GoogleFonts.sora(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    color: color,
  );
  static TextStyle title21_600({Color? color}) => GoogleFonts.sora(
    fontSize: 21.sp,
    fontWeight: FontWeight.w600,
    color: color,
  );
  static TextStyle title18_500({Color? color}) => GoogleFonts.sora(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: color,
  );
  static TextStyle title18_400({Color? color}) => GoogleFonts.sora(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: color,
  );
  static TextStyle title24_600({Color? color}) => GoogleFonts.sora(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: color,
  );
  static TextStyle title24_500({Color? color}) => GoogleFonts.sora(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
    color: color,
  );
  static TextStyle title30_700({Color? color}) => GoogleFonts.sora(
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    color: color,
  );
  static TextStyle title52_700({Color? color}) => GoogleFonts.sora(
    fontSize: 52.sp,
    fontWeight: FontWeight.w700,
    color: color,
  );
  static TextStyle title19_300({Color? color}) => GoogleFonts.sora(
    fontSize: 19.sp,
    fontWeight: FontWeight.w300,
    color: color,
  );
  static TextStyle title15_400({Color? color}) => GoogleFonts.sora(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: color,
  );
  static TextStyle title15_300({Color? color}) => GoogleFonts.sora(
    fontSize: 15.sp,
    fontWeight: FontWeight.w300,
    color: color,
  );
}

extension TextStyleExtension on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);
}
