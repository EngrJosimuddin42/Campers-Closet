// analyzing_screen.dart
import 'package:campers_closet/app/modules/scanner/views/scan_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalyzingScreen extends StatefulWidget {
  final String? imagePath;
  const AnalyzingScreen({super.key, this.imagePath});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    // Simulate AI analysis then navigate
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => ScanResultScreen(imagePath: widget.imagePath));
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2E),
      body: SafeArea(
        child: Stack(
          children: [
            // Close button
            Positioned(
              top: 16.h,
              left: 20.w,
              right: 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scanner',
                    style: GoogleFonts.sora(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 34.w,
                      height: 34.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Center content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated scan box
                  ScaleTransition(
                    scale: _pulse,
                    child: Container(
                      width: 180.w,
                      height: 180.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A3E),
                        borderRadius: BorderRadius.circular(28.r),
                        border: Border.all(
                          color: const Color(0xFF2B7FFF),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.auto_awesome,
                          color: const Color(0xFF2B7FFF),
                          size: 52.sp,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 36.h),

                  Text(
                    'Analyzing Item...',
                    style: GoogleFonts.sora(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Text(
                    'Using invisible AI to identify\nmaterial, size, and category.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: Colors.white.withValues(alpha: 0.5),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
