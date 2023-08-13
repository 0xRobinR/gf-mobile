import 'package:flutter/material.dart';

class SmallCard extends StatelessWidget {

  final IconData icon;
  final String value;

  const SmallCard({super.key, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                    // width: 50,
                    // height: 60,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            IconButton(icon: Icon(icon), color: Colors.white, onPressed: () {  },),
                            // Text(value, style: const TextStyle(color: Colors.black),),
                          ],
                        ),
                      ),
                    ),
                  );
  }
}
