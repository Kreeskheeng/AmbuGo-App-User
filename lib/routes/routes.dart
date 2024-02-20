import 'package:get/get.dart';

import 'package:last_minute/app/modules/create_profile/binding/create_profile_binding.dart';
import 'package:last_minute/app/modules/create_profile/view/create_profile.dart';

import 'package:last_minute/app/modules/before_login/view/before_login.dart';

import 'package:last_minute/app/modules/homepage/binding/homepage_binding.dart';
import 'package:last_minute/app/modules/homepage/view/homepage.dart';
import 'package:last_minute/app/modules/login/binding/logIn_binding.dart';
import 'package:last_minute/app/modules/login/view/login.dart';
import 'package:last_minute/app/modules/qr/HomePage.dart';

import '../app/modules/homepage/binding/landingpage_binding.dart';
import '../app/modules/homepage/view/home.dart';

class AppRoutes {
  static final pages = [
    GetPage(
      name: LogIn.route,
      page: () => const LogIn(),
      binding: LogInBinding(),
    ),

    GetPage(
      name: CreateProfile.route,
      page: () => const CreateProfile(),
      binding: CreateProfileBinding(),
    ),
    GetPage(
      name: AmbulanceGoApp.route,
      page: () => const AmbulanceGoApp(),
    ),

    GetPage(
      name: FirstPage.route,
      page: () => const FirstPage(),
    ),

    GetPage(
      name: QrPage.route,
      page: () => const QrPage(),
    ),
  ];
}
