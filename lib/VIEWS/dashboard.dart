import 'package:edm_master/FUNCTIONS/nav.dart';
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
  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
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
      )

      // MAIN
    ]);
  }
}
