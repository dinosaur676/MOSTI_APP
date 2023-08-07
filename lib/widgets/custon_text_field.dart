
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_hour/manager/controller_manager.dart';
import 'package:travel_hour/utils/text_form_validator.dart';

class CustomTextField extends StatefulWidget {
  final String contollerKey;
  final bool obscureText;
  late final String label;
  late final TextInputType textInputType;
  late final List<TextInputFormatter>? formatter;
  late final ValueChanged<String>? onChanged;
  late final TextFormValidateCreator validator;
  late final InputDecoration? decoration;

  CustomTextField({
    List<TextFormValidatorOptions>? validator,
    this.textInputType = TextInputType.text,
    this.formatter,
    this.obscureText = false,
    this.onChanged,
    this.decoration,
    required this.contollerKey,
    required this.label,
    Key? key,
  }) : super(key: key) {
    this.validator = TextFormValidateCreator(validator ?? []);
  }

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();

  CustomTextField copyWith({
    List<TextFormValidatorOptions>? validator,
    TextInputType? textInputType,
    List<TextInputFormatter>? formatter,
    ValueChanged<String>? onChanged,
    String? label
  }) {
    if(validator != null) {
      this.validator.addOptions(validator);
    }

    if(textInputType != null) {
      this.textInputType = textInputType;
    }

    if(formatter != null) {
      this.formatter = formatter;
    }
    if(onChanged != null) {
      this.onChanged = onChanged;
    }
    if(label != null) {
      this.label = label;
    }

    return this;
  }
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 3.0,
            color: Colors.lightBlue,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextFormField(
          controller: GetIt.I<ControllerManager>().getController(widget.contollerKey),
          onChanged: widget.onChanged ?? (String value) {},
          obscureText: widget.obscureText,
          cursorColor: Colors.grey,
          validator: widget.validator.validator(),
          keyboardType: widget.textInputType,
          inputFormatters: widget.formatter ?? [],
          decoration: widget.decoration == null ? InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[300],
            hintText: widget.label,
          ) : widget.decoration,
        ),
      ),
    );
  }

  @override
  void dispose() {
    GetIt.I<ControllerManager>().disposeController(widget.contollerKey);
    super.dispose();
  }
}