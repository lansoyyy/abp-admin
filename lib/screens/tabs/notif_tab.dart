import 'package:app/screens/home_screen.dart';
import 'package:app/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotifTab extends StatelessWidget {
  const NotifTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: TextRegular(
          text: 'Notifications',
          fontSize: 18,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Notif').snapshots(),
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
            return Container(
              color: Colors.white,
              child: ListView.builder(
                  itemCount: data.docs.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 2,
                        child: ListTile(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('Notif')
                                .doc(data.docs[index].id)
                                .update(
                              {
                                'isSeen': true,
                              },
                            );

                            if (data.docs[index]['type'] == 'Announcement') {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            currentIndex: 0,
                                          )));
                            } else {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            currentIndex: 1,
                                          )));
                            }
                          },
                          tileColor: Colors.white,
                          leading: Icon(
                            Icons.notifications_active_outlined,
                            color: data.docs[index]['isSeen'] == false
                                ? Colors.blue
                                : Colors.black,
                          ),
                          title: TextBold(
                              text: 'Notification: ${data.docs[index]['type']}',
                              fontSize: 14,
                              color: data.docs[index]['isSeen'] == false
                                  ? Colors.blue
                                  : Colors.black),
                          subtitle: TextRegular(
                              text: DateFormat.yMMMd().add_jm().format(
                                    data.docs[index]['dateTime'].toDate(),
                                  ),
                              fontSize: 11,
                              color: data.docs[index]['isSeen'] == false
                                  ? Colors.blue
                                  : Colors.grey),
                          trailing: Icon(
                            Icons.arrow_right,
                            color: data.docs[index]['isSeen'] == false
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  })),
            );
          }),
    );
  }
}
