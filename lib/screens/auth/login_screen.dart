import 'dart:async';

import 'package:app/screens/admin/admin_home.dart';
import 'package:app/screens/auth/signup_screen.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/widgets/button_widget.dart';
import 'package:app/widgets/text_widget.dart';
import 'package:app/widgets/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/toast_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
              TextFieldWidget(label: 'Email', controller: usernameController),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  TextFieldWidget(
                      isPassword: true,
                      isObscure: true,
                      label: 'Password',
                      controller: passwordController),
                  Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: ((context) {
                              final formKey = GlobalKey<FormState>();
                              final TextEditingController emailController =
                                  TextEditingController();

                              return AlertDialog(
                                backgroundColor: Colors.grey[100],
                                title: TextRegular(
                                  text: 'Forgot Password',
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                content: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFieldWidget(
                                        hint: 'Email',
                                        inputType: TextInputType.emailAddress,
                                        label: 'Email',
                                        controller: emailController,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: (() {
                                      Navigator.pop(context);
                                    }),
                                    child: TextRegular(
                                      text: 'Cancel',
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: (() async {
                                      try {
                                        Navigator.pop(context);
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: emailController.text);
                                        showToast(
                                            'Password reset link sent to ${emailController.text}');
                                      } catch (e) {
                                        String errorMessage = '';

                                        if (e is FirebaseException) {
                                          switch (e.code) {
                                            case 'invalid-email':
                                              errorMessage =
                                                  'The email address is invalid.';
                                              break;
                                            case 'user-not-found':
                                              errorMessage =
                                                  'The user associated with the email address is not found.';
                                              break;
                                            default:
                                              errorMessage =
                                                  'An error occurred while resetting the password.';
                                          }
                                        } else {
                                          errorMessage =
                                              'An error occurred while resetting the password.';
                                        }

                                        showToast(errorMessage);
                                        Navigator.pop(context);
                                      }
                                    }),
                                    child: TextBold(
                                      text: 'Continue',
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          );
                        },
                        child: TextRegular(
                            text: 'Forgot Password?',
                            fontSize: 12,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ButtonWidget(
                  label: readyLogin
                      ? 'Login'
                      : 'Please try again in $count1 seconds',
                  onPressed: () {
                    if (readyLogin) {
                      login(context);
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextRegular(
                      text: "Don't have an account?",
                      fontSize: 12,
                      color: Colors.black),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignupScreen()));
                    },
                    child: TextBold(
                        text: "Signup", fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
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

  login(context) async {
    if (loginCounter > 2) {
      setState(() {
        readyLogin = false;
      });
      showToast("Login attempt failed! Please try again in 20 seconds");

      Timer.periodic(const Duration(seconds: 1), (timer) {
        count++;
        setState(() {
          count1--;
        });
        if (count == 20) {
          setState(() {
            loginCounter = 0;
            readyLogin = true;
          });
          timer.cancel();
        }
      });
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: usernameController.text, password: passwordController.text);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      } on Exception catch (e) {
        showToast("An error occurred: $e");

        setState(() {
          loginCounter++;
        });
      }
    }
  }
}
