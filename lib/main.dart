import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mns_app/constants/assets.dart';
import 'package:mns_app/services/theme.dart';
import 'package:mns_app/navigation_menu.dart';
import 'package:mns_app/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SplashScreen(
        nextScreen: NavigationMenu(),
        logoPath: Assets.assetsImagesLogo,
      ),
    );
  }
}
