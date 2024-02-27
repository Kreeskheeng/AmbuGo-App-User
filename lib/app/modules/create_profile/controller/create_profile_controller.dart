import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ambu_go_user/app/modules/homepage/view/home.dart';
import 'package:ambu_go_user/app/modules/homepage/view/homepage.dart';
import 'package:ambu_go_user/helper/loading.dart';
import 'package:ambu_go_user/helper/shared_preference.dart';
import 'package:ambu_go_user/helper/snackbar.dart';

class CreateProfileController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  final users = FirebaseFirestore.instance.collection('users');
  final prefs = SPController();
  onCreateProfile() async {
    LoadingUtils.showLoader();
    try {
      await users.doc(prefs.getUserId()).set({
        'user Id':SPController().getUserId(),
        "name": name.text,
        "address": address.text,
        "phone":phoneNumber.text,
        "city":city.text,
      }).then((value) {
        LoadingUtils.hideLoader();
        AmbulanceGoApp.launch();
      });
    } catch (e) {
      LoadingUtils.hideLoader();
      snackbar(e.toString());
    }
  }
}
