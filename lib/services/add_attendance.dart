import 'package:cloud_firestore/cloud_firestore.dart';

Future addAttendance(name, age, email, day, month, year, district) async {
  final docUser = FirebaseFirestore.instance.collection('Attendance').doc();

  final json = {
    'name': name,
    'age': age,
    'email': email,
    'day': day,
    'month': month,
    'year': year,
    'dateTime': DateTime.now(),
    'district': district
  };

  await docUser.set(json);
}
