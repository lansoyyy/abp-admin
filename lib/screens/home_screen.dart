import 'package:app/screens/landing_screen.dart';
import 'package:app/screens/tabs/calendar_tab.dart';
import 'package:app/screens/tabs/newsfeed_tab.dart';
import 'package:app/screens/tabs/notif_tab.dart';
import 'package:app/screens/tabs/profile_tab.dart';
import 'package:app/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  int? currentIndex;

  HomeScreen({
    super.key,
    this.currentIndex = 0,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void onTabTapped(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }

  final List<Widget> children = [
    const NewsfeedTab(),
    const CalendarTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextRegular(text: 'ABP', fontSize: 18, color: Colors.white),
        centerTitle: true,
        actions: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Notif')
                  .where('isSeen', isEqualTo: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print('error');
                  return const Center(child: Text('Error'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                    )),
                  );
                }

                final data = snapshot.requireData;
                return IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NotifTab()));
                  },
                  icon: Badge(
                    label: TextRegular(
                      text: data.docs.length.toString(),
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.notifications,
                    ),
                  ),
                );
              }),
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text(
                          'Logout Confirmation',
                          style: TextStyle(
                              fontFamily: 'QBold', fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                          'Are you sure you want to Logout?',
                          style: TextStyle(fontFamily: 'QRegular'),
                        ),
                        actions: <Widget>[
                          MaterialButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                  fontFamily: 'QRegular',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LandingScreen()));
                            },
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                  fontFamily: 'QRegular',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ));
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: children[widget.currentIndex!],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontFamily: 'QBold'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'QBold'),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: onTabTapped,
        currentIndex: widget.currentIndex!,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
