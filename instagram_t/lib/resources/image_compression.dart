import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';


class ImageCompress {
  static Future<File> compressFile(File file) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 80,
      targetHeight: 200,
      targetWidth: 200,
    );
    return compressedFile;
  }
}
