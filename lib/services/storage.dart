import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:puchlo/services/dbservices.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadfile(String filename, String filepath) async {
    File file = File(filepath);
    try {
      List j = [];
      j = await DatabaseServices().isfileexist(filepath);
      if (j.isNotEmpty) {
        await storage.ref(filename).delete().then((value) async {
          await storage.ref('$filename').putFile(file);
        });
        return;
      }
      await storage.ref('$filename').putFile(file);
      await DatabaseServices().addFile(filename);
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }
  }
}
