import 'package:flutter/material.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isLeading;
  final Function? onTapBackButton;
  final List<Widget>? actions;

  const CommonAppbar({
    super.key,
    required this.title,
    required this.isLeading,
    this.onTapBackButton,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 40,
      automaticallyImplyLeading: isLeading,
      titleSpacing: isLeading ? 0 : 16,
      scrolledUnderElevation: 3,
      backgroundColor: Colors.white,
      leading: isLeading
          ? GestureDetector(
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onTap: () {
                onTapBackButton != null
                    ? onTapBackButton!.call()
                    : Navigator.pop(context);
              },
            )
          : null,
      elevation: 1,
      actions: actions,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    );
  }
}
