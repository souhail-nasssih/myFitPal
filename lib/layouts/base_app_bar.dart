import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const BaseAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:  ColorsHelper.backgroundColor,
      title: Text(
        title,
        style:  const TextStyle(color: ColorsHelper.secondaryColor),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: ColorsHelper.secondaryColor),
          onPressed: () {},
        ),
      ],
    );
  }
}
