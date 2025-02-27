import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rent_wheelz/src/screens/car_rental_search_screen.dart';
import 'package:rent_wheelz/src/theme/app_theme/app_theme_data.dart';
import 'package:rent_wheelz/src/utils/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.bottomNavigationBg,
      ),
    );
    return MaterialApp(
      title: 'Car Rental',
      darkTheme: AppThemeData.darkTheme,
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightTheme,
      themeMode: ThemeMode.system,
      home: CarRentalSearchScreen(),
    );
  }
}
