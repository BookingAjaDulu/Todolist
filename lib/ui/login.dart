import 'package:akadmobile/ui/matkul_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    const String url = 'http://your-api-endpoint/login'; // Replace with your actual API endpoint
    final response = await http.post(
      Uri.parse(url),
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      // Successful login logic
      final Map<String, dynamic> data = json.decode(response.body);
      // Handle the response data as needed (e.g., store user token, navigate to the next screen)
      // For simplicity, we'll print the token in this example
      print('Login successful. Token: ${data['token']}');

      // Navigate to the main app screen or another screen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BookingPage(),
        ),
      );
    } else {
      // Failed login logic
      // Display an error message or show a snackbar
      print('Login failed. ${response.body}');
      // You may want to show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please check your credentials.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
