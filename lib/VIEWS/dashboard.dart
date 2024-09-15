import 'package:edm_master/COMPONENTS/border_view.dart';
import 'package:edm_master/COMPONENTS/future_view.dart';
import 'package:edm_master/COMPONENTS/roundedcorners_view.dart';
import 'package:edm_master/FUNCTIONS/colors.dart';
import 'package:edm_master/FUNCTIONS/date.dart';
import 'package:edm_master/FUNCTIONS/nav.dart';
import 'package:edm_master/MODELS/constants.dart';
import 'package:edm_master/MODELS/firebase.dart';
import 'package:edm_master/MODELS/screen.dart';
import 'package:edm_master/VIEWS/navigation.dart';
import 'package:flutter/material.dart';
import 'package:edm_master/COMPONENTS/button_view.dart';
import 'package:edm_master/COMPONENTS/main_view.dart';
import 'package:edm_master/COMPONENTS/padding_view.dart';
import 'package:edm_master/COMPONENTS/text_view.dart';
import 'package:edm_master/MODELS/DATAMASTER/datamaster.dart';

class Dashboard extends StatefulWidget {
  final DataMaster dm;
  const Dashboard({super.key, required this.dm});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<List<dynamic>> _fetchEvents() async {
    // TEACHERS
    final docs = await firebase_GetAllDocumentsOrderedLimited(
        '${appName}_Events', 'date', 'desc', 3);
    return docs;
  }

  Future<List<dynamic>> _fetchRequests() async {
    final docs = await firebase_GetAllDocumentsOrderedLimited(
        '${appName}_Requests', 'date', 'desc', 3);
    return docs;
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
        backgroundColor: hexToColor("#F6F8FA"),
        dm: widget.dm,
        children: [
          // TOP
          PaddingView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextView(
                  text: 'DASHBOARD',
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
          PaddingView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // UPCOMING EVENTS
                Expanded(
                  child: SizedBox(
                    height: 350,
                    child: RoundedCornersView(
                      backgroundColor: Colors.white,
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const BorderView(
                                bottom: true,
                                bottomColor: Colors.black12,
                                child: PaddingView(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: const TextView(
                                      text: 'Upcoming Events',
                                      size: 22,
                                      weight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              FutureView(
                                  future: _fetchEvents(),
                                  childBuilder: (data) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (var eve in data)
                                          SingleChildScrollView(
                                            child: PaddingView(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            TextView(
                                                              text: getMonthName(
                                                                      DateTime.fromMillisecondsSinceEpoch(eve[
                                                                              'date'])
                                                                          .month)
                                                                  .substring(
                                                                      0, 3),
                                                              size: 16,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            TextView(
                                                              text: DateTime
                                                                      .fromMillisecondsSinceEpoch(
                                                                          eve['date'])
                                                                  .day
                                                                  .toString(),
                                                              size: 16,
                                                            )
                                                          ],
                                                        ),
                                                        TextView(
                                                          text: formatTime(
                                                            DateTime
                                                                .fromMillisecondsSinceEpoch(
                                                              eve['date'],
                                                            ),
                                                          ),
                                                          size: 24,
                                                          spacing: -1,
                                                          weight:
                                                              FontWeight.w800,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextView(
                                                          text: eve['title'],
                                                          size: 20,
                                                          color: hexToColor(
                                                              "#3490F3"),
                                                          weight:
                                                              FontWeight.w600,
                                                        ),
                                                        TextView(
                                                          text: eve['details']
                                                                      .length >
                                                                  80
                                                              ? eve['details']
                                                                  .substring(
                                                                      0, 80)
                                                              : eve['details'],
                                                          size: 18,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      ],
                                    );
                                  },
                                  emptyWidget: const Center(
                                    child: TextView(
                                      text: 'No upcoming events.',
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //
                const SizedBox(
                  width: 15,
                ),
                // REQUESTS
                Expanded(
                  child: RoundedCornersView(
                    backgroundColor: Colors.white,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: double.infinity,
                            child: BorderView(
                              bottom: true,
                              bottomColor: Colors.black12,
                              child: PaddingView(
                                child: TextView(
                                  text: 'Requests',
                                  size: 22,
                                  weight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          FutureView(
                              future: _fetchRequests(),
                              childBuilder: (data) {
                                return SingleChildScrollView(
                                  child: PaddingView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (var req in data)
                                          SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextView(
                                                  text: req['title'],
                                                  size: 20,
                                                  weight: FontWeight.w600,
                                                ),
                                                TextView(
                                                  text:
                                                      'requested by: ${req['requested']}',
                                                ),
                                                TextView(
                                                  text:
                                                      'assigned to: ${req['requestor']}',
                                                  color: hexToColor("#3490F3"),
                                                  weight: FontWeight.w500,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              emptyWidget: const Center(
                                child: TextView(
                                  text: 'No requests yet.',
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]);
  }
}
