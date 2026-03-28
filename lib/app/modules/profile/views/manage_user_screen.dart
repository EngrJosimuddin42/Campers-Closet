import 'package:campers_closet/app/modules/profile/controllers/manage_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.isRegistered<ManageUsersController>()
        ? Get.find<ManageUsersController>()
        : Get.put<ManageUsersController>(
      ManageUsersController(),
      permanent: true,
    );
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header
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

              Text(
                'Active Accounts',
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8E9BB5),
                ),
              ),
              SizedBox(height: 14.h),
              Expanded(
                child: Obx(() {
                  // Loading state
                  if (ctrl.isLoading.value && ctrl.accounts.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2B7FFF),
                      ),
                    );
                  }

                  // Error state
                  if (ctrl.errorMessage.value.isNotEmpty &&
                      ctrl.accounts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wifi_off_rounded,
                            size: 40.sp,
                            color: const Color(0xFFB0BAD3),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            ctrl.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: const Color(0xFF90A1B9),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          GestureDetector(
                            onTap: ctrl.fetchAccounts,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2B7FFF),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'Retry',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // ListView.builder এ:
                  return ListView.builder(
                    itemCount: ctrl.accounts.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, i) {
                      final account = ctrl.accounts[i];
                      final isSelected = ctrl.selectedIndex.value == i;
                      final bool isDisabled = !ctrl.isParentLoggedIn.value &&
                          account.role.toLowerCase() == 'parent';

                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _AccountCard(
                          account: account,
                          isSelected: isSelected,
                          isDisabled: isDisabled,
                          onTap: isDisabled ? null : () => ctrl.selectAccount(i),
                        ),
                      );
                    },
                  );
                }),
              ),

              SizedBox(height: 8.h),

              // ── Add New Child Account
              Obx(() => ctrl.isParentLoggedIn.value
                  ? _AddChildButton(onTap: ctrl.addChildAccount)
                  : const SizedBox.shrink()),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Account Card
class _AccountCard extends StatelessWidget {
  final AccountModel account;
  final bool isDisabled;
  final bool isSelected;
  final VoidCallback? onTap;

  const _AccountCard({
    required this.account,
    required this.isSelected,
    this.isDisabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isDisabled
            ? const Color(0xFFF5F5F5)
            : isSelected
            ? const Color(0xFFEEF4FF)
            : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: isSelected && !isDisabled
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
          child: Opacity(
            opacity: isDisabled ? 0.4 : 1.0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                // ── Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: account.avatarUrl.isNotEmpty
                      ? Image.network(
                    account.avatarUrl,
                    width: 46.w,
                    height: 46.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _defaultAvatar(),
                  )
                      : _defaultAvatar(),
                ),
                SizedBox(width: 14.w),

                // ── Name + Role
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
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: account.role.toLowerCase() == 'parent'
                                  ? const Color(0xFFEEF4FF)
                                  : const Color(0xFFF0FFF4),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              account.role,
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: account.role.toLowerCase() == 'parent'
                                    ? const Color(0xFF2B7FFF)
                                    : const Color(0xFF27AE60),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Checkmark
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
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      width: 46.w,
      height: 46.w,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF1F8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: const Icon(Icons.person, color: Color(0xFFB0BAD3)),
    );
  }
}

// ─── Add Child Button
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