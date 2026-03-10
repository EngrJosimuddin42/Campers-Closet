import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NavTab extends StatelessWidget {
  final String label;
  final String icon;
  final bool active;
  final VoidCallback? onTap;

  const NavTab({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InnerShadow(
        shadows: [
          Shadow(
            color: AppColors.buttonPrimaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
          ),
        ],
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: active ? AppColors.buttonPrimaryColor : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                width: 16.w,
                height: 16.h,
                colorFilter: ColorFilter.mode(
                  active ? Colors.white : AppColors.primaryText,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 5.w),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: active ? Colors.white : AppColors.primaryText,
                    ),
                    maxLines: 1,
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
