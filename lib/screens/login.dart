import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart';
import 'package:myfitpal/screens/coachSetupScreen.dart';
import 'package:myfitpal/screens/components/Logo.dart';
import 'package:myfitpal/screens/components/SignUpLink.dart';
import 'package:myfitpal/screens/components/SocialIcons.dart';
import 'package:myfitpal/screens/components/TextFieldWidget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: ColorsHelper
                  .colorBlueText, // Utilisation de la couleur primaire
            ),
          ),
          const Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Logo(),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.68,
            minChildSize: 0.68,
            maxChildSize: 0.75,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: ColorsHelper
                      .backgroundColor, // Utilisation de la couleur de fond
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                      top: MediaQuery.of(context).viewInsets.top + 30.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 30.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: ColorsHelper
                                .colorBlueText, // Couleur du texte blanc
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.email,
                          labelText: 'Email',
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.lock,
                          labelText: 'Password',
                          obscureText: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: ColorsHelper
                                      .colorBlueText), // Couleur du texte bleu
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Coahsetup()), // Correction du nom de classe
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor:
                                ColorsHelper.colorBlueText, // Couleur primaire
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              color: ColorsHelper
                                  .colorTextWhite, // Couleur du texte blanc
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const SocialIcons(),
                        const SizedBox(height: 20),
                        const SignUpLink(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
