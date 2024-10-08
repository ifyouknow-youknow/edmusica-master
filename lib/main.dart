import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:edm_master/MODELS/DATAMASTER/datamaster.dart';
import 'package:edm_master/MODELS/firebase.dart';
import 'package:edm_master/VIEWS/dashboard.dart';
import 'package:edm_master/VIEWS/playground.dart';
import 'package:edm_master/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "lib/.env");

  runApp(
    MaterialApp(
      home: Dashboard(dm: DataMaster()),
    ),
    // initialRoute: "/",
    // routes: {
    //   // "/": (context) => const PlaygroundView(),
    // },
  );
}
