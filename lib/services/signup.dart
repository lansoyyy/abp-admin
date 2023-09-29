import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future signup(name, age, birthday, gender, address, district, email) async {
  final docUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'name': name,
    'age': age,
    'address': address,
    'email': email,
    'id': docUser.id,
    'birthday': birthday,
    'gender': gender,
    'district': district,
    'profilePicture': 'https://cdn-icons-png.flaticon.com/256/149/149071.png',
    'status': 'Active'
  };

  await docUser.set(json);
}
