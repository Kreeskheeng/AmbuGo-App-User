import 'package:get/get.dart';

import '../../ambulance_details/controller/ambulance_controller.dart';
import '../controller/homepage_controller.dart';

class landingpageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => landingpageBinding());
    Get.lazyPut(() => HomepageController());
    Get.lazyPut(() => AmbulanceDetailsController());
  }
}
