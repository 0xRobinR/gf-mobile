import 'package:flutter/material.dart';
import 'package:gf_mobile/components/list/GListTile.dart';

class GListView extends StatelessWidget {
  const GListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (itemBuilder, index)  {
      return InkWell(
        onTap: (){},
          splashColor: Colors.white.withOpacity(0.4),
          focusColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.black.withOpacity(0.2),
          child: GListTile(
            index: index,
            title: "created bucket",
            subtitle: 'block: #199'
                '\n'
                'created on 12/12/2023',
            icon: const Icon(Icons.call_made, color: Colors.greenAccent,),
            trailingIcon: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15,),
          )
      );
    });
  }
}
