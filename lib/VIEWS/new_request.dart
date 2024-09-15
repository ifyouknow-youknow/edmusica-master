import 'package:edm_master/COMPONENTS/border_view.dart';
import 'package:edm_master/COMPONENTS/button_view.dart';
import 'package:edm_master/COMPONENTS/dropdown_view.dart';
import 'package:edm_master/COMPONENTS/main_view.dart';
import 'package:edm_master/COMPONENTS/padding_view.dart';
import 'package:edm_master/COMPONENTS/roundedcorners_view.dart';
import 'package:edm_master/COMPONENTS/text_view.dart';
import 'package:edm_master/COMPONENTS/textfield_view.dart';
import 'package:edm_master/FUNCTIONS/colors.dart';
import 'package:edm_master/FUNCTIONS/misc.dart';
import 'package:edm_master/FUNCTIONS/nav.dart';
import 'package:edm_master/MODELS/DATAMASTER/datamaster.dart';
import 'package:edm_master/MODELS/constants.dart';
import 'package:edm_master/MODELS/firebase.dart';
import 'package:edm_master/MODELS/screen.dart';
import 'package:flutter/material.dart';

class NewRequest extends StatefulWidget {
  final DataMaster dm;
  const NewRequest({super.key, required this.dm});

  @override
  State<NewRequest> createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
//
  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  String _requestedBy = "Alfredo";
  String _assignedTo = 'Alfredo';
  String _priority = "high";

  void onCreate() async {
    setState(() {
      widget.dm.setToggleAlert(true);
      widget.dm.setAlertTitle('Create Request');
      widget.dm.setAlertText('Are you sure you want to create this request?');
      widget.dm.setAlertButtons([
        ButtonView(
            paddingTop: 8,
            paddingBottom: 8,
            paddingLeft: 18,
            paddingRight: 18,
            radius: 100,
            backgroundColor: hexToColor("#3490F3"),
            child: const TextView(
              text: 'Create',
              color: Colors.white,
            ),
            onPress: () async {
              setState(() {
                widget.dm.setToggleAlert(false);
                widget.dm.setToggleLoading(true);
              });
              final success = await firebase_CreateDocument(
                '${appName}_Requests',
                randomString(25),
                {
                  'date': DateTime.now().millisecondsSinceEpoch,
                  'details': _detailsController.text.replaceAll('\n', 'jjj'),
                  'priority': _priority,
                  'requested': _assignedTo,
                  'requestor': _requestedBy,
                  'status': 'requested',
                  'title': _titleController.text
                },
              );
              if (success) {
                setState(() {
                  widget.dm.setToggleLoading(false);
                  nav_Pop(context);
                });
              }
            })
      ]);
    });
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
                              text: 'New Request',
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
                            const TextView(
                              text: 'title',
                              size: 16,
                              weight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            BorderView(
                              bottom: true,
                              bottomWidth: 2,
                              bottomColor: Colors.black,
                              child: TextfieldView(
                                controller: _titleController,
                                placeholder: 'ex. New pack of strings.',
                                backgroundColor: Colors.transparent,
                                paddingH: 0,
                                size: 24,
                                radius: 0,
                              ),
                            )
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

                        //  REQUESTOR
                        const SizedBox(
                          height: 15,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextView(
                              text: 'Requested By',
                              size: 16,
                              weight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            DropdownView(
                              backgroundColor: Colors.white,
                              items: const [
                                'Alfredo',
                                'Ana',
                                'John',
                                'Jesus',
                                'Shalom',
                                'Teacher'
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _requestedBy = value;
                                });
                              },
                            )
                          ],
                        ),

                        //  REQUESTED
                        const SizedBox(
                          height: 15,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextView(
                              text: 'Assigned To',
                              size: 16,
                              weight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            DropdownView(
                              backgroundColor: Colors.white,
                              items: const [
                                'Alfredo',
                                'Ana',
                                'John',
                                'Jesus',
                                'Shalom',
                                'Teacher'
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _assignedTo = value;
                                });
                              },
                            )
                          ],
                        ),

//  PRIORITY
                        const SizedBox(
                          height: 15,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextView(
                              text: 'Priority',
                              size: 16,
                              weight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            DropdownView(
                              backgroundColor: Colors.white,
                              items: const [
                                'high',
                                'medium',
                                'low',
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _priority = value;
                                });
                              },
                            )
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
