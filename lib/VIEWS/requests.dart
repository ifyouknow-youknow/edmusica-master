import 'package:edm_master/COMPONENTS/button_view.dart';
import 'package:edm_master/COMPONENTS/future_view.dart';
import 'package:edm_master/COMPONENTS/main_view.dart';
import 'package:edm_master/COMPONENTS/padding_view.dart';
import 'package:edm_master/COMPONENTS/roundedcorners_view.dart';
import 'package:edm_master/COMPONENTS/text_view.dart';
import 'package:edm_master/FUNCTIONS/colors.dart';
import 'package:edm_master/FUNCTIONS/nav.dart';
import 'package:edm_master/MODELS/DATAMASTER/datamaster.dart';
import 'package:edm_master/MODELS/constants.dart';
import 'package:edm_master/MODELS/firebase.dart';
import 'package:edm_master/VIEWS/navigation.dart';
import 'package:edm_master/VIEWS/new_request.dart';
import 'package:flutter/material.dart';

class Requests extends StatefulWidget {
  final DataMaster dm;
  const Requests({super.key, required this.dm});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  Future<List<dynamic>> _fetchHighRequests() async {
    final docs = await firebase_GetAllDocumentsOrderedQueried(
        '${appName}_Requests',
        [
          {'field': 'priority', 'operator': '==', 'value': 'high'},
        ],
        'date',
        'asc');
    return docs;
  }

  Future<List<dynamic>> _fetchMedRequests() async {
    final docs = await firebase_GetAllDocumentsOrderedQueried(
        '${appName}_Requests',
        [
          {'field': 'priority', 'operator': '==', 'value': 'medium'},
        ],
        'date',
        'asc');
    return docs;
  }

  Future<List<dynamic>> _fetchLowRequests() async {
    final docs = await firebase_GetAllDocumentsOrderedQueried(
        '${appName}_Requests',
        [
          {'field': 'priority', 'operator': '==', 'value': 'low'},
        ],
        'date',
        'asc');
    return docs;
  }

  void onCompleteRequest() async {
    setState(() {
      widget.dm.setToggleAlert(true);
      widget.dm.setAlertTitle('Mark as complete');
      widget.dm.setAlertText('Are you sure this request has been completed.');
      widget.dm.setAlertButtons([
        ButtonView(
            backgroundColor: hexToColor("#3490F3"),
            paddingTop: 8,
            paddingBottom: 8,
            paddingLeft: 18,
            paddingRight: 18,
            radius: 100,
            child: const TextView(
              text: 'Complete',
              color: Colors.white,
              size: 14,
            ),
            onPress: () {
              setState(() {
                widget.dm.setToggleAlert(false);
              });
            })
      ]);
    });
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
              text: 'REQUESTS',
              size: 20,
              weight: FontWeight.w600,
            ),
            Row(
              children: [
                ButtonView(
                  child: const Icon(Icons.add, size: 36),
                  onPress: () {
                    nav_Push(context, NewRequest(dm: widget.dm), () {
                      setState(() {});
                    });
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                ButtonView(
                  child: const Icon(Icons.menu, size: 36),
                  onPress: () {
                    nav_Push(context, Navigation(dm: widget.dm));
                  },
                ),
              ],
            )
          ],
        ),
      ),
      //MAIN
      Expanded(
        child: SingleChildScrollView(
          child: PaddingView(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HIGH
              Expanded(
                child: PaddingView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextView(
                        text: 'HIGH',
                        size: 24,
                        weight: FontWeight.w800,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureView(
                          future: _fetchHighRequests(),
                          childBuilder: (data) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var req in data)
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: ButtonView(
                                            radius: 10,
                                            backgroundColor:
                                                hexToColor("#F6F8FA"),
                                            child: PaddingView(
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
                                                        'requested by: ${req['requestor']}',
                                                  ),
                                                  TextView(
                                                    text:
                                                        'assigned to: ${req['requested']}',
                                                    color:
                                                        hexToColor("#3490F3"),
                                                    weight: FontWeight.w500,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextView(
                                                    text: req['details']
                                                        .replaceAll(
                                                            "jjj", '\n'),
                                                  )
                                                ],
                                              ),
                                            ),
                                            onPress: () {}),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  )
                              ],
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
              // MED
              Expanded(
                child: PaddingView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextView(
                        text: 'MEDIUM',
                        size: 24,
                        weight: FontWeight.w800,
                        color: Colors.orange,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureView(
                          future: _fetchMedRequests(),
                          childBuilder: (data) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var req in data)
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: ButtonView(
                                            radius: 10,
                                            backgroundColor:
                                                hexToColor("#F6F8FA"),
                                            child: PaddingView(
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
                                                        'requested by: ${req['requestor']}',
                                                  ),
                                                  TextView(
                                                    text:
                                                        'assigned to: ${req['requested']}',
                                                    color:
                                                        hexToColor("#3490F3"),
                                                    weight: FontWeight.w500,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextView(
                                                    text: req['details']
                                                        .replaceAll(
                                                            "jjj", '\n'),
                                                  )
                                                ],
                                              ),
                                            ),
                                            onPress: () {}),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  )
                              ],
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
              // LOW
              Expanded(
                child: PaddingView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextView(
                        text: 'LOW',
                        size: 24,
                        weight: FontWeight.w800,
                        color: Colors.green,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureView(
                          future: _fetchLowRequests(),
                          childBuilder: (data) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var req in data)
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: ButtonView(
                                            radius: 10,
                                            backgroundColor:
                                                hexToColor("#F6F8FA"),
                                            child: PaddingView(
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
                                                        'requested by: ${req['requestor']}',
                                                  ),
                                                  TextView(
                                                    text:
                                                        'assigned to: ${req['requested']}',
                                                    color:
                                                        hexToColor("#3490F3"),
                                                    weight: FontWeight.w500,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextView(
                                                    text: req['details']
                                                        .replaceAll(
                                                            "jjj", '\n'),
                                                  )
                                                ],
                                              ),
                                            ),
                                            onPress: () {}),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  )
                              ],
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
              )
            ],
          )),
        ),
      )
    ]);
  }
}
