import 'package:flutter/material.dart';
import 'dart:io';

class UserPictureProvider with ChangeNotifier {
  static final UserPictureProvider _UserPictureProvider =
      UserPictureProvider._internal();
  factory UserPictureProvider() {
    return _UserPictureProvider;
  }

  UserPictureProvider._internal();
}


enum ImageUploadStatus { idle, uploading, done, error }

class ImageUploadNotifier extends ChangeNotifier {
  File? _imageFile;
  ImageUploadStatus _status = ImageUploadStatus.idle;

  File? get imageFile => _imageFile;
  ImageUploadStatus get status => _status;

  Future<void> pickImage() async {
    // Use image_picker package to pick an image
    

  }

  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    _setStatus(ImageUploadStatus.uploading);

    try {
      // Use http package to upload the image to the server
      // Update the status accordingly
      _setStatus(ImageUploadStatus.done);
    } catch (e) {
      _setStatus(ImageUploadStatus.error);
    }
  }

  void _setStatus(ImageUploadStatus status) {
    _status = status;
    notifyListeners();
  }

  void setImageFile(File? imageFile) {
    _imageFile = imageFile;
    notifyListeners();
  }
}
