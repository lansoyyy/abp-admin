import 'dart:io';

import 'package:app/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late String fileName = '';

  late File imageFile;

  late String imageURL = '';

  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Row(
              children: const [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Loading . . .',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QRegular'),
                ),
              ],
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Users/$fileName')
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Users/$fileName')
            .getDownloadURL();

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'profilePicture': imageURL});

        Navigator.of(context).pop();
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: userData,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading'));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          dynamic data = snapshot.data;
          return SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              uploadPicture('camera');
                                            },
                                            leading: const Icon(
                                              Icons.camera,
                                            ),
                                            title: TextRegular(
                                              text: 'Take a picture',
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                            trailing: const Icon(Icons
                                                .arrow_forward_ios_rounded),
                                          ),
                                          const Divider(),
                                          ListTile(
                                            onTap: () {
                                              uploadPicture('gallery');
                                            },
                                            leading: const Icon(
                                              Icons
                                                  .photo_size_select_actual_rounded,
                                            ),
                                            title: TextRegular(
                                              text: 'Upload a photo',
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                            trailing: const Icon(Icons
                                                .arrow_forward_ios_rounded),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: CircleAvatar(
                                minRadius: 50,
                                maxRadius: 50,
                                backgroundImage:
                                    NetworkImage(data['profilePicture']),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 55),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: ((context) {
                                                return AlertDialog(
                                                  title: TextBold(
                                                      text: 'Your QR Code',
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                  content: SizedBox(
                                                    height: 300,
                                                    width: 300,
                                                    child: QrImage(
                                                      data: data['id'],
                                                      version: QrVersions.auto,
                                                      size: 200.0,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: (() {
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                        child: TextBold(
                                                            text: 'Close',
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                );
                                              }));
                                        },
                                        icon: const Icon(
                                          Icons.qr_code,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextBold(
                                text: data['gender'],
                                fontSize: 18,
                                color: Colors.black),
                            const SizedBox(
                              width: 10,
                            ),
                            TextBold(
                                text: '|', fontSize: 18, color: Colors.black),
                            const SizedBox(
                              width: 10,
                            ),
                            TextBold(
                                text: data['age'],
                                fontSize: 18,
                                color: Colors.black),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: TextBold(
                                text: data['name'],
                                fontSize: 18,
                                color: Colors.black),
                            subtitle: TextRegular(
                                text: 'Full Name',
                                fontSize: 12,
                                color: Colors.grey),
                          ),
                          ListTile(
                            title: TextBold(
                                text: data['address'],
                                fontSize: 18,
                                color: Colors.black),
                            subtitle: TextRegular(
                                text: 'Address',
                                fontSize: 12,
                                color: Colors.grey),
                          ),
                          ListTile(
                            title: TextBold(
                                text: data['district'],
                                fontSize: 18,
                                color: Colors.black),
                            subtitle: TextRegular(
                                text: 'District',
                                fontSize: 12,
                                color: Colors.grey),
                          ),
                          ListTile(
                            title: TextBold(
                                text: data['birthday'],
                                fontSize: 18,
                                color: Colors.black),
                            subtitle: TextRegular(
                                text: 'Birthday',
                                fontSize: 12,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
