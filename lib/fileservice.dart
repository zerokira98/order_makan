import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FileService {
  FileService();
  static Future<Uint8List> imageCompress(
    Uint8List data,
  ) async {
    var result = await FlutterImageCompress.compressWithList(data,
        minHeight: 1280, minWidth: 720, quality: 90);
    return result;
    // throw UnimplementedError();
  }

  static Future<Reference?> menuimageUpload(
      Uint8List data, String filename) async {
    try {
      return FirebaseStorage.instance
          .ref('menuimg')
          .child(filename)
          .putData(data)
          .then(
        (p0) {
          if (p0.state == TaskState.success) {
            return p0.ref;
          }
          return null;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future menuimageDownload(String ref) async {
    try {
      return await FirebaseStorage.instance.ref(ref).getData();
    } catch (e) {}
  }

  static Future<String> getDownloadUrl(String path) async {
    return await FirebaseStorage.instance.ref(path).getDownloadURL();
  }
}
