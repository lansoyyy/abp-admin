import 'package:app/screens/admin/tabs/announcements_tab.dart';
import 'package:app/screens/admin/tabs/attendance_tab.dart';
import 'package:app/screens/admin/tabs/events_tab.dart';
import 'package:app/screens/admin/tabs/payments_tab.dart';
import 'package:app/screens/admin/tabs/profile_tab.dart';
import 'package:app/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../widgets/text_widget.dart';

class AdminHome extends StatelessWidget {
  final box = GetStorage();

  AdminHome({super.key});

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
                height: 50,
              ),
              ButtonWidget(
                radius: 100,
                color: Colors.black,
                label: 'Set events and activities',
                onPressed: (() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EventsTab()));
                }),
              ),
              const SizedBox(
                height: 15,
              ),
              ButtonWidget(
                radius: 100,
                color: Colors.black,
                label: 'Record payments',
                onPressed: (() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PaymentsTab()));
                }),
              ),
              const SizedBox(
                height: 15,
              ),
              ButtonWidget(
                radius: 100,
                color: Colors.black,
                label: 'Attendance',
                onPressed: (() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AttendanceTab()));
                }),
              ),
              const SizedBox(
                height: 15,
              ),
              ButtonWidget(
                radius: 100,
                color: Colors.black,
                label: 'Post announcements',
                onPressed: (() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AnnouncementsTab()));
                }),
              ),
              const SizedBox(
                height: 15,
              ),
              ButtonWidget(
                radius: 100,
                color: Colors.black,
                label: 'Member profile',
                onPressed: (() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfileTabAdmin()));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
