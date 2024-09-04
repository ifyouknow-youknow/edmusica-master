import 'package:edm_master/COMPONENTS/border_view.dart';
import 'package:edm_master/COMPONENTS/button_view.dart';
import 'package:edm_master/COMPONENTS/calendar_view.dart';
import 'package:edm_master/COMPONENTS/main_view.dart';
import 'package:edm_master/COMPONENTS/padding_view.dart';
import 'package:edm_master/COMPONENTS/text_view.dart';
import 'package:edm_master/FUNCTIONS/nav.dart';
import 'package:edm_master/MODELS/DATAMASTER/datamaster.dart';
import 'package:edm_master/MODELS/constants.dart';
import 'package:edm_master/MODELS/firebase.dart';
import 'package:edm_master/MODELS/screen.dart';
import 'package:edm_master/VIEWS/navigation.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  final DataMaster dm;
  const Calendar({super.key, required this.dm});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Future<List<dynamic>> _fetchAllEvents() async {
    final allEvents = [];
    // TEACHER EVENTS
    final eventDocs = await firebase_GetAllDocuments('EdmusicaTeachers_Events');
    print(eventDocs);
    // ADMIN EVENTS
    // TASKS
    // MEETINGS

    //
    return allEvents;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
      // TOP
      PaddingView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TextView(
              text: 'CALENDAR',
              size: 20,
              weight: FontWeight.w600,
            ),
            ButtonView(
              child: const Icon(Icons.menu, size: 36),
              onPress: () {
                nav_Push(context, Navigation(dm: widget.dm));
              },
            )
          ],
        ),
      ),
      // MAIN
      Expanded(
        child: Row(
          children: [
            // LEFT
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaddingView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextView(
                        text: 'Today',
                        size: 28,
                        weight: FontWeight.w800,
                      ),
                      ButtonView(
                          child: const Icon(
                            Icons.add,
                            size: 38,
                          ),
                          onPress: () {
                            // NEW EVENT
                          })
                    ],
                  ),
                )
              ],
            )),
            // RIGHT
            SizedBox(
              width: getWidth(context) * 0.3,
              child: BorderView(
                left: true,
                leftColor: Colors.black26,
                child: PaddingView(
                  paddingBottom: 0,
                  paddingTop: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          child: CalendarView(year: 2024, onTapDate: (date) {}))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
