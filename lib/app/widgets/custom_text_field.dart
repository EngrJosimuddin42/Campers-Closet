import 'package:campers_closet/app/constants/app_colors.dart';
import 'package:campers_closet/app/constants/app_constants.dart';
import 'package:campers_closet/app/constants/app_logos.dart';
import 'package:campers_closet/app/constants/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';


class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? obscure;
  final Color? fillColor;
  final String? prefixIcon;
  final String? labelText;
  final String? hintText;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final bool isPassword;
  final bool? isEmail;
  final bool readOnly;
  final Function(String?)? onValidationError;
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.isEmail,
    this.onValidationError,
    required this.controller,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.obscure = '*',
    this.fillColor,
    this.labelText,
    this.isPassword = false,
    this.textInputAction,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? _validateField(String? value) {
    String? error;

    if (widget.validator != null) {
      error = widget.validator!(value);
    } else {
      if (value == null || value.isEmpty) {
        error = "Please enter ${widget.hintText?.toLowerCase() ?? 'value'}";
      } else if (widget.isEmail == true) {
        if (!AppConstants.emailValidator.hasMatch(value)) {
          error = "Please check your email!";
        }
      } else if (widget.isPassword) {
        if (!AppConstants.passwordValidator.hasMatch(value)) {
          error = "Insecure password detected.";
        }
      }
    }

    // Notify parent widget about validation error
    widget.onValidationError?.call(error);
    return error;
  }

  Widget _buildSuffixIcon() {
    if (widget.isPassword) {
      return GestureDetector(
        onTap: _toggleObscureText,
        child: _buildSvgIcon(
          _obscureText ? AppLogos.eyecloselogo : AppLogos.eyelogo,
        ),
      );
    }
    return widget.suffixIcon ?? const SizedBox.shrink();
  }

  Widget _buildSvgIcon(String icon, {double padding = 12}) {
    return SvgPicture.asset(
      icon,
      width: 20.w,
      height: 20.h,
      colorFilter: ColorFilter.mode(
        AppColors.buttonPrimaryColor,
        BlendMode.srcIn,
      ),
    ).paddingAll(padding.w);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscuringCharacter: widget.obscure ?? '*',
      textInputAction: widget.textInputAction,
      validator: _validateField,
      cursorColor: AppColors.primaryColor,
      obscureText: _obscureText,
      readOnly: widget.readOnly,
      autovalidateMode: AutovalidateMode.disabled,
      onChanged: (value) {
        if (widget.onValidationError != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onValidationError?.call(null);
          });
        }
      },
      style: AppTextStyles.title12_400(color: AppColors.darkColor),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(12.w),
        fillColor: widget.fillColor,
        prefixIcon: widget.prefixIcon != null
            ? _buildSvgIcon(widget.prefixIcon!, padding: 10.w)
            : null,
        suffixIcon: _buildSuffixIcon(),
        prefixIconConstraints: BoxConstraints(minHeight: 24.w, minWidth: 24.w),
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorStyle: const TextStyle(
          height: 0,
          fontSize: 0,
        ), // Hide default error
        border: _buildBorder(AppColors.buttonPrimaryColor, 1.w),
        hintStyle: TextStyle(color: AppColors.hintColor, fontSize: 16.sp),
        errorBorder: _buildBorder(AppColors.errorColor, 1.w),
        enabledBorder: _buildBorder(AppColors.buttonPrimaryColor, 1.w),
        focusedBorder: _buildBorder(AppColors.buttonPrimaryColor, 1.5.w),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
