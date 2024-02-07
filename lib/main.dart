import 'package:booking/ui/booking_form.dart';
import 'package:booking/ui/booking_page.dart';
import 'package:booking/ui/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplikasi Flutter Booking",
      home: LoginScreen(),
    );
  }
}
