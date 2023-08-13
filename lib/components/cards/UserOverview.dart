import 'package:flutter/material.dart';
import 'package:gf_mobile/components/cards/SmallCard.dart';
import 'package:gf_mobile/theme/themes.dart';
import 'package:line_icons/line_icons.dart';

class UserOverview extends StatefulWidget {
  const UserOverview({super.key});

  @override
  State<UserOverview> createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.account_circle, color: Colors.white,),
                    onPressed: (){},
                  ),
                  const Text("0x384df....299bca", style: TextStyle(color: Colors.white),),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white,),
                    onPressed: (){},
                  ),
                ],
              ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 10,
                runSpacing: 10,
                children: const [
                  SmallCard(icon: LineIcons.plusCircle, value: ""),
                  SmallCard(icon: LineIcons.eye, value: ""),
                  SmallCard(icon: LineIcons.download, value: ""),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
