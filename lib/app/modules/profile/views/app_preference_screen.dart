import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPreferencesScreen extends StatefulWidget {
  const AppPreferencesScreen({super.key});

  @override
  State<AppPreferencesScreen> createState() => _AppPreferencesScreenState();
}

class _AppPreferencesScreenState extends State<AppPreferencesScreen> {
  bool _biometrics = true;
  bool _pushNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────────────────
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16.sp,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'App Preferences',
                    style: GoogleFonts.sora(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 28.h),

              // ── Security ───────────────────────────────────────
              _SectionLabel(label: 'SECURITY'),
              SizedBox(height: 10.h),
              _PrefsCard(
                children: [
                  _ToggleTile(
                    icon: Icons.fingerprint_rounded,
                    iconColor: const Color(0xFF10B981),
                    label: 'Biometric Login',
                    value: _biometrics,
                    isFirst: true,
                    isLast: true,
                    onChanged: (v) => setState(() => _biometrics = v),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // ── Notifications ──────────────────────────────────
              _SectionLabel(label: 'NOTIFICATIONS'),
              SizedBox(height: 10.h),
              _PrefsCard(
                children: [
                  _ToggleTile(
                    icon: Icons.notifications_active_outlined,
                    iconColor: const Color(0xFFF5A623),
                    label: 'Push Notifications',
                    value: _pushNotifications,
                    isFirst: true,
                    isLast: true,
                    onChanged: (v) => setState(() => _pushNotifications = v),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // ── Danger Zone ────────────────────────────────────
              _SectionLabel(label: 'DANGER ZONE'),
              SizedBox(height: 10.h),
              _PrefsCard(
                children: [
                  _ActionTile(
                    icon: Icons.no_accounts_outlined,
                    iconColor: const Color(0xFFE53935),
                    label: 'Delete Account',
                    isFirst: true,
                    isLast: true,
                    isDestructive: true,
                    onTap: () => _showDeleteConfirmation(context),
                  ),
                ],
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Delete Account?',
          style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 18.sp),
        ),
        content: Text(
          'This action is permanent and cannot be undone. All your data will be erased.',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: const Color(0xFF90A1B9),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: const Color(0xFF90A1B9)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                color: const Color(0xFFE53935),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: const Color(0xFF90A1B9),
      ),
    );
  }
}

class _PrefsCard extends StatelessWidget {
  final List<Widget> children;
  const _PrefsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool value;
  final bool isFirst;
  final bool isLast;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.isFirst = false,
    this.isLast = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 13.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2B7FFF),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool isFirst;
  final bool isLast;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.isFirst = false,
    this.isLast = false,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(18.r) : Radius.zero,
          bottom: isLast ? Radius.circular(18.r) : Radius.zero,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDestructive
                        ? const Color(0xFFE53935)
                        : const Color(0xFF1A1A2E),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: const Color(0xFFCBD5E1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
