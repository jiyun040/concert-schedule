import 'package:concert_schedule/const/colors.dart';
import 'package:concert_schedule/const/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool obsecureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const InputField({
    super.key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.obsecureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obsecureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText!,
          style: ContiTextStyle.loginJoinText,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ContiColors.mainOrange, width: 1),
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: _isObscured && widget.obsecureText,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: ContiTextStyle.hint,
              contentPadding: const EdgeInsets.all(12),
              suffixIcon: widget.obsecureText
                  ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: ContiColors.mainBlack,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
                  : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}