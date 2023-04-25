import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class AddPicture extends StatefulWidget {
  final Auth auth;
  final String username;
  AddPicture({super.key, required this.auth, required this.username});

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  User? currentUser;
  File? pickedImage;
  @override
  void initState() {
    super.initState();
    currentUser = widget.auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: Column(children: [
          SizedBox(
            height: 150,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pickedImage == null
                  ? Icon(
                      Icons.camera_alt,
                      size: 80,
                      color: AppColors.outlinedIcons,
                    )
                  : Container(
                      // Added
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: FileImage(pickedImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add a profile pciture',
                  style: TextStyle(
                      fontFamily: 'Garamond',
                      color: AppColors.onPrimaryContainer,
                      fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 8, 40, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(
                  "Add a profile photo so your friends can recognize you.",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textColorGrey),
                ))
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.primary),
                  child: TextButton(
                    child: Text(
                      'Add a photo',
                      style: TextStyle(color: AppColors.onPrimary),
                    ),
                    onPressed: () async {
                      PermissionStatus status =
                          await Permission.camera.request();
                      if (status == PermissionStatus.granted) {
                        final imagePicker = ImagePicker();
                        PickedFile? pickedFile = await imagePicker.getImage(
                            source: ImageSource.gallery);
                        setState(() {
                          pickedImage = File(pickedFile!.path);
                        });

                        File file = File(pickedFile!.path);
                        try {
                          Reference storageReference = FirebaseStorage.instance
                              .ref('ProfilePictures/${widget.username}.jpg');
                          UploadTask uploadTask =
                              storageReference.putFile(file);
                          uploadTask.snapshotEvents.listen(
                              (TaskSnapshot snapshot) {
                            print(
                                'Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
                          }, onError: (Object e) {
                            print('Error uploading image: $e');
                          });
                          String downloadURL = await uploadTask
                              .then((TaskSnapshot snapshot) async {
                            return await snapshot.ref.getDownloadURL();
                          });
                          print(
                              'Image uploaded successfully. Download URL: $downloadURL');
                        } catch (e) {
                          print(e);
                        }
                        /*try {
                          UploadTask _uploadTask = FirebaseStorage.instance
                              .ref('ProfilePictures/${widget.username}')
                              .putFile(file);
                        } catch (e) {
                          print(e);
                        }*/
                      } else {
                        print('Permission denied');
                      }
                    },
                  ))
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}