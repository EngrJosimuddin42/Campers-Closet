import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopNowBanner extends StatelessWidget {
  final VoidCallback? onShopNow;

  const ShopNowBanner({super.key, this.onShopNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 10.w,
        top: 20.h,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EF),
        borderRadius: BorderRadius.circular(32.r),
        border: Border(
          left: BorderSide(color: const Color(0xFF27AE60), width: 2.5),
          right: BorderSide(color: const Color(0xFF27AE60), width: 2.5),
        ),
      ),
      child: Row(
        children: [
          // Text section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Need anything?',
                  style: GoogleFonts.sora(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Buy missing items instantly',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Button
          GestureDetector(
            onTap: onShopNow,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF27AE60), Color(0xFF27AE60)],
                ),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Text(
                'Shop Now',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
