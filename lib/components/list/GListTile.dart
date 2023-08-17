import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Text/SubTitle.dart';
import 'package:line_icons/line_icons.dart';

class GListTile extends StatelessWidget {
  final int index;
  final Widget? icon;
  final String title;
  final String subtitle;
  final Widget trailingIcon;

  const GListTile({super.key, required this.index, this.icon, required this.title, required this.subtitle, required this.trailingIcon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title, style: const TextStyle(fontSize: 16),),
      subtitle: Subtitle(
          title: subtitle,
        textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 13
          ),
      ),
      trailing: trailingIcon,
      isThreeLine: true,
    );
  }
}
