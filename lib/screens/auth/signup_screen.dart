import 'package:app/screens/home_screen.dart';
import 'package:app/services/signup.dart';
import 'package:app/widgets/button_widget.dart';
import 'package:app/widgets/textfield_widget.dart';
import 'package:app/widgets/toast_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/text_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();

  final ageController = TextEditingController();

  final birthdayController = TextEditingController();

  final genderController = TextEditingController();

  final addressController = TextEditingController();

  final districtController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  List<String> districts = [
    'St. John',
    'St. Luke',
    'St. Mark',
    'St. Matthias',
    'St. Matthew',
    'St. Paul',
  ];

  String district = 'St. John';

  int dropdownValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                    height: 125,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 175,
                    child: TextBold(
                        text: 'ABP: Ang Buhing Pulong Christian Community',
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldWidget(
                  inputType: TextInputType.emailAddress,
                  label: 'Email',
                  controller: emailController),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                  isPassword: true,
                  isObscure: true,
                  label: 'Password',
                  controller: passwordController),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                  isPassword: true,
                  isObscure: true,
                  label: 'Confirm Password',
                  controller: confirmPasswordController),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(label: 'Name', controller: nameController),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                  inputType: TextInputType.number,
                  label: 'Age',
                  controller: ageController),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                  inputType: TextInputType.datetime,
                  label: 'Birthday',
                  controller: birthdayController),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(label: 'Gender', controller: genderController),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(label: 'Address', controller: addressController),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, bottom: 10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: TextRegular(
                        text: 'District:', fontSize: 14, color: Colors.black)),
              ),
              Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton(
                  value: dropdownValue,
                  items: [
                    for (int i = 0; i < districts.length; i++)
                      DropdownMenuItem(
                        value: i,
                        onTap: () {
                          setState(() {
                            district = districts[i];
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextRegular(
                              text: districts[i],
                              fontSize: 14,
                              color: Colors.black),
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = int.parse(value.toString());
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ButtonWidget(
                  label: 'Signup',
                  onPressed: (() {
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      showToast('Cannot Procceed! Password do not match');
                    } else {
                      register(context);
                    }
                  })),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  register(context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      signup(
          nameController.text,
          ageController.text,
          birthdayController.text,
          genderController.text,
          addressController.text,
          district,
          emailController.text);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      showToast("Registered Succesfully!");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }
}
