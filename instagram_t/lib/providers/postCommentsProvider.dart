import 'package:flutter/material.dart';

class PostCommentsProvider with ChangeNotifier {
  static final PostCommentsProvider _userDataProvider =
      PostCommentsProvider._internal();
  factory PostCommentsProvider() {
    return _userDataProvider;
  }

  PostCommentsProvider._internal();
}
