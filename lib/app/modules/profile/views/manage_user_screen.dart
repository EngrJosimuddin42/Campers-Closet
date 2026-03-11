// manage_users_screen.dart
import 'package:campers_closet/app/modules/profile/controllers/manage_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────
class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put<ManageUsersController>(ManageUsersController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 22.sp,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Accounts',
                    style: GoogleFonts.sora(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),
              // ── Section title
              Text(
                'Active Accounts',
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8E9BB5),
                ),
              ),
              SizedBox(height: 14.h),

              // ── Account cards — each is its OWN separate card
              Obx(
                () => Column(
                  children: List.generate(ctrl.accounts.length, (i) {
                    final account = ctrl.accounts[i];
                    final isSelected = ctrl.selectedIndex.value == i;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _AccountCard(
                        account: account,
                        isSelected: isSelected,
                        onTap: () => ctrl.selectAccount(i),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 8.h),

              // ── Add New Child Account button
              _AddChildButton(onTap: ctrl.addChildAccount),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Individual account card ──────────────────────────────────────────────────
class _AccountCard extends StatelessWidget {
  final AccountModel account;
  final bool isSelected;
  final VoidCallback onTap;

  const _AccountCard({
    required this.account,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEEF4FF) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: isSelected
            ? Border.all(color: const Color(0xFF2B7FFF), width: 1.5)
            : Border.all(color: Colors.transparent, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                // Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    account.avatarUrl,
                    width: 46.w,
                    height: 46.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 46.w,
                      height: 46.w,
                      color: const Color(0xFFEEF1F8),
                      child: const Icon(Icons.person, color: Color(0xFFB0BAD3)),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),

                // Name + role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        account.role,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF90A1B9),
                        ),
                      ),
                    ],
                  ),
                ),

                // Checkmark (animated visibility)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isSelected ? 1.0 : 0.0,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2B7FFF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Add New Child Account button ─────────────────────────────────────────────
class _AddChildButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddChildButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: const Color(0xFFDDE3F0), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                color: const Color(0xFF8E9BB5),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Add New Child Account',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8E9BB5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
