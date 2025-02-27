import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:rent_wheelz/src/app.dart';

void main() {
  runApp(DevicePreview(
    enabled: false,
    builder: (context) {
      return MyApp();
    },
  ));
}
