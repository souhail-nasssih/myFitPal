import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfitpal/screens/client/pages/activity.dart';
import 'package:myfitpal/screens/coach/CoachLandingPage.dart';
import 'SignUpScreen.dart'; // Ensure this path is correct

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _obscurePassword = true;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Clear previous error message
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check user's role (Client or Coach) and redirect accordingly
      await _checkUserRole(email);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(e.code);
      });
      // Display error message using SnackBar or Text widget
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkUserRole(String email) async {
    // Check if the email exists in the 'clients' collection
    final clientDocs = await FirebaseFirestore.instance
        .collection('clients')
        .where('email', isEqualTo: email)
        .get();

    if (clientDocs.docs.isNotEmpty) {
      // Redirect to Client landing page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ActivityScreen()),
      );
    } else {
      // Check if the email exists in the 'coaches' collection
      final coachDocs = await FirebaseFirestore.instance
          .collection('coaches')
          .where('email', isEqualTo: email)
          .get();

      if (coachDocs.docs.isNotEmpty) {
        // Redirect to Coach landing page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CoachLandingPage()),
        );
      } else {
        // Handle scenario where user is not found in either collection
        setState(() {
          _errorMessage = 'User not found in Client or Coach collection.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage)),
        );
      }
    }
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'The email address you entered is not associated with an account.';
      case 'wrong-password':
        return 'The password you entered is incorrect.';
      case 'invalid-email':
        return 'The email address you entered is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return 'An unexpected error occurred. Please try again.';
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
                        "Hey there,",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        controller: _emailController,
                        hintText: "Email",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: "Password",
                        icon: Icons.lock,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Forgot your password?",
                        style: TextStyle(
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: (size.height - 60) * 0.5,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: _login,
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
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    "Login",
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
                      // _buildSocialLoginButtons(),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Don't have an account? Sign Up",
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

  // Widget _buildSocialLoginButtons() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       _buildSocialButton(
  //         iconUrl: "https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg",
  //         iconColor: Colors.red, // Example color, adjust as needed
  //       ),
  //       SizedBox(width: 20),
  //       _buildSocialButton(
  //         iconUrl: "https://upload.wikimedia.org/wikipedia/commons/5/51/Facebook_f_logo_%282019%29.svg",
  //         iconColor: Colors.blue, // Example color, adjust as needed
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSocialButton(
      {required String iconUrl, required Color iconColor}) {
    return InkWell(
      onTap: () {
        // Add functionality for social login here
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            iconUrl,
            color: iconColor,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
