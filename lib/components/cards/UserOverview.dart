import 'package:flutter/material.dart';
import 'package:gf_mobile/components/cards/SmallCard.dart';
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
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    onPressed: () {},
                  ),
                  Text(
                    "0x384df....299bca",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 10,
                runSpacing: 10,
                children: [
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
