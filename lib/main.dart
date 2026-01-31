import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow all orientations - layout adapts responsively
  await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Initialize audio service
  await AudioService.instance.init();

  runApp(const MonopolyApp());
}
