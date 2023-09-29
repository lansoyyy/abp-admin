import 'package:app/services/add_attendance.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../widgets/text_widget.dart';
import 'package:intl/intl.dart';

class Member {
  final String name;
  final int age;
  final String email;

  Member({required this.name, required this.age, required this.email});
}

class AttendanceTab extends StatefulWidget {
  const AttendanceTab({super.key});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  final List<Member> _members = [
    Member(name: 'Alice', age: 30, email: 'alice@example.com'),
    Member(name: 'Bob', age: 35, email: 'bob@example.com'),
    Member(name: 'Charlie', age: 25, email: 'charlie@example.com'),
  ];

  String qrCode = '';

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
      });

      FirebaseFirestore.instance
          .collection('Users')
          .where('id', isEqualTo: qrCode)
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          addAttendance(
              doc['name'],
              doc['age'],
              doc['email'],
              DateTime.now().day,
              DateTime.now().month,
              DateTime.now().year,
              doc['district']);
        }

        Navigator.of(context).pop();
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          scanQRCode();
        },
        tooltip: 'Add Announcement',
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Builder(builder: (context) {
          final now = DateTime.now();
          final formatter = DateFormat('yyyy-MM-dd');
          final formattedDate = formatter.format(now);
          return TextRegular(
              text: 'Attendance ($formattedDate)',
              fontSize: 18,
              color: Colors.white);
        }),
      ),
      body: CellCalendar(
        onCellTapped: (p0) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: TextRegular(
                            text: 'Close', fontSize: 14, color: Colors.black),
                      ),
                    ],
                    content: SizedBox(
                        width: 300,
                        height: 300,
                        child: MemberList(
                          members: _members,
                          dateTime: p0,
                        )));
              });
        },
      ),
    );
  }
}

class MemberItem extends StatelessWidget {
  final Member member;

  const MemberItem({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(member.name),
      subtitle: Text('Age: ${member.age} - Email: ${member.email}'),
      leading: CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(member.name[0]),
      ),
    );
  }
}

class MemberList extends StatelessWidget {
  final List<Member> members;
  final DateTime dateTime;

  const MemberList({Key? key, required this.members, required this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Attendance')
            .where('year', isEqualTo: dateTime.year)
            .where('month', isEqualTo: dateTime.month)
            .where('day', isEqualTo: dateTime.day)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data.docs[index]['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Age: ${data.docs[index]['age']} - Email: ${data.docs[index]['email']}'),
                    Text('District: ${data.docs[index]['district']} '),
                  ],
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text(data.docs[index]['name'][0]),
                ),
              );
            },
          );
        });
  }
}
