import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText = 'View All',
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.sora(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: onActionTap,
          child: Text(
            actionText,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.buttonPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
