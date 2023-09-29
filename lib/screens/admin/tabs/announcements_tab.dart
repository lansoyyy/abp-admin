import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:app/services/add_announcements.dart';
import 'package:app/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/textfield_widget.dart';
import '../../../widgets/toast_widget.dart';

class AnnouncementsTab extends StatefulWidget {
  const AnnouncementsTab({super.key});

  @override
  State<AnnouncementsTab> createState() => _AnnouncementsTabState();
}

class _AnnouncementsTabState extends State<AnnouncementsTab> {
  List<String> announcements = [
    'New product launch!',
    'Sale ending soon',
    'Upcoming events',
    'Holiday hours',
  ];

  late bool pickedFile = false;

  late String fileName = '';

  late String fileUrl = '';

  late File imageFile;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  List<String> districts = [
    'For All Districts',
    'St. John',
    'St. Luke',
    'St. Mark',
    'St. Matthias',
    'St. Matthew',
    'St. Paul',
  ];
  String district = 'St. John';

  int dropdownValue = 0;

  void _showAddAnnouncementDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController textController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Announcement'),
          content: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Announcement Title',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'Announcement Details',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Text('Announcement Date: '),
                      Expanded(
                        child: Builder(builder: (context) {
                          final DateFormat formatter = DateFormat('yyyy-MM-dd');
                          final String formattedDate =
                              formatter.format(selectedDate);
                          return TextButton(
                            child: Text(
                              formattedDate.toString(),
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null && picked != selectedDate) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextRegular(
                          text: 'For district:',
                          fontSize: 12,
                          color: Colors.grey),
                      const SizedBox()
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton(
                      underline: const SizedBox(),
                      value: dropdownValue,
                      items: [
                        for (int i = 0; i < districts.length; i++)
                          DropdownMenuItem(
                            value: i,
                            onTap: () {
                              setState(() {
                                district = districts[i];
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextRegular(
                                  text: districts[i],
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = int.parse(value.toString());
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  pickedFile
                      ? ListTile(
                          leading: const Icon(Icons.attach_file),
                          title: TextBold(
                              text: fileName,
                              fontSize: 14,
                              color: Colors.black),
                          trailing: IconButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform
                                      .pickFiles(
                                allowMultiple: false,
                                onFileLoading: (p0) {
                                  return const CircularProgressIndicator();
                                },
                              )
                                      .then((value) {
                                setState(
                                  () {
                                    pickedFile = true;
                                    fileName = value!.names[0]!;
                                    imageFile = File(value.paths[0]!);
                                  },
                                );
                                return null;
                              });

                              await firebase_storage.FirebaseStorage.instance
                                  .ref('Files/$fileName')
                                  .putFile(imageFile);
                              fileUrl = await firebase_storage
                                  .FirebaseStorage.instance
                                  .ref('Files/$fileName')
                                  .getDownloadURL();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.upload_file_outlined,
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                              allowMultiple: false,
                              onFileLoading: (p0) {
                                return const CircularProgressIndicator();
                              },
                            )
                                .then((value) {
                              setState(
                                () {
                                  pickedFile = true;
                                  fileName = value!.names[0]!;
                                  imageFile = File(value.paths[0]!);
                                },
                              );
                              return null;
                            });

                            await firebase_storage.FirebaseStorage.instance
                                .ref('Files/$fileName')
                                .putFile(imageFile);
                            fileUrl = await firebase_storage
                                .FirebaseStorage.instance
                                .ref('Files/$fileName')
                                .getDownloadURL();
                            setState(() {});
                          },
                          child: TextRegular(
                              text: 'Attach a file',
                              fontSize: 12,
                              color: Colors.grey),
                        ),
                ],
              ),
            );
          }),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                addAnnouncemenets(titleController.text, textController.text,
                    selectedDate, fileUrl, district);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final detailController = TextEditingController();

  Widget wids(id, name, details) {
    if (FirebaseAuth.instance.currentUser != null) {
      return const SizedBox();
    }

    return SizedBox(
      width: 140,
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: ((context) {
                  final formKey = GlobalKey<FormState>();
                  final TextEditingController emailController =
                      TextEditingController();

                  return AlertDialog(
                    backgroundColor: Colors.grey[100],
                    title: TextRegular(
                      text: 'Editing Announcement',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    content: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFieldWidget(
                            hint: name,
                            label: 'Announcement Name',
                            controller: emailController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget(
                            hint: details,
                            label: 'Announcement Details',
                            controller: detailController,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: (() {
                          Navigator.pop(context);
                        }),
                        child: TextRegular(
                          text: 'Cancel',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: (() async {
                          try {
                            Navigator.pop(context);
                            await FirebaseFirestore.instance
                                .collection('Announcement')
                                .doc(id)
                                .update({
                              'name': emailController.text,
                              'details': detailController.text
                            });
                          } catch (e) {
                            showToast(e);

                            Navigator.pop(context);
                          }
                        }),
                        child: TextBold(
                          text: 'Continue',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
                }),
              );
            },
            child: const Text('Edit', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text(
                          'Delete Confirmation',
                          style: TextStyle(
                              fontFamily: 'QBold', fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                          'Are you sure you want delete this data?',
                          style: TextStyle(fontFamily: 'QRegular'),
                        ),
                        actions: <Widget>[
                          MaterialButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                  fontFamily: 'QRegular',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await FirebaseFirestore.instance
                                  .collection('Announcement')
                                  .doc(id)
                                  .delete();
                            },
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                  fontFamily: 'QRegular',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ));
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: TextRegular(
            text: 'Announcements', fontSize: 18, color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Announcement')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print('error');
                return const Center(child: Text('Error'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  )),
                );
              }

              final data = snapshot.requireData;
              return ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  List likes = data.docs[index]['likes'];
                  List comments = (data.docs[index]['comments']);
                  List newList = comments.reversed.toList();
                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'New Announcement',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              data.docs[index]['fileUrl'] == null ||
                                      data.docs[index]['fileUrl'] == ''
                                  ? const SizedBox()
                                  : IconButton(
                                      onPressed: () async {
                                        var text =
                                            '${data.docs[index]['fileUrl']}';
                                        if (await canLaunch(text)) {
                                          await launch(text);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.attach_file,
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            data.docs[index]['name'],
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat.yMMMd()
                                    .add_jm()
                                    .format(data.docs[index]['date'].toDate()),
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'District: ${data.docs[index]['district']}',
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.thumb_up_sharp,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                  ),
                                  TextRegular(
                                      text: likes.length.toString(),
                                      fontSize: 14,
                                      color: Colors.blue),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: StatefulBuilder(
                                              builder: (context, setState) {
                                            return SizedBox(
                                              height: 400,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    top: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const CircleAvatar(
                                                                minRadius: 25,
                                                                maxRadius: 25,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                  'assets/images/profile.png',
                                                                )),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                TextBold(
                                                                    text:
                                                                        'From: Admin (You)',
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .black),
                                                                TextRegular(
                                                                    text: DateFormat
                                                                            .yMMMd()
                                                                        .add_jm()
                                                                        .format(data
                                                                            .docs[index][
                                                                                'date']
                                                                            .toDate()),
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .grey),
                                                                data.docs[index]['fileUrl'] ==
                                                                            null ||
                                                                        data.docs[index]['fileUrl'] ==
                                                                            ''
                                                                    ? const SizedBox()
                                                                    : TextRegular(
                                                                        text:
                                                                            '1 file attached',
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .grey),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        data.docs[index][
                                                                        'fileUrl'] ==
                                                                    null ||
                                                                data.docs[index]
                                                                        [
                                                                        'fileUrl'] ==
                                                                    ''
                                                            ? const SizedBox()
                                                            : IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  var text =
                                                                      '${data.docs[index]['fileUrl']}';
                                                                  if (await canLaunch(
                                                                      text)) {
                                                                    await launch(
                                                                        text);
                                                                  }
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .attach_file,
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20),
                                                      child: Column(
                                                        children: [
                                                          TextBold(
                                                              text: data.docs[
                                                                      index]
                                                                  ['name'],
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.black),
                                                          TextRegular(
                                                              text: data.docs[
                                                                      index]
                                                                  ['details'],
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black),
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                    Expanded(
                                                      child: SizedBox(
                                                        child:
                                                            ListView.separated(
                                                          reverse: true,
                                                          separatorBuilder:
                                                              (context, index) {
                                                            return const Divider(
                                                              color:
                                                                  Colors.grey,
                                                            );
                                                          },
                                                          itemCount:
                                                              newList.length,
                                                          itemBuilder: (context,
                                                              index1) {
                                                            return ListTile(
                                                              leading:
                                                                  const CircleAvatar(
                                                                minRadius: 20,
                                                                maxRadius: 20,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                        'assets/images/profile.png'),
                                                              ),
                                                              title: TextBold(
                                                                  text: newList[
                                                                          index1]
                                                                      [
                                                                      'userName'],
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                              subtitle: TextRegular(
                                                                  text: newList[
                                                                          index1]
                                                                      [
                                                                      'comment'],
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey),
                                                              trailing: TextRegular(
                                                                  text: DateFormat(
                                                                          'hh:mm a')
                                                                      .format(newList[index1]
                                                                              [
                                                                              'dateTime']
                                                                          .toDate()),
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      });
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.comment,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    TextRegular(
                                        text: '${comments.length} Comment/s',
                                        fontSize: 14,
                                        color: Colors.grey),
                                  ],
                                ),
                              ),
                              wids(
                                  data.docs[index].id,
                                  data.docs[index]['name'],
                                  data.docs[index]['details']),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => _showAddAnnouncementDialog(),
        tooltip: 'Add Announcement',
        child: const Icon(Icons.add),
      ),
    );
  }
}
