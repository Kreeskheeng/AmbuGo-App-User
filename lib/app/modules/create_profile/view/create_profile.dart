import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ambu_go_user/app/modules/create_profile/controller/create_profile_controller.dart';
import 'package:ambu_go_user/app/modules/login/view/login.dart';
import 'package:ambu_go_user/app/modules/login/view/login.dart';
import 'package:ambu_go_user/app/modules/login/view/login.dart';
import 'package:ambu_go_user/helper/snackbar.dart';
import 'package:ambu_go_user/utils/colors.dart';
import 'package:ambu_go_user/widgets/big_text.dart';

import '../../../../utils/dimensions.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/text_field.dart';
class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onNotificationPressed;
  final VoidCallback onLogoutPressed;

  TransparentAppBar({
    required this.title,
    required this.onNotificationPressed,
    required this.onLogoutPressed,


  });

  @override
  Size get preferredSize => Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Image.asset(
            'assets/images/ambugo.jpg', // Update with your logo image path
            width: 45,
            height: 45,
          ),
          SizedBox(width: 4.0), // Add some spacing between logo and text
          Text(
            title,
            style: const TextStyle(
              color: AppColors.pink,
              fontFamily: 'RedHat',
              fontWeight: FontWeight.bold,
              fontSize: 28.6,
            ),
          ),
        ],
      ),
      actions: [


      ],
    );

  }
}
class CreateProfile extends GetView<CreateProfileController> {
  static const route = '/createprofile';
  static launch() => Get.toNamed(route);
  const CreateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransparentAppBar(
        title: "AmbuLance Go",
        onNotificationPressed: () {
          // TODO: Handle notification button press
          // Implement your notification logic here
        },
        onLogoutPressed: () {

        },
      ),
      body: SizedBox(
        width: Dimensions.screenWidth,
        height: Dimensions.screenHeight,
        child: SafeArea(
          child: Padding(
              padding: EdgeInsets.fromLTRB(
                  Dimensions.width15,
                  Dimensions.height40 * 2,
                  Dimensions.width15,
                  Dimensions.height30),
              child: SingleChildScrollView(
                child: Column(

                  children: [
                    BigText(
                    text: 'Create Profile to continue!',
                    maxLines: null,
                    size: Dimensions.font20 * 1.7,
                    color: AppColors.grey,
                  ),
                    SizedBox(height: Dimensions.height40,),
                    Column(
                      children: [
                        Text_Field(
                            radius: Dimensions.radius20,
                            text_field_width: double.maxFinite,
                            text_field_height: Dimensions.height20 * 3,
                            text_field: TextField(
                              controller: controller.name,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.person_2_outlined,
                                  color: AppColors.indigo,
                                ),
                                hintText: 'Name',
                              ),
                            )),
                        SizedBox(
                          height: Dimensions.height20,
                        ),
                        Text_Field(
                            radius: Dimensions.radius20,
                            text_field_width: double.maxFinite,
                            text_field_height: Dimensions.height20 * 6,
                            text_field: Center(
                              child: SingleChildScrollView(
                                child: TextField(
                                  controller: controller.address,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.location_history,
                                      color: AppColors.indigo,
                                    ),
                                    hintText: 'Address',
                                  ),
                                ),
                              ),
                            )),

                        SizedBox(
                          height: Dimensions.height20,
                        ),
                        Text_Field(
                            radius: Dimensions.radius20,
                            text_field_width: double.maxFinite,
                            text_field_height: Dimensions.height20 * 3,
                            text_field: TextField(
                              controller: controller.city,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.location_city_sharp,
                                  color: AppColors.indigo,
                                ),
                                hintText: 'City',
                              ),
                            )),
                        SizedBox(
                          height: Dimensions.height20,
                        ),
                        Text_Field(
                            radius: Dimensions.radius20,
                            text_field_width: double.maxFinite,
                            text_field_height: Dimensions.height20 * 3,
                            text_field: TextField(
                              controller: controller.phoneNumber,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: AppColors.indigo,
                                ),
                                hintText: 'Phone Number',
                              ),
                            )),
                        SizedBox(
                          height: Dimensions.height20,
                        ),
                        Button(
                          width: double.maxFinite,
                          height: Dimensions.height40 * 1.5,
                          radius: Dimensions.radius20 * 2,
                          on_pressed: () {
                            if(controller.name.text.isEmpty){
                              snackbar('Kindly Enter your name');
                            }

                            else if(controller.city.text.isEmpty){
                              snackbar('Kindly enter your city');
                            }
                            else if(controller.phoneNumber.text.isEmpty){
                              snackbar('Kindly enter your phone number');
                            }
                            else{
                              controller.onCreateProfile();
                            }

                          },
                          text: 'Create Profile',
                          color: AppColors.pink,
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
