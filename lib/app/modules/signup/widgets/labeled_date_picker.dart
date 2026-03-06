import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_text_style.dart';
import 'package:campers_closet/app/widgets/custom_text_field.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class LabeledDatePicker extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String prefixIcon;
  final String hintText;
  final RxString errorMessage;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final double bottomPadding;

  const LabeledDatePicker({
    super.key,
    required this.label,
    required this.controller,
    required this.prefixIcon,
    required this.hintText,
    required this.errorMessage,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.bottomPadding = 12,
  });

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          initialDate ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.primaryText,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      controller.text = formattedDate;
      errorMessage.value = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.title12_400(color: AppColors.primaryText),
        ),
        SizedBox(height: 5.h),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: CustomTextField(
              controller: controller,
              prefixIcon: prefixIcon,
              hintText: hintText,
              isEmail: false,
              isPassword: false,
              textInputAction: TextInputAction.next,
              onValidationError: (error) {
                errorMessage.value = error ?? '';
              },
            ),
          ),
        ),
        Obx(
          () => errorMessage.value.isNotEmpty
              ? Text(
                  errorMessage.value,
                  style: AppTextStyles.title12_400(color: AppColors.errorColor),
                ).paddingTop(5.h)
              : const SizedBox.shrink(),
        ),
      ],
    ).paddingBottom(bottomPadding.h);
  }
}
