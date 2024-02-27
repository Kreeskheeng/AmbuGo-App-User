// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:ambu_go_user/app/modules/create_profile/controller/create_profile_controller.dart';

class CreateProfileBinding implements Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => CreateProfileController()
);
  }
}