import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

class Member {
  final String name;
  final int age;
  final String email;

  Member({required this.name, required this.age, required this.email});
}

class ProfileTabAdmin extends StatefulWidget {
  const ProfileTabAdmin({super.key});

  @override
  State<ProfileTabAdmin> createState() => _ProfileTabAdminState();
}

class _ProfileTabAdminState extends State<ProfileTabAdmin> {
  final List<Member> _members = [
    Member(name: 'Alice', age: 30, email: 'alice@example.com'),
    Member(name: 'Bob', age: 35, email: 'bob@example.com'),
    Member(name: 'Charlie', age: 25, email: 'charlie@example.com'),
  ];

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

  String nameSearched = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: TextRegular(
            text: 'Member Profiles', fontSize: 18, color: Colors.white),
      ),
      body: Container(
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
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      nameSearched = value;
                    });
                  },
                  decoration: const InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(fontFamily: 'QRegular'),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      )),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextRegular(
                    text: 'District: ', fontSize: 14, color: Colors.black),
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
              ],
            ),
            Expanded(
                child: SizedBox(
                    child: MemberList(
              members: _members,
              district: district,
              name: nameSearched,
            ))),
          ],
        ),
      ),
    );
  }
}

class MemberItem extends StatelessWidget {
  final Member member;

  const MemberItem({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(member.name),
      subtitle: Text('Age: ${member.age} - Email: ${member.email}'),
      leading: CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(member.name[0]),
      ),
    );
  }
}

class MemberList extends StatelessWidget {
  final List<Member> members;

  final String district;
  final String name;

  const MemberList(
      {Key? key,
      required this.members,
      required this.district,
      required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('district', isEqualTo: district)
            .where('name',
                isGreaterThanOrEqualTo: toBeginningOfSentenceCase(name))
            .where('name', isLessThan: '${toBeginningOfSentenceCase(name)}z')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          return ListView.builder(
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 250,
                          child: Column(
                            children: [
                              data.docs[index]['status'] != 'Active'
                                  ? ListTile(
                                      onTap: () async {
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(data.docs[index].id)
                                            .update({'status': 'Active'});
                                        Navigator.pop(context);
                                      },
                                      title: TextRegular(
                                          text: 'Mark as Active',
                                          fontSize: 14,
                                          color: Colors.green),
                                      trailing: const Icon(
                                        Icons.arrow_right,
                                        color: Colors.green,
                                      ),
                                    )
                                  : const SizedBox(),
                              const Divider(),
                              data.docs[index]['status'] != 'Inactive'
                                  ? ListTile(
                                      onTap: () async {
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(data.docs[index].id)
                                            .update({'status': 'Inactive'});
                                        Navigator.pop(context);
                                      },
                                      title: TextRegular(
                                          text: 'Mark as Inactive',
                                          fontSize: 14,
                                          color: Colors.red),
                                      trailing: const Icon(
                                        Icons.arrow_right,
                                        color: Colors.red,
                                      ),
                                    )
                                  : const SizedBox(),
                              const Divider(),
                              data.docs[index]['status'] != 'Deceased'
                                  ? ListTile(
                                      onTap: () async {
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(data.docs[index].id)
                                            .update({'status': 'Deceased'});
                                        Navigator.pop(context);
                                      },
                                      title: TextRegular(
                                          text: 'Mark as Deceased',
                                          fontSize: 14,
                                          color: Colors.black),
                                      trailing: const Icon(
                                        Icons.arrow_right,
                                        color: Colors.black,
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        );
                      });
                },
                title: Text(
                  data.docs[index]['name'],
                  style: TextStyle(
                      color: data.docs[index]['status'] == 'Active'
                          ? Colors.green
                          : data.docs[index]['status'] == 'Inactive'
                              ? Colors.red
                              : Colors.black),
                ),
                subtitle: Text(
                    'Age: ${data.docs[index]['age']} - Email: ${data.docs[index]['email']}',
                    style: TextStyle(
                        color: data.docs[index]['status'] == 'Active'
                            ? Colors.green
                            : data.docs[index]['status'] == 'Inactive'
                                ? Colors.red
                                : Colors.black)),
                leading: CircleAvatar(
                  backgroundColor: data.docs[index]['status'] == 'Active'
                      ? Colors.green
                      : data.docs[index]['status'] == 'Inactive'
                          ? Colors.red
                          : Colors.black,
                  child: Text(data.docs[index]['name'][0]),
                ),
              );
            },
          );
        });
  }
}
