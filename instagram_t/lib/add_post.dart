import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';

class AddPost extends StatelessWidget {
  final picker = ImagePicker();

  Future<File?> _loadImageFromGallery() async {
  // Get the most recent photo from the gallery
  final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
  final recentAlbum = albums.first;
  final recentAssets = await recentAlbum.getAssetListRange(start: 0, end: 1);
  final recentAsset = recentAssets.first;

  // Copy the photo to a temporary file
  final file = await recentAsset.file;
  final tempDir = await getTemporaryDirectory();
  final tempPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  final tempFile = await file?.copy(tempPath);

  return tempFile;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0B3954),
        title: Text('Nueva Publicación'),
      ),
      body: Column(children: [
        ClipRRect(
          child: Container(
            width: 400,
            height: 400,
            child: Center(
              child: FutureBuilder<File?>(
                future: _loadImageFromGallery(),
                builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        image: DecorationImage(
                            image: FileImage(snapshot.data!), fit: BoxFit.cover),
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
                }),
                ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Galería'),
            IconButton(onPressed: (){}, icon: Icon(Icons.camera))
          ],
        )

      ],)
      
    );
  }
}