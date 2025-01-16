import 'package:flutter/material.dart';
import 'package:secure_pin_entry/secure_pin_entry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure Pin Entry Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PinEntryExampleScreen(),
    );
  }
}

class PinEntryExampleScreen extends StatelessWidget {
  const PinEntryExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secure Pin Entry Example')),
      body: Center(
        child: SecurePinEntry(
          length: 4,
          obscureText: false,
          onComplete: (pin) => showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('PIN Entered'),
              content: Text('You entered: $pin'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
