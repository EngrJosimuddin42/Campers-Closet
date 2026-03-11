// scanner_screen.dart
import 'package:camera/camera.dart';
import 'package:campers_closet/app/modules/scanner/controllers/scanner_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ScannerController());

    return Scaffold(
      backgroundColor: const Color(0xFF4A7A8A),
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview fills screen
            Obx(() {
              if (!ctrl.isInitialized.value) {
                return Container(color: const Color(0xFF4A7A8A));
              }
              return SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: ctrl.cameraController!.value.previewSize!.height,
                    height: ctrl.cameraController!.value.previewSize!.width,
                    child: CameraPreview(ctrl.cameraController!),
                  ),
                ),
              );
            }),

            // Dark overlay top & bottom
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(flex: 2, child: Container(color: Colors.black26)),
                  Expanded(
                    flex: 5,
                    child: Container(color: Colors.transparent),
                  ),
                  Expanded(flex: 3, child: Container(color: Colors.black26)),
                ],
              ),
            ),

            // Header
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
                        color: Colors.white.withValues(alpha: 0.25),
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

            // Auto-detecting pill
            Obx(
              () => Positioned(
                top: 110.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B7FFF),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      ctrl.statusLabel.value,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Scan frame corners
            Center(
              child: SizedBox(
                width: 240.w,
                height: 240.w,
                child: CustomPaint(painter: _FramePainter()),
              ),
            ),

            // Bottom controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 40.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E4A56).withValues(alpha: 0.95),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Manual
                        _BottomAction(
                          icon: Icons.add_rounded,
                          label: 'MANUAL',
                          onTap: ctrl.onManual,
                        ),

                        // Capture button
                        GestureDetector(
                          onTap: ctrl.onCapture,
                          child: Container(
                            width: 70.w,
                            height: 70.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: Container(
                                width: 54.w,
                                height: 54.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 26.sp,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Gallery
                        _BottomAction(
                          icon: Icons.palette_outlined,
                          label: 'GALLERY',
                          onTap: ctrl.onGallery,
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Hint
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Align item within frame for AI recognition',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Corner frame painter
class _FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 30.0;
    const r = 10.0;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, len + r)
        ..lineTo(0, r)
        ..arcToPoint(const Offset(r, 0), radius: const Radius.circular(r))
        ..lineTo(len + r, 0),
      paint,
    );
    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - len - r, 0)
        ..lineTo(size.width - r, 0)
        ..arcToPoint(Offset(size.width, r), radius: const Radius.circular(r))
        ..lineTo(size.width, len + r),
      paint,
    );
    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - len - r)
        ..lineTo(0, size.height - r)
        ..arcToPoint(Offset(r, size.height), radius: const Radius.circular(r))
        ..lineTo(len + r, size.height),
      paint,
    );
    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - len - r, size.height)
        ..lineTo(size.width - r, size.height)
        ..arcToPoint(
          Offset(size.width, size.height - r),
          radius: const Radius.circular(r),
        )
        ..lineTo(size.width, size.height - len - r),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
