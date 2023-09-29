import 'package:app/services/add_notif.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future addAnnouncemenets(name, details, date, fileUrl, district) async {
  final docUser = FirebaseFirestore.instance.collection('Announcement').doc();

  final json = {
    'name': name,
    'date': date,
    'details': details,
    'fileUrl': fileUrl,
    'likes': [],
    'comments': [],
    'district': district
  };

  addNotif('Announcement', name);
  await docUser.set(json);
}
