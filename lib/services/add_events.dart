import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_notif.dart';

Future addEvents(name, details, date, day, month, year, district) async {
  final docUser = FirebaseFirestore.instance.collection('Events').doc();

  final json = {
    'name': name,
    'details': details,
    'date': date,
    'day': day,
    'month': month,
    'year': year,
    'district': district
  };

  addNotif('Event', name);

  await docUser.set(json);
}
