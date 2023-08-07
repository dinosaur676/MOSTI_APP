import 'package:flutter/material.dart';

class ControllerManager {
  final Map<String, TextEditingController> _controllers = {};

  ControllerManager();

  TextEditingController getController(String controllerKey) {
    if(!_controllers.containsKey(controllerKey)) {
      _controllers[controllerKey] = TextEditingController();
    }

    return _controllers[controllerKey]!;
  }

  void disposeController(String controllerKey) {
    _controllers[controllerKey]!.dispose();
    _controllers.remove(controllerKey);
  }
}