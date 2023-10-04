import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addAdmin(name, type, email) async {
  final docUser = FirebaseFirestore.instance
      .collection('Admins')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {'name': name, 'type': type, 'id': docUser.id, 'email': email};

  await docUser.set(json);
}
