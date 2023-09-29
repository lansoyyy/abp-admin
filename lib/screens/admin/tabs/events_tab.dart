import 'package:app/widgets/add_event_dialog.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../widgets/event_dialog.dart';
import '../../../widgets/text_widget.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  @override
  void initState() {
    super.initState();
    getEvents();
  }

  List<CalendarEvent> events = [];
  bool hasLoaded = false;

  getEvents() async {
    await FirebaseFirestore.instance
        .collection('Events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        events.add(CalendarEvent(
            eventName: doc['name'], eventDate: doc['date'].toDate()));
      }

      setState(() {
        hasLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return hasLoaded
        ? Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AddEventDialog();
                  },
                );
              },
              tooltip: 'Add Announcement',
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              backgroundColor: Colors.black,
              centerTitle: true,
              title: TextRegular(
                  text: 'Events and Activities',
                  fontSize: 18,
                  color: Colors.white),
            ),
            body: CellCalendar(
              events: events,
              onCellTapped: (date) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Events')
                            .where('year', isEqualTo: date.year)
                            .where('month', isEqualTo: date.month)
                            .where('day', isEqualTo: date.day)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print('error');
                            return const Center(child: Text('Error'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.black,
                              )),
                            );
                          }

                          final data = snapshot.requireData;
                          return EventDialog(
                            events: [
                              for (int i = 0; i < data.docs.length; i++)
                                {
                                  'title': data.docs[i]['name'],
                                  'date': DateFormat.yMMMd()
                                      .add_jm()
                                      .format(data.docs[i]['date'].toDate()),
                                  'id': data.docs[i].id,
                                  'district': data.docs[i]['district']
                                },
                            ],
                          );
                        });
                  },
                );
              },
            ))
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
