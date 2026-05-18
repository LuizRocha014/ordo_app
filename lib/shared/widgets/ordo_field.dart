import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/ordo_colors.dart';
import '../../core/theme/ordo_radius.dart';
import '../../core/theme/ordo_typography.dart';

/// Input em estilo Ordo.
///
/// Em foco recebe `inset 0 0 0 2px lime` (regra do design system). Em
/// erro, a borda vira vermelha. Suporta multiline, validador, masks
/// (via `inputFormatters`) e largura de mono opcional para campos como
/// placa, IMEI ou serial.
class OrdoField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? placeholder;
  final String? hint;
  final String? errorText;
  final bool mono;
  final bool multiline;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final bool autovalidate;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const OrdoField({
    super.key,
    required this.controller,
    this.label,
    this.placeholder,
    this.hint,
    this.errorText,
    this.mono = false,
    this.multiline = false,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.maxLength,
    this.validator,
    this.autovalidate = true,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<OrdoField> createState() => _OrdoFieldState();
}

class _OrdoFieldState extends State<OrdoField> {
  final FocusNode _focus = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_handleFocus);
  }

  @override
  void dispose() {
    _focus.removeListener(_handleFocus);
    _focus.dispose();
    super.dispose();
  }

  void _handleFocus() {
    setState(() => _focused = _focus.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final showHelper = widget.hint != null || hasError;

    final borderColor =
        hasError ? OrdoColors.red : OrdoColors.borderStrong;

    final inputStyle = widget.mono
        ? OrdoTypography.mono(size: 14)
        : OrdoTypography.body(size: 14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: OrdoTypography.body(
              size: 12,
              weight: FontWeight.w500,
              color: OrdoColors.fg2,
            ),
          ),
          const SizedBox(height: 6),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: OrdoColors.paper,
            borderRadius: BorderRadius.circular(OrdoRadius.sm),
            border: Border.all(
              color: _focused && !hasError ? Colors.transparent : borderColor,
              width: 1,
            ),
            boxShadow: _focused && !hasError
                ? [
                    const BoxShadow(
                      color: OrdoColors.lime,
                      spreadRadius: 2,
                      blurRadius: 0,
                      blurStyle: BlurStyle.solid,
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focus,
            obscureText: widget.obscureText,
            maxLines: widget.obscureText ? 1 : (widget.multiline ? 4 : 1),
            minLines: widget.obscureText ? 1 : (widget.multiline ? 3 : 1),
            keyboardType: widget.keyboardType ??
                (widget.multiline ? TextInputType.multiline : TextInputType.text),
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            textInputAction: widget.textInputAction,
            validator: widget.validator,
            autovalidateMode: widget.autovalidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            style: inputStyle,
            cursorColor: OrdoColors.ink,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: OrdoTypography.body(size: 14, color: OrdoColors.fg3),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              isCollapsed: true,
              counterText: '',
              errorStyle: const TextStyle(height: 0, fontSize: 0),
              contentPadding: const EdgeInsets.symmetric(vertical: 11),
            ),
          ),
        ),
        if (showHelper) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText ?? widget.hint ?? '',
            style: OrdoTypography.body(
              size: 11,
              color: hasError ? OrdoColors.red : OrdoColors.fg3,
            ),
          ),
        ],
      ],
    );
  }
}
