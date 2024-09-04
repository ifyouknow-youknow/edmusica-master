import 'package:edm_master/COMPONENTS/button_view.dart';
import 'package:edm_master/COMPONENTS/padding_view.dart';
import 'package:edm_master/COMPONENTS/text_view.dart';
import 'package:edm_master/FUNCTIONS/colors.dart';
import 'package:edm_master/FUNCTIONS/nav.dart';
import 'package:edm_master/VIEWS/calendar.dart';
import 'package:edm_master/VIEWS/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:edm_master/COMPONENTS/image_view.dart';
import 'package:edm_master/COMPONENTS/main_view.dart';
import 'package:edm_master/MODELS/DATAMASTER/datamaster.dart';

class Navigation extends StatefulWidget {
  final DataMaster dm;
  const Navigation({super.key, required this.dm});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    return MainView(
        backgroundColor: const Color.fromARGB(255, 212, 219, 240),
        dm: widget.dm,
        children: [
          // TOP
          PaddingView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ImageView(
                  imagePath: 'assets/edm-logo.png',
                  width: 240,
                  height: 100,
                  objectFit: BoxFit.contain,
                ),
                ButtonView(
                    child: const Row(
                      children: [
                        TextView(
                          text: 'close',
                          size: 18,
                          weight: FontWeight.w500,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.close,
                          size: 26,
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    onPress: () {
                      nav_Pop(context);
                    })
              ],
            ),
          ),
          // ITEMS
          Expanded(
            child: PaddingView(
              paddingTop: 0,
              paddingBottom: 0,
              child: GridView.count(
                  crossAxisCount: 5, // Set the number of items across to 5
                  mainAxisSpacing: 10.0, // Add vertical spacing between items
                  crossAxisSpacing:
                      10.0, // Add horizontal spacing between items
                  children: [
                    // DASHBOARD
                    ButtonView(
                      paddingBottom: 15,
                      paddingTop: 15,
                      paddingLeft: 15,
                      paddingRight: 15,
                      radius: 10,
                      backgroundColor: hexToColor("#253677"),
                      onPress: () {
                        nav_PushAndRemove(context, Dashboard(dm: widget.dm));
                      },
                      child: const Column(
                        children: [
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextView(
                                text: 'DASHBOARD',
                                size: 24,
                                weight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              Icon(
                                Icons.dashboard,
                                size: 36,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    // CALENDAR
                    ButtonView(
                      paddingBottom: 15,
                      paddingTop: 15,
                      paddingLeft: 15,
                      paddingRight: 15,
                      radius: 10,
                      backgroundColor: Colors.white,
                      onPress: () {
                        nav_PushAndRemove(context, Calendar(dm: widget.dm));
                      },
                      child: const Column(
                        children: [
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextView(
                                text: 'CALENDAR',
                                size: 24,
                                weight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              Icon(
                                Icons.calendar_month,
                                size: 36,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          )
        ]);
  }
}
