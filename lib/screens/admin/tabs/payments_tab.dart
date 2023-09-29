import 'package:app/services/add_payment.dart';
import 'package:app/widgets/toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import '../../../widgets/text_widget.dart';
import '../../../widgets/textfield_widget.dart';

class PaymentsTab extends StatefulWidget {
  const PaymentsTab({super.key});

  @override
  _PaymentsTabState createState() => _PaymentsTabState();
}

class _PaymentsTabState extends State<PaymentsTab> {
  final List<Payment> _payments = [
    Payment(
        title: 'Rent',
        amount: 1000.00,
        date: DateTime(2023, 3, 1),
        isPaid: true,
        person: Person(name: 'John Smith', email: 'johnsmith@gmail.com')),
    Payment(
        title: 'Electricity Bill',
        amount: 250.00,
        date: DateTime(2023, 3, 5),
        isPaid: true,
        person: Person(name: 'Jane Doe', email: 'janedoe@gmail.com')),
    Payment(
        title: 'Internet Bill',
        amount: 100.00,
        date: DateTime(2023, 3, 10),
        isPaid: false,
        person: Person(name: 'Bob Johnson', email: 'bobjohnson@gmail.com')),
  ];

  Widget wids(id, name) {
    if (FirebaseAuth.instance.currentUser != null) {
      return const SizedBox();
    }

    return SizedBox(
      width: 100,
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: ((context) {
                  final formKey = GlobalKey<FormState>();
                  final TextEditingController emailController =
                      TextEditingController();

                  return AlertDialog(
                    backgroundColor: Colors.grey[100],
                    title: TextRegular(
                      text: 'Editing payment record',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    content: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFieldWidget(
                            hint: name,
                            label: 'Name',
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
                            await FirebaseFirestore.instance
                                .collection('Payment')
                                .doc(id)
                                .update({'name': emailController.text});
                          } catch (e) {
                            showToast(e);

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
            icon: const Icon(
              Icons.edit,
            ),
          ),
          IconButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text(
                          'Delete Confirmation',
                          style: TextStyle(
                              fontFamily: 'QBold', fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                          'Are you sure you want delete this data?',
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
                              Navigator.of(context).pop();
                              await FirebaseFirestore.instance
                                  .collection('Payment')
                                  .doc(id)
                                  .delete();
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
              Icons.delete_outline_rounded,
            ),
          ),
        ],
      ),
    );
  }

  String nameSearched = '';

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
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: TextRegular(text: 'Payments', fontSize: 18, color: Colors.white),
      ),
      body: Column(
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
            height: 10,
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
                  underline: const SizedBox(),
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
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Payment')
                  .where('name',
                      isGreaterThanOrEqualTo:
                          toBeginningOfSentenceCase(nameSearched))
                  .where('name',
                      isLessThan: '${toBeginningOfSentenceCase(nameSearched)}z')
                  .where('district', isEqualTo: district)
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
                return Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: data.docs.length,
                      itemBuilder: (context, index) {
                        String formattedDate = DateFormat('yyyy/MM/dd')
                            .format(data.docs[index]['dateTime'].toDate());
                        return ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextBold(
                                            text: 'Purpose of Payment:',
                                            fontSize: 15,
                                            color: Colors.black),
                                        TextRegular(
                                            text: data.docs[index]['purpose'],
                                            fontSize: 14,
                                            color: Colors.grey),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: TextRegular(
                                            text: 'Close',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ],
                                  );
                                });
                          },
                          leading: const CircleAvatar(
                            minRadius: 25,
                            maxRadius: 25,
                            backgroundImage:
                                AssetImage('assets/images/profile.png'),
                          ),
                          title: Text(
                              '₱${data.docs[index]['amount'].toStringAsFixed(2)}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${data.docs[index]['name']}'),
                              Text('District: ${data.docs[index]['district']}'),
                              Text(formattedDate),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: data.docs[index]['isPaid'],
                                  onChanged: (value) async {
                                    if (value == true) {
                                      showToast('Marked as paid');

                                      await FirebaseFirestore.instance
                                          .collection('Payment')
                                          .doc(data.docs[index].id)
                                          .update({'isPaid': true});
                                    } else {
                                      showToast('Marked as unpaid');
                                      await FirebaseFirestore.instance
                                          .collection('Payment')
                                          .doc(data.docs[index].id)
                                          .update({'isPaid': false});
                                    }
                                  },
                                ),
                                wids(data.docs[index].id,
                                    data.docs[index]['name'])
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // Create a TextEditingController for each field

              TextEditingController amountController = TextEditingController();

              TextEditingController personNameController =
                  TextEditingController();
              TextEditingController purposeController = TextEditingController();

              return AlertDialog(
                title: const Text('Add Payment'),
                content: StatefulBuilder(builder: (context, setState) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: amountController,
                          decoration:
                              const InputDecoration(labelText: 'Amount'),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: personNameController,
                          decoration:
                              const InputDecoration(labelText: 'Person Name'),
                        ),
                        TextField(
                          controller: purposeController,
                          decoration: const InputDecoration(
                              labelText: 'Purpose of Payment'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextRegular(
                                text: 'District:',
                                fontSize: 12,
                                color: Colors.grey),
                            const SizedBox()
                          ],
                        ),
                        const SizedBox(
                          height: 3,
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
                            underline: const SizedBox(),
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
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
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
                  );
                }),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () {
                      addPayment(
                          double.parse(amountController.text),
                          personNameController.text,
                          purposeController.text,
                          district);
                      Navigator.of(context).pop();
                    },
                    child: const Text('ADD'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Payment {
  final String title;
  final double amount;
  final DateTime date;
  bool isPaid;
  final Person person;

  Payment(
      {required this.title,
      required this.amount,
      required this.date,
      required this.isPaid,
      required this.person});
}

class Person {
  final String name;
  final String email;

  Person({required this.name, required this.email});
}
