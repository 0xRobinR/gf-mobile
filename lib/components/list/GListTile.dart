import 'package:flutter/material.dart';
import 'package:gf_mobile/components/Text/SubTitle.dart';
import 'package:line_icons/line_icons.dart';

class GListTile extends StatelessWidget {
  final int index;
  const GListTile({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(index % 2 == 0 ? Icons.call_made : Icons.call_received, color: index % 2 != 0 ? Colors.greenAccent : Colors.redAccent,),
      title: const Text('Create GF bucket', style: TextStyle(fontSize: 16),),
      subtitle: const Subtitle(
          title: 'block: 1030230\n'+
              'status: success',
        textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 13
          ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15,),
      isThreeLine: true,
    );
  }
}
