import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Ensure this path is correct

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String _message = '';
  Color _messageColor = Colors.black; // Default message color

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
      _message = ''; // Clear previous message
    });

    final String email = _emailController.text.trim();

    try {
      // Check if the email exists in the 'clients' collection
      final clientDocs = await FirebaseFirestore.instance
          .collection('clients')
          .where('email', isEqualTo: email)
          .get();

      // Check if the email exists in the 'coaches' collection
      final coachDocs = await FirebaseFirestore.instance
          .collection('coaches')
          .where('email', isEqualTo: email)
          .get();

      if (clientDocs.docs.isNotEmpty || coachDocs.docs.isNotEmpty) {
        // If the email exists in either 'clients' or 'coaches', send the password reset email
        await _auth.sendPasswordResetEmail(email: email);
        setState(() {
          _message = 'Password reset email sent. Check your inbox.';
          _messageColor = Colors.green; // Success message color
        });
        // Redirect to login screen after showing the message for a few seconds
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        });
      } else {
        // Email not found in either collection
        setState(() {
          _message = 'Email not found. Please check and try again.';
          _messageColor = Colors.red; // Error message color
        });
      }
    } catch (e) {
      setState(() {
        _message = 'An error occurred. Please try again later.';
        _messageColor = Colors.red; // Error message color
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                SizedBox(
                  height: (size.height - 60) * 0.5,
                  child: Column(
                    children: [
                      const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Enter your email to receive a password reset link.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        controller: _emailController,
                        hintText: "Email",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 20),
                      if (_message.isNotEmpty)
                        Text(
                          _message,
                          style: TextStyle(
                            color: _messageColor,
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(
                  height: (size.height - 60) * 0.5,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: _resetPassword,
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.deepOrange, Colors.orangeAccent],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: _isLoading
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : const Text(
                              "Send Reset Link",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Expanded(child: Divider(thickness: 0.8)),
                          SizedBox(width: 5),
                          Text("Or"),
                          SizedBox(width: 5),
                          Expanded(child: Divider(thickness: 0.8)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          "Back to Login",
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.black.withOpacity(0.5)),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                cursorColor: Colors.black.withOpacity(0.5),
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  suffixIcon: suffixIcon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
