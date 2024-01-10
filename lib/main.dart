import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Reader'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _startNFCReading,
          child: const Text('Start NFC Reading'),
        ),
      ),
    );
  }

  void _startNFCReading() async {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      print(tag.data);
      var payload = tag.data["ndef"]["cachedMessage"]["records"][0]["payload"];
// now convert that payload into string
      var stringPayload = String.fromCharCodes(payload);
      String char = "";
      for (int i = 0; i < payload.length; i++) {
        char = char + String.fromCharCode(payload[i]);
      }
      print(char.substring(3));
      print(stringPayload);
      NfcManager.instance.stopSession();
    });
  }
}
