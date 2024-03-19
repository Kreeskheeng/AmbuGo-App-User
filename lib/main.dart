import 'package:ambu_go_user/firebase_options.dart';
import 'package:easy_settings/easy_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'app/app.dart';
import 'app/modules/Settingz/Setttings.dart';
import 'app/modules/ambulance_details/controller/ambulance_controller.dart';
import 'app/modules/homepage/controller/homepage_controller.dart';
import 'helper/shared_preference.dart'; // Update the import path with the correct path to your Homepage widget




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase or any other initialization required
  // Initialize the AmbulanceDetailsController
  Get.put(AmbulanceDetailsController());
  Get.put(HomepageController());
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSettings(settingsCategories);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
  runApp(MyApp());

}
//style: TextStyle(color: Colors.grey.shade500),),
//AmbulanceGoApp()