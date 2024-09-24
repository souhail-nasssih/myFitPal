import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart';

class TextFieldWidget extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;

  const TextFieldWidget({
    super.key,
    required this.icon,
    required this.labelText,
    this.obscureText = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon,
            color: ColorsHelper.colorGreyT ??
                Colors.grey), // Utilisation de la couleur grise
        labelText: labelText,
        labelStyle: TextStyle(
            color: ColorsHelper.colorGreyT ?? Colors.grey, fontSize: 16),
        filled: true,
        fillColor:
            ColorsHelper.colorFond, // Utilisation de la couleur de fond définie
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: ColorsHelper.colorGrey ?? Colors.grey,
              width: 1), // Couleur grise pour la bordure
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: ColorsHelper.colorBlueText,
              width: 2), // Couleur primaire pour le focus
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
