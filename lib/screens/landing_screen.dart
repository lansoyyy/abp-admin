import 'package:app/screens/auth/login_screen.dart';
import 'package:app/utils/colors.dart';
import 'package:app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/text_widget.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

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
              height: 50,
            ),
            ButtonWidget(
              color: primary,
              radius: 100,
              label: 'Senior Coordinator',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen(
                          type: 'Senior Coordinator',
                        )));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              color: primary,
              radius: 100,
              label: 'District Coordinator',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen(
                          type: 'District Coordinator',
                        )));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              color: primary,
              radius: 100,
              label: 'MWG',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen(
                          type: 'MWG',
                        )));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextBold(
                  text: 'Data Privacy Act',
                  fontSize: 14,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
                const SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: Colors.black,
                    )),
                const SizedBox(
                  width: 10,
                ),
                TextBold(
                  text: 'Privacy Policy',
                  fontSize: 14,
                  color: Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
