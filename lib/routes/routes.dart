import 'package:ambu_go_user/app/modules/create_profile/binding/create_profile_binding.dart';
import 'package:get/get.dart';



import '../app/modules/before_login/view/before_login.dart';
import '../app/modules/create_profile/view/create_profile.dart';
import '../app/modules/homepage/binding/landingpage_binding.dart';
import '../app/modules/homepage/view/home.dart';
import '../app/modules/login/binding/logIn_binding.dart';
import '../app/modules/login/view/login.dart';
import '../app/modules/qr/HomePage.dart';

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
