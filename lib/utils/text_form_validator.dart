import 'package:flutter/material.dart';

class TextFormValidateCreator {
  //종류
  static const String REGEXP_ID = r"^([a-zA-Z]{1})(?=.*\d)[a-zA-Z0-9]+$";
  static const String REGEXP_PASSWORD = r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$])[A-Za-z\d@$!%*#?&]+$";
  static const String REGEXP_EMAIL = r"^[a-zA-Z]+[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static const String REGEXP_NAME = r"^([가-힣]{2,}|[a-zA-Z]{2,})$";
  static const String REGEXP_NUMBER = r"^[0-9]$";
  List<TextFormValidatorOptions> _options = [];

  TextFormValidateCreator(this._options);

  FormFieldValidator validator() {

    validator(value) {
      for(TextFormValidatorOptions option in _options) {
        if(option.condition(value)) {
          return option.errorMessage;
        }
      }
      return null;
    }

    return validator;
  }

  void addOption(TextFormValidatorOptions option) {
    _options.add(option);
  }

  void addOptions(List<TextFormValidatorOptions> options) {
    _options.addAll(options);
  }

}

typedef ValidateOptionFunction = bool Function(String value);

class TextFormValidatorOptions {
  final ValidateOptionFunction condition;
  final String errorMessage;

  TextFormValidatorOptions({
    required this.condition, required this.errorMessage});
}
