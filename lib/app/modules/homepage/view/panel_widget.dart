// ignore_for_file: must_be_immutable

import 'package:ambu_go_user/app/modules/homepage/controller/homepage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:ui';

import '../../../../helper/shimmer.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimensions.dart';
import '../../../../widgets/big_text.dart';
import '../../../../widgets/button.dart';
import '../../ambulance_details/controller/ambulance_controller.dart';

class PanelWidget extends GetView<HomepageController> {
  AmbulanceDetailsController ambulanceController=Get.find();
   PanelWidget({
    super.key,
  });




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(Dimensions.width15, Dimensions.height10,
          Dimensions.width15, Dimensions.height30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Dimensions.height18,
            ),
            Obx(
                  () => controller.selectedAddress?.value == 'Loading'
                  ? const Column(
                children: [
                  CustomShimmer.rectangular(height: 22),
                  SizedBox(
                    height: 8,
                  ),
                  CustomShimmer.rectangular(height: 22)
                ],
              )
                  : BigText(
                text: controller.selectedAddress!.value,
                maxLines: 3,
              ),
            ),
            SizedBox(
              height: Dimensions.height30,
            ),
            Button(
              on_pressed: () {
                controller.onAmbulanceBooked(true);
                //ambulanceController.onInformationUpdated(false);

              },
              text: 'BOOK AMBULANCE',
              radius: Dimensions.radius20 * 2,
              width: double.maxFinite,
              color: AppColors.pink,
            ),

          ],
        ),
      ),
    );
  }

}


/*
Container(
width: double.maxFinite,
height: Dimensions.radius20 * 4,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(Dimensions.radius20 * 2),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.1),
blurRadius: 16,
spreadRadius: 0,
offset: Offset(0, 4),
),
],
),
child: ClipRRect(
borderRadius: BorderRadius.circular(Dimensions.radius20 * 2),
child: BackdropFilter(
filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
child: ElevatedButton(
onPressed: () {
controller.onAmbulanceBooked(true);
ambulanceController.onInformationUpdated(false);
},
style: ElevatedButton.styleFrom(
primary: Colors.pink.withOpacity(0.2),
onPrimary: Colors.pinkAccent,
padding: EdgeInsets.all(16),
),
child: const Text(
'BOOK AMBULANCE',
style: TextStyle(fontSize: 16),
),
),
),
),
)

 */