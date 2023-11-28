import 'package:flutter/material.dart';

class ImportWallet extends StatelessWidget {
  TextEditingController privateKeyController = TextEditingController();
  String privateKey = '';

  ImportWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Enter Private Key'),
      content: TextFormField(
        controller: privateKeyController,
        decoration: const InputDecoration(
          labelText: 'Private Key',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        onChanged: (value) {
          privateKey = value;
        },
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Import'),
          onPressed: () {
            Navigator.of(context).pop(privateKey);
          },
        ),
      ],
    );
  }
}
