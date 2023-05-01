import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_t/colors.dart';
import 'package:instagram_t/home_page.dart';
import 'package:instagram_t/providers/addPostProvider.dart';

import 'auth.dart';

class AddCaption extends StatefulWidget {
  final Auth auth;
  final File imageFile;
  const AddCaption({super.key, required this.auth, required this.imageFile});

  @override
  State<AddCaption> createState() => _AddCaptionState();
}

class _AddCaptionState extends State<AddCaption> {
  bool _loading = false;

  Future<void> _post() async {
    final user = widget.auth.currentUser;
    final userId = user!.uid;
    final postProvider = PostProvider();

    setState(() {
      _loading = true;
    });

    await postProvider.addPost(_caption, userId, widget.imageFile);

    setState(() {
      _loading = false;
    });

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomePage(auth: widget.auth)));
  }

  String _caption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Add Caption'),
        actions: [
          TextButton(
            onPressed: _caption.isEmpty || _loading ? null : _post,
            child: Text(
              'Post',
              style: TextStyle(
                  color: _caption.isEmpty
                      ? AppColors.textColorGrey
                      : AppColors.onPrimaryContainer),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              maxLines: 10,
              decoration: InputDecoration(
                  hintText: 'Write a caption...',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.outline),
                  ),
                  focusedBorder: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  _caption = value;
                });
              },
            ),
          ),
          if (_loading) ...[
            SizedBox(height: 16.0),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ],
      ),
    );
  }
}
