import 'package:flutter/material.dart';

class SmallCard extends StatelessWidget {
  final IconData icon;
  final String value;

  SmallCard({super.key, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 50,
      // height: 60,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              IconButton(
                icon: Icon(icon),
                color: Theme.of(context).textTheme.titleMedium?.color,
                onPressed: () {},
              ),
              // Text(value, style: const TextStyle(color: Colors.black),),
            ],
          ),
        ),
      ),
    );
  }
}
