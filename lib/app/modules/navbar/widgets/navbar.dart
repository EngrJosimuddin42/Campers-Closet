import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:campers_closet/app/modules/navbar/controllers/navbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  static const double _fabOverlap = 20.0;
  static const double _barHeight = 66.0;

  @override
  Widget build(BuildContext context) {
    final NavbarController ctrl = Get.find<NavbarController>();

    return Obx(() {
      final selected = ctrl.selectedTab.value;

      return SizedBox(
        height: _barHeight + _fabOverlap,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    height: _barHeight,
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        _NavItem(
                          icon: AppLogos.home,
                          label: 'Home',
                          isSelected: selected == 0,
                          onTap: () => ctrl.changeTab(0),
                        ),
                        _NavItem(
                          icon: AppLogos.closet,
                          label: 'Closet',
                          isSelected: selected == 1,
                          onTap: () => ctrl.changeTab(1),
                        ),
                        SizedBox(width: 80.w),
                        _NavItem(
                          icon: AppLogos.navcalendar,
                          label: 'Calendar',
                          isSelected: selected == 2,
                          onTap: () => ctrl.changeTab(2),
                        ),
                        _NavItem(
                          icon: AppLogos.user,
                          label: 'Profile',
                          isSelected: selected == 3,
                          onTap: () => ctrl.changeTab(3),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─── Reusable nav item ───────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  static final _activeColor = AppColors.buttonPrimaryColor;
  static final _inactiveColor = AppColors.primaryText;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? _activeColor : _inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 11.sp.clamp(9.0, 13.0),
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}