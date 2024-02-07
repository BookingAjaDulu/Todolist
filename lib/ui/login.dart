import 'package:akadmobile/ui/booking_page.dart';
import 'package:akadmobile/ui/register.dart';
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

  late bool _isLoading;
  late String _notificationMessage;
  late bool _isObscured; // Tambahkan variabel baru


  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _notificationMessage = '';
    _isObscured = true; // Inisialisasi dengan password tersembunyi
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    const String url = 'http://192.168.18.5/lapang-api/public/login'; // Replace with your actual API endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Login successful. Token: ${data['token']}');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookingPage(),
          ),
        );

        _showNotification('Login successful', true);
      } else {
        _showNotification('Login failed. Please check your credentials.', false);
      }
    } catch (error) {
      print('Error during login. $error');
      _showNotification('An error occurred during login.', false);
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
      backgroundColor: Colors.yellow, // Set the background color to yellow
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.black), // Atur warna teks menjadi hitam
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
                obscureText: _isObscured, // Menggunakan nilai _isObscured
                style: TextStyle(color: Colors.black), // Atur warna teks menjadi hitam
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black, // Set warna ikon menjadi hitam
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured; // Toggle _isObscured
                      });
                    },
                  ),
                ),
                cursorColor: Colors.black, // Ubah warna kursor menjadi hitam
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  backgroundColor: Colors.black, // Set the background color to black
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(color: Colors.white), // Set text color to white
                      ),
              ),

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
                        color: Colors.white,
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
        builder: (context) => RegisterScreen(),
      ),
    );
  },
  child: const Text(
    'Belum Punya Akun? Register',
    style: TextStyle(color: Colors.black), // Set text color to black
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}
