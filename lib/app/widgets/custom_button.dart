import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.color,
    this.textStyle,
    this.radius,
    this.margin = EdgeInsets.zero,
    required this.onTap,
    required this.text,
    this.loading = false,
    this.width,
    this.height,
    this.fontSize,
    this.svgIcon,
    this.logoColor,
  });
  final Function()? onTap;
  final String text;
  final bool loading;
  final double? height;
  final double? width;
  final Color? color;
  final double? radius;
  final EdgeInsetsGeometry margin;
  final TextStyle? textStyle;
  final double? fontSize;
  final String? svgIcon;
  final Color? logoColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ElevatedButton(
        onPressed: loading ? () {} : onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 16.r),
          ),
          backgroundColor: color ?? AppColors.buttonPrimaryColor,
          minimumSize: Size(width ?? Get.width, height ?? 60.h),
        ),
        child: loading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: const CircularProgressIndicator(color: Colors.white),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (svgIcon != null) ...[
                    SvgPicture.asset(
                      svgIcon!,
                      width: 18.sp,
                      height: 18.sp,
                      colorFilter: ColorFilter.mode(
                        logoColor ?? Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    text,
                    style:
                        textStyle ??
                        AppTextStyles.title20_500(color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}
