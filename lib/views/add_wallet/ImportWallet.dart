import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImportWallet extends StatelessWidget {
  final TextEditingController privateKeyController = TextEditingController();
  String privateKey = '';
  final formKey = GlobalKey<FormState>();

  ImportWallet({super.key});

  import(BuildContext context) {
    Navigator.of(context).pop(privateKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Import Wallet"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: privateKeyController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Using Private Key',
                  helperMaxLines: 2,
                  helperText: "Your private key is a 64 character string",
                ),
                textInputAction: TextInputAction.go,
                onFieldSubmitted: (value) {
                  if (formKey.currentState!.validate()) {
                    privateKey = privateKeyController.text;
                    import(context);
                  }
                },
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your private key';
                  }
                  return null;
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // paste button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey[300],
                  ),
                  onPressed: () async {
                    var text = await Clipboard.getData('text/plain');
                    privateKeyController.text = text!.text!;
                  },
                  child: const Text("Paste"),
                ),
              ),
              // import button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      privateKey = privateKeyController.text;
                      import(context);
                    }
                  },
                  child: const Text("Import"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
