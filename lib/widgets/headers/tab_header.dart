import 'package:flutter/material.dart';
import 'package:pillowchat/controllers/client.dart';
import 'package:pillowchat/themes/ui.dart';

class TabHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color color;
  final IconData? leading;
  final IconData? trailing;
  final Function()? trailingPressed;
  final VoidCallback? onPressed;

  const TabHeader({
    super.key,
    required this.title,
    required this.color,
    this.icon,
    this.leading,
    this.onPressed,
    this.trailing,
    this.trailingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(15),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          tileColor: Dark.background.value,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: onPressed != null
              ? IconButton(
                  icon: Icon(leading),
                  onPressed: onPressed,
                )
              : null,
          title: Text(
            title,
            style: TextStyle(
                fontSize: ClientController.controller.fontSize.value * 1.1),
          ),
          trailing: icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: trailingPressed,
                      icon: Icon(
                        icon,
                        color: color,
                      ),
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}
