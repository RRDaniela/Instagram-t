import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_t/add_caption.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/colors.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';

class AddPost extends StatefulWidget {
  final User current_user;

  AddPost({
    super.key,
    required this.current_user,
  });

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final picker = ImagePicker();
  late ValueNotifier<File?> _selectedImageNotifier;

  @override
  void initState() {
    super.initState();
    _selectedImageNotifier = ValueNotifier(null);
    _loadImageFromGallery();
  }

  Future<void> _loadImageFromGallery() async {
    // Get the most recent photo from the gallery
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(start: 0, end: 1);
    final recentAsset = recentAssets.first;

    // Copy the photo to a temporary file
    final file = await recentAsset.file;
    final tempDir = await getTemporaryDirectory();
    final tempPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final tempFile = await file?.copy(tempPath);

    _selectedImageNotifier.value = tempFile;
  }

  Future<void> _selectFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final tempDir = await getTemporaryDirectory();
      final tempPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = await File(pickedFile.path).copy(tempPath);

      _selectedImageNotifier.value = tempFile;
    }
  }

  Future<List<File>?> _loadRecentImages() async {
    final albums2 =
        await PhotoManager.getAssetPathList(type: RequestType.image);
    final recentAlbum = albums2.first;
    final recentAssets = await recentAlbum.getAssetListRange(start: 0, end: 6);

    final tempDir = await getTemporaryDirectory();
    final tempFiles = await Future.wait(recentAssets.map((asset) async {
      final file = await asset.file;
      final tempPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = await file?.copy(tempPath);
      return tempFile!;
    }));

    return tempFiles;
  }

  Future<void> _takePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final tempDir = await getTemporaryDirectory();
      final tempPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = await File(pickedFile.path).copy(tempPath);

      _selectedImageNotifier.value = tempFile;
    }
  }

  @override
  void dispose() {
    _selectedImageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('New post'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              if (_selectedImageNotifier.value != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCaption(
                      current_user: widget.current_user,
                      imageFile: _selectedImageNotifier.value!,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select an image to continue.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ClipRRect(
            child: Container(
              width: 400,
              height: 400,
              child: Center(
                  child: ValueListenableBuilder<File?>(
                valueListenable: _selectedImageNotifier,
                builder: (BuildContext context, File? selectedImage, _) {
                  if (selectedImage != null) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        image: DecorationImage(
                          image: FileImage(selectedImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                      child: Center(
                        child: Icon(Icons.image),
                      ),
                    );
                  }
                },
              )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: _selectFromGallery, icon: Icon(Icons.photo)),
              IconButton(
                onPressed: _takePhoto,
                icon: Icon(Icons.photo_camera),
              )
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: FutureBuilder<List<File>?>(
                future: _loadRecentImages(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<File>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    return GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: snapshot.data!.map((File file) {
                        return GestureDetector(
                          onTap: () {
                            _selectedImageNotifier.value = file;
                            // Set the tapped image as the current image
                            /*setState(() {
                            currentImage = file;
                          });*/
                          },
                          child: Image.file(file, fit: BoxFit.cover),
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
