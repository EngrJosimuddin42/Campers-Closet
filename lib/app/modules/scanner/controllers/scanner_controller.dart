// scanner_controller.dart
import 'package:camera/camera.dart';
import 'package:campers_closet/app/modules/scanner/views/analyze_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerController extends GetxController {
  CameraController? cameraController;
  final RxBool isInitialized = false.obs;
  final RxBool isDetecting = true.obs;
  final RxString statusLabel = 'AUTO-DETECTING...'.obs;
  final RxString capturedImagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      Get.snackbar('Permission Denied', 'Camera access is required');
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController!.initialize();
    isInitialized.value = true;
  }

  void onCapture() async {
    statusLabel.value = 'SCANNING...';
    Future.delayed(const Duration(seconds: 2), () {
      statusLabel.value = 'AUTO-DETECTING...';
    });
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    final XFile image = await cameraController!.takePicture();
    capturedImagePath.value = image.path;

    print(
      'Captured image path -----------------------------------------------------------------------------------------------------: ${capturedImagePath.value}',
    );

    Get.to(
      () => AnalyzingScreen(imagePath: capturedImagePath.value),
      transition: Transition.fadeIn,
    );
  }

  void onManual() {
    debugPrint('Manual pressed');
  }

  void onGallery() {
    debugPrint('Gallery pressed');
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
