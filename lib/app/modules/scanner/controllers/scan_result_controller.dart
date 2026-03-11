// scan_result_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanResultController extends GetxController {
  final String? imagePath;
  ScanResultController({this.imagePath});

  // AI Result data
  final RxString itemName = 'Classic Sport shoe'.obs;
  final RxString aiMatchPercent = '96'.obs;
  final RxString imageUrl = ''.obs;

  // Editable fields
  final RxString selectedCategory = 'Clothes'.obs;
  final RxInt quantity = 5.obs;
  final RxString size = 'M'.obs;
  final RxString color = '#1A1AFF'.obs;
  final RxString brand = 'Gap Kids'.obs;
  final RxString notes = ''.obs;

  final categories = ['Clothes', 'Toiletries', 'Gear'];

  // Controllers for text editing
  late final TextEditingController nameController;
  late final TextEditingController sizeController;
  late final TextEditingController brandController;
  late final TextEditingController notesController;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: itemName.value);
    sizeController = TextEditingController(text: size.value);
    brandController = TextEditingController(text: brand.value);
    notesController = TextEditingController(text: notes.value);
  }

  void selectCategory(String cat) => selectedCategory.value = cat;
  void incrementQty() => quantity.value++;
  void decrementQty() {
    if (quantity.value > 1) quantity.value--;
  }

  void retake() => Get.back();

  void addToCloset() {
    // collect all data and save
    Get.snackbar(
      'Saved!',
      '${nameController.text} added to your closet.',
      backgroundColor: const Color(0xFF2B7FFF),
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    sizeController.dispose();
    brandController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
