import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keeper/services/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:keeper/widgets/responsive.dart';
import 'package:keeper/widgets/responsive_button.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  String imageUrl = '';
  void pickUploadedImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75);
    Reference ref = FirebaseStorage.instance
        .ref('users/${FirebaseAuth.instance.currentUser?.uid}')
        .child('profilepic.jpg');
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        imageUrl = value;
      });
    });
  }

  final Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    bool isDesktop(BuildContext context) =>
        MediaQuery.of(context).size.width >= 600;
    bool isMobile(BuildContext context) =>
        MediaQuery.of(context).size.width < 600;
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ResponsiveWidget.isLargeScreen(context)
              ? const CircleAvatar(
                  child: Icon(Icons.person),
                )
              : ResponsiveWidget.isSmallScreen(context)
                  ? GestureDetector(
                      onTap: () {
                        pickUploadedImage();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[900],
                        child: FutureBuilder(
                            future: storage.downloadURL('profilepic.jpg'),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                return Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              }
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }
                              return const CircleAvatar();
                            }),
                      ),
                    )
                  : ResponsiveWidget.isMeduimScreen(context)
                      ? const CircleAvatar(
                          child: Icon(Icons.person),
                        )
                      : GestureDetector(
                          onTap: () {
                            pickUploadedImage();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[900],
                            child: FutureBuilder(
                                future: storage.downloadURL('profilepic.jpg'),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    return Image.network(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }
                                  return const CircleAvatar();
                                }),
                          ),
                        ),
          const SizedBox(
            height: 40,
            width: 46,
          ),
        ],
      ),
    );
  }
}
