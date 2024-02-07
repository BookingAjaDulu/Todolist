<<<<<<< HEAD
import 'package:akadmobile/ui/booking_form.dart';
import 'package:akadmobile/ui/booking_page.dart';
import 'package:akadmobile/ui/login.dart';
=======
import 'package:booking/ui/login.dart';
>>>>>>> 4267b2ee2af723c4f06bf9d40ecdf65502a67f87
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
