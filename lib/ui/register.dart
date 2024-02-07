import 'package:booking/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late bool _isLoading;
  late String _notificationMessage;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _notificationMessage = '';
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

<<<<<<< HEAD
    const String url = 'http://192.168.18.5/lapang-api/public/registrasi'; // Replace with your actual API endpoint
=======
    const String url =
        'http://192.168.1.18/booking-api/public/registrasi'; // Replace with your actual API endpoint
>>>>>>> 4267b2ee2af723c4f06bf9d40ecdf65502a67f87

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'nama': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Registration successful. Token: ${data['token']}');

        _showNotification('Registration successful', true);
      } else {
        _showNotification('Registration failed. Please try again.', false);
      }
    } catch (error) {
      print('Error during registration. $error');
      _showNotification('An error occurred during registration.', false);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showNotification(String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isSuccess ? 'Success' : 'Error'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccess ? Icons.check : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 10),
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.limeAccent, // Set the background color to yellow
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.black), // Mengatur warna label menjadi hitam
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Warna border hitam
                  ),
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Ubah warna border saat focus
                   ),
                  enabledBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black), // Warna border hitam
                  ),
                ),
                cursorColor: Colors.black, // Ubah warna kursor menjadi hitam
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black), // Mengatur warna label menjadi hitam
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Warna border hitam
                  ),
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Ubah warna border saat focus
                   ),
                  enabledBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black), // Warna border hitam
                  ),
                ),
                cursorColor: Colors.black, // Ubah warna kursor menjadi hitam
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black), // Mengatur warna label menjadi hitam
                  border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Warna border hitam
                  ),
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Ubah warna border saat focus
                   ),
                  enabledBorder: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.black), // Warna border hitam
                  ),
                ),
               cursorColor: Colors.black, // Ubah warna kursor menjadi hitam
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  backgroundColor: Colors.black, // Set the background color to black
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Register',
                        style: TextStyle(color: Colors.white), // Set text color to white
                      ),
              ),
<<<<<<< HEAD

=======
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  backgroundColor:
                      Colors.black, // Set the background color to black
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.white), // Set text color to white
                      ),
              ),
>>>>>>> 4267b2ee2af723c4f06bf9d40ecdf65502a67f87
              const SizedBox(height: 16),
              if (_notificationMessage.isNotEmpty)
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: ModalRoute.of(context)!.animation!,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _notificationMessage,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Sudah Punya Akun? Login',
                  style:
                      TextStyle(color: Colors.black), // Set text color to black
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
