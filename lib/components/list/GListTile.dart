import 'package:flutter/material.dart';

class GListTile extends StatelessWidget {
  const GListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.flight_land),
      title: Text('Trix\'s airplane'),
      subtitle: Text('The airplane is only in Act II.'),
      trailing: Icon(Icons.more_vert),
      isThreeLine: true,
    );
  }
}
