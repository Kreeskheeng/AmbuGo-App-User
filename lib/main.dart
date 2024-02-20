import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:last_minute/app/modules/before_login/view/before_login.dart';
import 'package:last_minute/app/modules/homepage/controller/homepage_controller.dart';
import 'package:last_minute/app/modules/homepage/view/home.dart';
import 'package:last_minute/app/modules/homepage/view/homepage.dart';
import 'package:last_minute/app/modules/login/view/login.dart';
import 'package:last_minute/firebase_options.dart';
import 'package:last_minute/helper/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:last_minute/app/modules/ambulance_details/controller/ambulance_controller.dart';
import 'package:last_minute/app/modules/homepage/view/homepage.dart'; // Update the import path with the correct path to your Homepage widget


import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase or any other initialization required
  // Initialize the AmbulanceDetailsController
  Get.put(AmbulanceDetailsController());
  Get.put(HomepageController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}
//style: TextStyle(color: Colors.grey.shade500),),
//AmbulanceGoApp()