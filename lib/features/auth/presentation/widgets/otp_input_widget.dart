import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class OtpInputWidget extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final bool isDarkMode;

  const OtpInputWidget({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
    required this.isDarkMode,
  });

  @override
  State<OtpInputWidget> createState() => OtpInputWidgetState();
}

class OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get otpCode => _controllers.map((c) => c.text).join();

  void clear() {
    for (var c in _controllers) {
      c.clear();
    }
    if (_focusNodes.isNotEmpty) {
      _focusNodes[0].requestFocus();
    }
    setState(() {});
  }

  void _onFieldChanged(String value, int index) {
    if (value.length > 1) {
      // التعامل مع اللصق (Paste) لكود كامل
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < widget.length && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      final lastIndex = (digits.length - 1).clamp(0, widget.length - 1);
      _focusNodes[lastIndex].requestFocus();
      widget.onChanged?.call(otpCode);
      if (otpCode.length == widget.length) {
        widget.onCompleted(otpCode);
      }
      setState(() {});
      return;
    }

    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    widget.onChanged?.call(otpCode);
    if (otpCode.length == widget.length) {
      widget.onCompleted(otpCode);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.dividerColor;

    final boxBg = widget.isDarkMode
        ? const Color(0xFF1B233D).withAlpha(220)
        : Colors.white.withAlpha(240);

    final textColor = widget.isDarkMode
        ? const Color(0xFFFACC1D)
        : const Color(0xFFB7935F);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.length, (index) {
          final isFocused = _focusNodes[index].hasFocus;
          final hasValue = _controllers[index].text.isNotEmpty;

          return Container(
            width: 12.5.w,
            height: 7.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: boxBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isFocused
                    ? accentColor
                    : (hasValue ? accentColor.withAlpha(160) : accentColor.withAlpha(60)),
                width: isFocused ? 2.0 : 1.2,
              ),
              boxShadow: isFocused
                  ? [
                      BoxShadow(
                        color: accentColor.withAlpha(70),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (val) => _onFieldChanged(val, index),
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: "",
                contentPadding: EdgeInsets.zero,
              ),
            ),
          );
        }),
      ),
    );
  }
}
