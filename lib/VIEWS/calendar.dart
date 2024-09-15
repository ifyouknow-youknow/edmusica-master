import 'package:edm_master/COMPONENTS/border_view.dart';
import 'package:edm_master/COMPONENTS/button_view.dart';
import 'package:edm_master/COMPONENTS/calendar_view.dart';
import 'package:edm_master/COMPONENTS/future_view.dart';
import 'package:edm_master/COMPONENTS/main_view.dart';
import 'package:edm_master/COMPONENTS/padding_view.dart';
import 'package:edm_master/COMPONENTS/roundedcorners_view.dart';
import 'package:edm_master/COMPONENTS/text_view.dart';
import 'package:edm_master/FUNCTIONS/colors.dart';
import 'package:edm_master/FUNCTIONS/date.dart';
import 'package:edm_master/FUNCTIONS/nav.dart';
import 'package:edm_master/MODELS/DATAMASTER/datamaster.dart';
import 'package:edm_master/MODELS/constants.dart';
import 'package:edm_master/MODELS/firebase.dart';
import 'package:edm_master/MODELS/screen.dart';
import 'package:edm_master/VIEWS/navigation.dart';
import 'package:edm_master/VIEWS/new_event.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  final DataMaster dm;
  const Calendar({super.key, required this.dm});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDate = DateTime.now();

  Future<List<dynamic>> _fetchAllEvents() async {
    final allEvents = [];
    // TEACHER EVENTS
    final eventDocs = await firebase_GetAllDocumentsOrderedQueried(
        'Edmusica_Events',
        [
          {
            'field': 'date',
            'operator': '>=',
            'value': DateTime(_selectedDate.year, _selectedDate.month,
                    _selectedDate.day, 0, 0, 0)
                .millisecondsSinceEpoch
          },
          {
            'field': 'date',
            'operator': '<=',
            'value': DateTime(_selectedDate.year, _selectedDate.month,
                    _selectedDate.day, 23, 59, 59)
                .millisecondsSinceEpoch
          }
        ],
        'date',
        'asc');
    allEvents.addAll(eventDocs);
    // ADMIN EVENTS
    // TASKS
    // MEETINGS

    //
    return allEvents;
  }

  void onRemoveEvent(String eventId) async {
    setState(() {
      widget.dm.setToggleAlert(true);
      widget.dm.setAlertTitle('Remove Event');
      widget.dm.setAlertText('Are you sure you want to remove this event?');
      widget.dm.setAlertButtons([
        PaddingView(
          paddingTop: 0,
          paddingBottom: 0,
          child: ButtonView(
              child: const TextView(
                text: 'Remove',
                color: Colors.red,
                weight: FontWeight.w500,
                size: 18,
              ),
              onPress: () async {
                setState(() {
                  widget.dm.setToggleAlert(false);
                  widget.dm.setToggleLoading(true);
                });
                final success =
                    await firebase_DeleteDocument('${appName}_Events', eventId);
                if (success) {
                  setState(() {
                    widget.dm.setToggleLoading(false);
                  });
                }
              }),
        )
      ]);
    });
  }

  @override
  void initState() {
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
          crossAxisAlignment:
              CrossAxisAlignment.start, // Ensure left side aligns at the top
          children: [
            // LEFT
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TOP
                    PaddingView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextView(
                            text: formatDate(_selectedDate),
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
                                nav_Push(context, NewEvent(dm: widget.dm), () {
                                  setState(() {});
                                });
                              })
                        ],
                      ),
                    ),
                    // MAIN
                    FutureView(
                      future: _fetchAllEvents(),
                      childBuilder: (data) {
                        return PaddingView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var eve in data)
                                Column(
                                  children: [
                                    RoundedCornersView(
                                      backgroundColor: hexToColor("#E9F1FA"),
                                      child: PaddingView(
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  TextView(
                                                    text: formatTime(
                                                      DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                        eve['date'],
                                                      ),
                                                    ),
                                                    size: 34,
                                                    weight: FontWeight.w900,
                                                    spacing: -2,
                                                  ),
                                                  RoundedCornersView(
                                                    topLeft: 100,
                                                    topRight: 100,
                                                    bottomLeft: 100,
                                                    bottomRight: 100,
                                                    backgroundColor:
                                                        Colors.black,
                                                    child: PaddingView(
                                                      paddingTop: 8,
                                                      paddingBottom: 8,
                                                      paddingLeft: 18,
                                                      paddingRight: 18,
                                                      child: TextView(
                                                        text: eve['type'],
                                                        size: 18,
                                                        color: Colors.white,
                                                        weight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              TextView(
                                                text: eve['title'],
                                                size: 20,
                                                weight: FontWeight.w600,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  TextView(
                                                    text: eve['details']
                                                        .replaceAll(
                                                            "jjj", "\n"),
                                                    size: 16,
                                                  ),
                                                  ButtonView(
                                                      child: const TextView(
                                                        text: 'remove',
                                                        color: Colors.red,
                                                        weight: FontWeight.w600,
                                                      ),
                                                      onPress: () {
                                                        onRemoveEvent(
                                                            eve['id']);
                                                      })
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                )
                            ],
                          ),
                        );
                      },
                      emptyWidget: const Center(
                        child: TextView(
                          text: 'No events on this day.',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                        child: CalendarView(
                          year: 2024,
                          onTapDate: (date) {
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                          thisMonth: true,
                        ),
                      )
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
