// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatefulWidget {
  final String? defaultText;
  final String? hintText;
  final bool isPasswordFild;
  final bool? isEnabled;
  final int? maxLines;
  final bool isReadOnly;
  final TextInputType keboardType;
  final TextInputAction textInputAction;
  final FormFieldValidator validator;
  final TextEditingController controller;
  final Function(String value)? onFieldSubmitted;
  final Function()? onTap;

  const TextFormFieldCustom({
    super.key,
    this.defaultText,
    this.hintText,
    required this.isPasswordFild,
    this.isEnabled,
    this.maxLines,
    required this.isReadOnly,
    required this.keboardType,
    required this.textInputAction,
    required this.validator,
    required this.controller,
    this.onFieldSubmitted,
    this.onTap,
  });

  @override
  State<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.defaultText,
      validator: (value) => widget.validator(value),
      controller: widget.controller,
      keyboardType: widget.keboardType,
      textInputAction: widget.textInputAction,
      enabled: widget.isEnabled,
      readOnly: widget.isReadOnly,
      onTap: widget.isReadOnly ? widget.onTap : null,
      maxLines: widget.maxLines,
      onFieldSubmitted: widget.onFieldSubmitted,
      obscureText: widget.isPasswordFild,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.blueGrey,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.redAccent,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.blueAccent,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        hintText: widget.hintText,
      ),
    );
  }
}
