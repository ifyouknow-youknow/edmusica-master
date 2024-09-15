import 'package:edm_master/COMPONENTS/border_view.dart';
import 'package:edm_master/COMPONENTS/button_view.dart';
import 'package:edm_master/COMPONENTS/dropdown_view.dart';
import 'package:edm_master/COMPONENTS/main_view.dart';
import 'package:edm_master/COMPONENTS/padding_view.dart';
import 'package:edm_master/COMPONENTS/roundedcorners_view.dart';
import 'package:edm_master/COMPONENTS/text_view.dart';
import 'package:edm_master/COMPONENTS/textfield_view.dart';
import 'package:edm_master/FUNCTIONS/colors.dart';
import 'package:edm_master/FUNCTIONS/date.dart';
import 'package:edm_master/FUNCTIONS/misc.dart';
import 'package:edm_master/FUNCTIONS/nav.dart';
import 'package:edm_master/MODELS/DATAMASTER/datamaster.dart';
import 'package:edm_master/MODELS/constants.dart';
import 'package:edm_master/MODELS/firebase.dart';
import 'package:edm_master/MODELS/screen.dart';
import 'package:flutter/material.dart';

class NewEvent extends StatefulWidget {
  final DataMaster dm;
  const NewEvent({super.key, required this.dm});

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCalendar = "Teachers";
  TextEditingController _detailsController = TextEditingController();
  String _eventType = "Meeting";
  List<dynamic> _districts = [];
  Map<String, dynamic> _selectedDistrict = {};

  //
  void onCreate() async {
    if (_titleController.text.isEmpty) {
      setState(() {
        widget.dm.setAlertTitle('Missing Title');
        widget.dm.setAlertText('Please provide a valid title for this event.');
        widget.dm.setToggleAlert(true);
      });
      return;
    }

    setState(() {
      widget.dm.setToggleLoading(true);
    });

    final obj = {
      'date': _selectedDate.millisecondsSinceEpoch,
      'dateStr': _selectedDate.toIso8601String(),
      'details': _detailsController.text.replaceAll('\n', 'jjj'),
      'title': _titleController.text,
      'districtId': _selectedDistrict['id'],
      'type': _selectedCalendar != 'Tasks' ? _eventType : 'Task'
    };
    final success = await firebase_CreateDocument(
        'Edmusica_${_selectedCalendar == 'Teachers' ? 'Events' : _selectedCalendar == 'Admin' ? 'AdminEvents' : 'AdminTasks'}',
        randomString(25),
        obj);
    if (success) {
      setState(() {
        widget.dm.setToggleLoading(false);
        nav_Pop(context);
      });
    }
  }

//
  void init() async {
    final districts = await firebase_GetAllDocuments('Edmusica_Districts');
    if (districts.isNotEmpty) {
      setState(() {
        _selectedDistrict = districts.first;
        _districts = districts;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
      // TOP
      PaddingView(
        paddingTop: 0,
        paddingBottom: 0,
        child: Row(
          children: [
            ButtonView(
                child: Row(
                  children: [
                    Icon(
                      Icons.chevron_left,
                      size: 26,
                      color: hexToColor("#253677"),
                    ),
                    TextView(
                      text: 'back',
                      size: 18,
                      weight: FontWeight.w500,
                      color: hexToColor("#253677"),
                    ),
                  ],
                ),
                onPress: () {
                  nav_Pop(context);
                })
          ],
        ),
      ),
      // MAIN
      Expanded(
        child: SingleChildScrollView(
          child: Center(
            child: RoundedCornersView(
              backgroundColor: hexToColor("#E9F1FA"),
              child: PaddingView(
                child: SizedBox(
                  width: getWidth(context) * 0.5,
                  child: PaddingView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TITLE
                        const Row(
                          children: [
                            TextView(
                              text: 'New Event',
                              size: 30,
                              weight: FontWeight.w700,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // FORM
                        // TITLE
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextView(
                              text: 'title',
                              size: 16,
                              weight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BorderView(
                              bottom: true,
                              bottomWidth: 2,
                              bottomColor: Colors.black,
                              child: TextfieldView(
                                controller: _titleController,
                                placeholder: 'ex. Music Teacher Training',
                                backgroundColor: Colors.transparent,
                                paddingH: 0,
                                size: 24,
                                radius: 0,
                              ),
                            )
                          ],
                        ),

                        // DATE
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextView(
                              text: 'date',
                              size: 16,
                              weight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextView(
                                        text: formatDate(_selectedDate),
                                        size: 20,
                                      ),
                                      ButtonView(
                                          child: Icon(
                                            Icons.calendar_month,
                                            size: 34,
                                            color: hexToColor("#3490F3"),
                                          ),
                                          onPress: () async {
                                            final pickedDate = await selectDate(
                                                context,
                                                initialDate: _selectedDate);
                                            if (pickedDate != null) {
                                              setState(() {
                                                _selectedDate = DateTime(
                                                    pickedDate.year,
                                                    pickedDate.month,
                                                    pickedDate.day,
                                                    _selectedDate.hour,
                                                    _selectedDate.minute);
                                              });
                                            }
                                          })
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextView(
                                        text: formatTime(_selectedDate),
                                        size: 20,
                                      ),
                                      ButtonView(
                                          child: Icon(
                                            Icons.schedule,
                                            size: 34,
                                            color: hexToColor("#3490F3"),
                                          ),
                                          onPress: () async {
                                            final pickedTime = await selectTime(
                                                context,
                                                initialTime: TimeOfDay(
                                                    hour: _selectedDate.hour,
                                                    minute:
                                                        _selectedDate.minute));
                                            if (pickedTime != null) {
                                              setState(() {
                                                _selectedDate = DateTime(
                                                    _selectedDate.year,
                                                    _selectedDate.month,
                                                    _selectedDate.day,
                                                    pickedTime.hour,
                                                    pickedTime.minute);
                                              });
                                            }
                                          })
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),

                        // CALENDAR
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextView(
                              text: 'calendar',
                              size: 16,
                              weight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            DropdownView(
                                defaultValue: 'Teachers',
                                backgroundColor: Colors.white,
                                items: const [
                                  'Teachers',
                                  'Admin',
                                  'Tasks',
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCalendar = value;
                                  });
                                })
                          ],
                        ),

                        // DETAILS
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextView(
                              text: 'details',
                              size: 16,
                              weight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextfieldView(
                              controller: _detailsController,
                              placeholder:
                                  'ex. In this training, we will explore various exercises designed to enhance students recorder technique, helping them progress and achieve a better sound quality.',
                              multiline: true,
                              minLines: 4,
                              maxLines: 8,
                            )
                          ],
                        ),

                        //  TYPE
                        const SizedBox(
                          height: 15,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextView(
                              text: 'district',
                              size: 16,
                              weight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (_districts.isNotEmpty)
                              DropdownView(
                                backgroundColor: Colors.white,
                                items: _districts
                                    .map((d) => d['name'] as String)
                                    .toList(), // Ensure it's a list
                                onChanged: (value) {
                                  setState(() {
                                    _eventType = value;
                                  });
                                },
                              )
                          ],
                        ),

                        //  TYPE
                        const SizedBox(
                          height: 15,
                        ),
                        if (_selectedCalendar != 'Tasks')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextView(
                                text: 'type',
                                size: 16,
                                weight: FontWeight.w500,
                                color: Colors.black45,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownView(
                                  defaultValue: 'Meeting',
                                  backgroundColor: Colors.white,
                                  items: const [
                                    'Meeting',
                                    'Training',
                                    'Concert',
                                    'Holiday',
                                    'Special Event',
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _eventType = value;
                                    });
                                  })
                            ],
                          ),

                        // BUTTON
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonView(
                                backgroundColor: hexToColor("#1985C6"),
                                paddingTop: 8,
                                paddingBottom: 8,
                                paddingLeft: 18,
                                paddingRight: 18,
                                radius: 100,
                                child: const Row(
                                  children: [
                                    TextView(
                                      text: 'create',
                                      size: 18,
                                      weight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      Icons.add,
                                      size: 26,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                onPress: () {
                                  onCreate();
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
