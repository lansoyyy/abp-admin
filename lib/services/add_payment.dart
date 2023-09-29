import 'package:cloud_firestore/cloud_firestore.dart';

Future addPayment(double amount, name, purpose, district) async {
  final docUser = FirebaseFirestore.instance.collection('Payment').doc();

  final json = {
    'name': name,
    'amount': amount,
    'dateTime': DateTime.now(),
    'isPaid': false,
    'purpose': purpose,
    'district': district
  };

  await docUser.set(json);
}
