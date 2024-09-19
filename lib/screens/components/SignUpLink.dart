import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart';
import 'package:myfitpal/screens/SignUp.dart';

class SignUpLink extends StatelessWidget {
  const SignUpLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.grey),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignUp()));
          },
          child: Text(
            'Sign up',
            style: TextStyle(
              color: ColorsHelper.colorBlueText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
