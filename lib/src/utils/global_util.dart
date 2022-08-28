import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

const storage = FlutterSecureStorage();
const String storageReports = 'app:list-reports';

Future writeStorage ({required String data}) async {
  await storage.write(key: storageReports, value: data);
  return true;
}

Future<String> readStorage () async {
  String data = await storage.read(key: storageReports) ?? '';
  return data;
}

Future<String> deleteStorage () async {
  await storage.delete(key: storageReports);
  return '';
}

  void showSnackBar({required BuildContext context, required String message }){
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
            textColor: Colors.white,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          content: Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 20, color: Colors.white),
              const SizedBox(width: 5),
              Text(message, style: const TextStyle(fontSize: 16, color: Colors.white)),
            ],
          )
        ),
      );
    } catch (e) {
      print(e);
    }
  }