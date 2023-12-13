import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Text/SubTitle.dart';

class GListTile extends StatelessWidget {
  final int index;
  final Widget? icon;
  final String title;
  final String subtitle;
  final Widget trailingIcon;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const GListTile(
      {super.key,
      required this.index,
      this.icon,
      required this.title,
      required this.subtitle,
      required this.trailingIcon,
      this.onTap,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: backgroundColor,
      onTap: onTap,
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Subtitle(
        title: subtitle,
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 13),
      ),
      trailing: trailingIcon,
      isThreeLine: true,
    );
  }
}
