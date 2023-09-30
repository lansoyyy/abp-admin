import 'package:app/screens/admin/admin_home.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/colors.dart';
import '../../widgets/button_widget.dart';

class LoginScreen extends StatefulWidget {
  final String type;

  const LoginScreen({super.key, required this.type});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  late String adminPassword;

  int loginCounter = 1;

  bool readyLogin = true;

  int count = 0;
  int count1 = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/back.jpg',
              ),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 175,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 175,
                    child: TextBold(
                        text: 'ABP: Ang Buhing Pulong Christian Community',
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextBold(
                text: 'Selected user type',
                fontSize: 14,
                color: Colors.black,
              ),
              const SizedBox(
                height: 10,
              ),
              ButtonWidget(
                color: primary,
                radius: 100,
                label: widget.type,
                onPressed: () {},
              ),
              const SizedBox(
                height: 30,
              ),
              TextBold(
                text: 'Continue with Google',
                fontSize: 18,
                color: Colors.black,
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                height: 50,
                color: primary,
                onPressed: () {
                  googleLogin();
                },
                child: SizedBox(
                  width: 260,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/googlelogo.png',
                        height: 25,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 55,
                      ),
                      TextBold(
                          text: 'Login with Google',
                          fontSize: 14,
                          color: Colors.white),
                    ],
                  ),
                ),
              ),

              // TextButton(
              //   onPressed: () {
              //     showDialog(
              //         context: context,
              //         builder: ((context) {
              //           return AlertDialog(
              //             title: TextBold(
              //                 text: 'Enter admin password',
              //                 fontSize: 14,
              //                 color: Colors.black),
              //             content: SizedBox(
              //               width: 100,
              //               height: 40,
              //               child: TextFormField(
              //                 obscureText: true,
              //                 decoration: const InputDecoration(
              //                   hintText: 'Admin password',
              //                   suffixIcon: Icon(Icons.lock),
              //                 ),
              //                 onChanged: ((value) {
              //                   adminPassword = value;
              //                 }),
              //               ),
              //             ),
              //             actions: [
              //               TextButton(
              //                 onPressed: (() {
              //                   if (adminPassword != 'admin123') {
              //                     ScaffoldMessenger.of(context).showSnackBar(
              //                       SnackBar(
              //                         content: TextRegular(
              //                             text: 'Invalid Password',
              //                             fontSize: 14,
              //                             color: Colors.white),
              //                       ),
              //                     );
              //                     Navigator.pop(context);
              //                   } else {
              //                     Navigator.of(context).pushReplacement(
              //                         MaterialPageRoute(
              //                             builder: (context) =>
              //                                 const AdminHome()));
              //                   }
              //                 }),
              //                 child: TextBold(
              //                     text: 'Continue',
              //                     fontSize: 18,
              //                     color: Colors.black),
              //               ),
              //             ],
              //           );
              //         }));
              //   },
              //   child: TextBold(
              //       text: 'Login as admin', fontSize: 12, color: Colors.blue),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  googleLogin() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

    try {
      final googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return;
      }
      final googleSignInAuth = await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuth.accessToken,
        idToken: googleSignInAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminHome()));
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
