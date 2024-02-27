// ignore_for_file: file_names

import 'package:ambu_go_user/app/modules/login/controller/login_controller.dart';
import 'package:get/get.dart';

class LogInBinding implements Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => LogInController()
);
  }
}