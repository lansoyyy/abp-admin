import 'package:cloud_firestore/cloud_firestore.dart';

Future addNotif(type, name) async {
  final docUser = FirebaseFirestore.instance.collection('Notif').doc();

  final json = {
    'name': name,
    'type': type,
    'dateTime': DateTime.now(),
    'isSeen': false,
  };

  await docUser.set(json);
}
