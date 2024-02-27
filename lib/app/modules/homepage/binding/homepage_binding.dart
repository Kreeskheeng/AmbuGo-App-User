import 'package:get/get.dart';

import '../../ambulance_details/controller/ambulance_controller.dart';
import '../controller/homepage_controller.dart';

class HomepageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomepageController());
    Get.lazyPut(() => AmbulanceDetailsController());
  }
}
