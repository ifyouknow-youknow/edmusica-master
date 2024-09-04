import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:edm_master/COMPONENTS/accordion_view.dart';
import 'package:edm_master/COMPONENTS/blur_view.dart';
import 'package:edm_master/COMPONENTS/button_view.dart';
import 'package:edm_master/COMPONENTS/calendar_view.dart';
import 'package:edm_master/COMPONENTS/checkbox_view.dart';
import 'package:edm_master/COMPONENTS/dropdown_view.dart';
import 'package:edm_master/COMPONENTS/fade_view.dart';
import 'package:edm_master/COMPONENTS/loading_view.dart';
import 'package:edm_master/COMPONENTS/main_view.dart';
import 'package:edm_master/COMPONENTS/map_view.dart';
import 'package:edm_master/COMPONENTS/padding_view.dart';
import 'package:edm_master/COMPONENTS/pager_view.dart';
import 'package:edm_master/COMPONENTS/qrcode_view.dart';
import 'package:edm_master/COMPONENTS/roundedcorners_view.dart';
import 'package:edm_master/COMPONENTS/scrollable_view.dart';
import 'package:edm_master/COMPONENTS/segmented_view.dart';
import 'package:edm_master/COMPONENTS/separated_view.dart';
import 'package:edm_master/COMPONENTS/split_view.dart';
import 'package:edm_master/COMPONENTS/switch_view.dart';
import 'package:edm_master/COMPONENTS/text_view.dart';
import 'package:edm_master/FUNCTIONS/colors.dart';
import 'package:edm_master/FUNCTIONS/date.dart';
import 'package:edm_master/FUNCTIONS/media.dart';
import 'package:edm_master/FUNCTIONS/misc.dart';
import 'package:edm_master/FUNCTIONS/recorder.dart';
import 'package:edm_master/FUNCTIONS/server.dart';
import 'package:edm_master/MODELS/coco.dart';
import 'package:edm_master/MODELS/constants.dart';
import 'package:edm_master/MODELS/DATAMASTER/datamaster.dart';
import 'package:edm_master/MODELS/firebase.dart';
import 'package:edm_master/MODELS/screen.dart';
import 'package:record/record.dart';

class PlaygroundView extends StatefulWidget {
  final DataMaster dm;
  const PlaygroundView({super.key, required this.dm});

  @override
  State<PlaygroundView> createState() => _PlaygroundViewState();
}

class _PlaygroundViewState extends State<PlaygroundView> {
  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
      const PaddingView(
        child: Center(
          child: TextView(
            text: "Hello! This is the IIC Flutter App Template",
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      ButtonView(
          child: const TextView(
            text: 'Press Me',
          ),
          onPress: () {
            function_ScanQRCode(context);
          }),
      const SizedBox(
        height: 10,
      ),
    ]);
  }
}
