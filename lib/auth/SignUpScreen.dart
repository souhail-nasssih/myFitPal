import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/onboarding/pathSelection.dart';
import 'login_screen.dart'; // Ensure the correct path is imported

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _errorMessage = '';

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Get user input
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Password should be at least 6 characters';
      });
      return;
    }

    try {
      // Create user with Firebase
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to PathSelection after successful sign-up
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PathSelectionScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(e.code);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Save user's additional info (like name and email) to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName,
          'email': user.email,
          'birthDate': null, // You might need to request this info separately
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // Navigate to the Path Selection screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PathSelectionScreen()), // Your path selection screen
        );
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }





  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'This email address is already in use.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password provided is too weak.';
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
                  height: (size.height - 20),
                  child: Column(
                    children: [
                      const Text(
                        "Create an Account",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        controller: _emailController,
                        hintText: "Email",
                        icon: Icons.email,
                        errorText: _errorMessage.contains('email')
                            ? _errorMessage
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: "Password",
                        icon: Icons.lock,
                        obscureText: _obscurePassword,
                        errorText: _errorMessage.contains('Password')
                            ? _errorMessage
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hintText: "Confirm Password",
                        icon: Icons.lock_outline,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: _isLoading ? null : _signUp,
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
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Or",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSocialLoginButtons(),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          "Already have an account? Log in",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
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
    String? errorText,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        prefixIcon: Icon(
          icon,
          color: Colors.black.withOpacity(0.5),
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String imagePath) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white,
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _signInWithGoogle,
          child: _buildSocialButton("images/google_logo.png"),
        ),
        const SizedBox(width: 20),
      ],
    );
  }



}
