import 'package:app/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsfeedTab extends StatefulWidget {
  const NewsfeedTab({super.key});

  @override
  State<NewsfeedTab> createState() => _NewsfeedTabState();
}

class _NewsfeedTabState extends State<NewsfeedTab> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Container(
        color: Colors.white,
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

              final data12 = snapshot.requireData;
              return ListView.builder(
                  itemCount: data12.docs.length,
                  itemBuilder: ((context, index) {
                    List likes = data12.docs[index]['likes'];
                    List comments = (data12.docs[index]['comments']);
                    List newList = comments.reversed.toList();

                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 20,
                        child: Container(
                          color: Colors.white,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const CircleAvatar(
                                              minRadius: 25,
                                              maxRadius: 25,
                                              backgroundImage: AssetImage(
                                                'assets/images/profile.png',
                                              )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextBold(
                                                  text: 'From: Admin',
                                                  fontSize: 18,
                                                  color: Colors.black),
                                              TextRegular(
                                                  text: DateFormat.yMMMd()
                                                      .add_jm()
                                                      .format(data12.docs[index]
                                                              ['date']
                                                          .toDate()),
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                              TextRegular(
                                                  text:
                                                      'Disctrict: ${data12.docs[index]['district']}',
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                              data12.docs[index]['fileUrl'] ==
                                                          null ||
                                                      data12.docs[index]
                                                              ['fileUrl'] ==
                                                          ''
                                                  ? const SizedBox()
                                                  : TextRegular(
                                                      text: '1 file attached',
                                                      fontSize: 10,
                                                      color: Colors.grey),
                                            ],
                                          ),
                                        ],
                                      ),
                                      data12.docs[index]['fileUrl'] == null ||
                                              data12.docs[index]['fileUrl'] ==
                                                  ''
                                          ? const SizedBox()
                                          : IconButton(
                                              onPressed: () async {
                                                var text =
                                                    '${data12.docs[index]['fileUrl']}';
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
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    children: [
                                      TextBold(
                                          text: data12.docs[index]['name'],
                                          fontSize: 18,
                                          color: Colors.black),
                                      TextRegular(
                                          text: data12.docs[index]['details'],
                                          fontSize: 12,
                                          color: Colors.black),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (likes.contains(FirebaseAuth
                                                  .instance.currentUser!.uid)) {
                                                FirebaseFirestore.instance
                                                    .collection('Announcement')
                                                    .doc(data12.docs[index].id)
                                                    .update({
                                                  'likes':
                                                      FieldValue.arrayRemove([
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                  ]),
                                                });
                                              } else {
                                                FirebaseFirestore.instance
                                                    .collection('Announcement')
                                                    .doc(data12.docs[index].id)
                                                    .update({
                                                  'likes':
                                                      FieldValue.arrayUnion([
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                  ]),
                                                });
                                              }
                                            },
                                            icon: Icon(
                                              Icons.thumb_up_sharp,
                                              color: likes.contains(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid) ==
                                                      true
                                                  ? Colors.blue
                                                  : Colors.grey,
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
                                                      builder:
                                                          (context, setState) {
                                                    return SizedBox(
                                                      height: 400,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20,
                                                                right: 20,
                                                                top: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const CircleAvatar(
                                                                        minRadius:
                                                                            25,
                                                                        maxRadius:
                                                                            25,
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
                                                                                'From: Admin',
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                Colors.black),
                                                                        TextRegular(
                                                                            text: DateFormat.yMMMd().add_jm().format(data12.docs[index]['date']
                                                                                .toDate()),
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.grey),
                                                                        data12.docs[index]['fileUrl'] == null || data12.docs[index]['fileUrl'] == ''
                                                                            ? const SizedBox()
                                                                            : TextRegular(
                                                                                text: '1 file attached',
                                                                                fontSize: 10,
                                                                                color: Colors.grey),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                data12.docs[index]['fileUrl'] ==
                                                                            null ||
                                                                        data12.docs[index]['fileUrl'] ==
                                                                            ''
                                                                    ? const SizedBox()
                                                                    : IconButton(
                                                                        onPressed:
                                                                            () async {
                                                                          var text =
                                                                              '${data12.docs[index]['fileUrl']}';
                                                                          if (await canLaunch(
                                                                              text)) {
                                                                            await launch(text);
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
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 20),
                                                              child: Column(
                                                                children: [
                                                                  TextBold(
                                                                      text: data12
                                                                              .docs[index]
                                                                          [
                                                                          'name'],
                                                                      fontSize:
                                                                          18,
                                                                      color: Colors
                                                                          .black),
                                                                  TextRegular(
                                                                      text: data12
                                                                              .docs[index]
                                                                          [
                                                                          'details'],
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(),
                                                            Expanded(
                                                              child: SizedBox(
                                                                child: ListView
                                                                    .separated(
                                                                  reverse: true,
                                                                  separatorBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return const Divider(
                                                                      color: Colors
                                                                          .grey,
                                                                    );
                                                                  },
                                                                  itemCount:
                                                                      newList
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index1) {
                                                                    return ListTile(
                                                                      leading:
                                                                          const CircleAvatar(
                                                                        minRadius:
                                                                            20,
                                                                        maxRadius:
                                                                            20,
                                                                        backgroundImage:
                                                                            AssetImage('assets/images/profile.png'),
                                                                      ),
                                                                      title: TextBold(
                                                                          text: newList[index1]
                                                                              [
                                                                              'userName'],
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.black),
                                                                      subtitle: TextRegular(
                                                                          text: newList[index1]
                                                                              [
                                                                              'comment'],
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.grey),
                                                                      trailing: TextRegular(
                                                                          text: DateFormat('hh:mm a').format(newList[index1]['dateTime']
                                                                              .toDate()),
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.grey),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Center(
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                height: 40,
                                                                width: 275,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                ),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      commentController,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .text,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    suffixIcon: StreamBuilder<
                                                                            DocumentSnapshot>(
                                                                        stream:
                                                                            userData,
                                                                        builder:
                                                                            (context,
                                                                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return const Center(child: Text('Loading'));
                                                                          } else if (snapshot
                                                                              .hasError) {
                                                                            return const Center(child: Text('Something went wrong'));
                                                                          } else if (snapshot.connectionState ==
                                                                              ConnectionState.waiting) {
                                                                            return const Center(child: CircularProgressIndicator());
                                                                          }
                                                                          dynamic
                                                                              data1 =
                                                                              snapshot.data;
                                                                          return IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              if (commentController.text != '') {
                                                                                FirebaseFirestore.instance.collection('Announcement').doc(data12.docs[index].id).update({
                                                                                  'comments': FieldValue.arrayUnion([
                                                                                    {
                                                                                      'userId': FirebaseAuth.instance.currentUser!.uid,
                                                                                      'userName': data1['name'],
                                                                                      'comment': commentController.text,
                                                                                      'dateTime': DateTime.now(),
                                                                                    }
                                                                                  ]),
                                                                                });
                                                                                commentController.clear();
                                                                                Navigator.pop(context);
                                                                              }
                                                                            },
                                                                            icon:
                                                                                Icon(Icons.send, color: commentController.text != '' ? Colors.grey : Colors.blue),
                                                                          );
                                                                        }),
                                                                    hintText:
                                                                        '       Add comment',
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
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
                                                text:
                                                    '${comments.length} Comment/s',
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }));
            }));
  }
}
