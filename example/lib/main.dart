import 'package:flutter/material.dart';

import 'src/core/themes/themes.dart';
import 'src/core/di/service_locator.dart';
import 'src/module/auth/presentation/screen/auth_home_screen.dart';

void main() {
  setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Pigeon',
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      home: const AuthHomeScreen(),
    );
  }
}
