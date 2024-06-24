import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ambu_go_user/app/modules/ambulance_details/controller/ambulance_controller.dart';
import 'package:ambu_go_user/app/modules/homepage/controller/homepage_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../helper/shared_preference.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimensions.dart';
import '../../../../widgets/big_text.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/drop_down.dart';
import '../../../../widgets/text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class AdditionalData extends GetView<AmbulanceDetailsController> {
  HomepageController homepageController = Get.find();
  ScrollController scrollController;

  AdditionalData({super.key, required this.scrollController});

  void _launchPhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle error: unable to launch the phone call.
      print('Error launching phone call');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(Dimensions.width15, Dimensions.height10,
          Dimensions.width15, Dimensions.height30),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // StreamBuilder to listen for changes in Firestore
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Loading indicator while waiting for data
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      // Extract the relevant booking data
                      final bookings = snapshot.data!.docs;
                      List<Map<String, dynamic>> bookingAmbulance = [];
                      bool completed = false;

                      // Iterate through the bookings to find relevant data
                      for (var booking in bookings) {
                        if (booking['ambulanceStatus'] == 'assigned' &&
                            booking['userId'] == SPController().getUserId()) {
                          homepageController.onGetDocuments(
                              booking['ambulanceDetails']['driverId'],
                              booking['emtId']);
                          homepageController.onGetPatientLocation(
                              booking['ambulanceLocation']['lat'],
                              booking['ambulanceLocation']['lng']);
                          bookingAmbulance.add(booking.data() as Map<String, dynamic>);
                        }
                        if (booking['ambulanceStatus'] == 'completed' &&
                            booking['userId'] == SPController().getUserId()) {
                          completed = true;
                        }
                      }

                      // If booking is completed, update state
                      if (completed) {
                        homepageController.ambulanceAssignedBool(false);
                        controller.onInformationUpdated(false);
                        homepageController.ambulanceBookedBool(false);
                      }

                      // Check if data is available to display
                      if (bookingAmbulance.isNotEmpty && homepageController.driverDoc != null) {
                        return Column(
                          children: [
                            Container(
                              width: Dimensions.width20 * 4,
                              height: Dimensions.height10 / 3,
                              decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            SizedBox(height: Dimensions.height18),
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/ambugo.jpg',
                                height: 55,
                                width: 55,
                              ),
                            ),
                            SizedBox(height: Dimensions.height18),
                            SizedBox(height: Dimensions.height10),
                            Align(
                              alignment: Alignment.center,
                              child: BigText(
                                text: 'AMBULANCE DETAILS',
                                color: Colors.lightGreen[900],
                                size: Dimensions.font26 * 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: Dimensions.height20 * 1.5),
                            // Display estimated arrival time from Firestore
                            Button(
                              on_pressed: () {},
                              text: 'Estimated Arrival: ${bookingAmbulance[0]['ambulanceLocation']['time']}',
                              color: AppColors.white,
                              textColor: AppColors.black,
                              width: Dimensions.width40 * 6,
                              height: Dimensions.height40 * 1.1,
                              textSize: Dimensions.font20 * 0.8,
                            ),
                            SizedBox(height: Dimensions.height20 * 1.5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/driver.png',
                                        height: 60,
                                        width: 45,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.width10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        BigText(
                                          text: 'Ambulance Driver',
                                          color: AppColors.pink,
                                          size: Dimensions.font20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        BigText(
                                          text: homepageController.driverDoc['name'],
                                          size: Dimensions.font15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        BigText(
                                          text: homepageController.driverDoc['mobileNumber'],
                                          size: Dimensions.font15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    _launchPhoneCall(homepageController.driverDoc['mobileNumber']);
                                  },
                                  icon: Icon(
                                    Icons.phone,
                                    color: AppColors.pink,
                                  ),
                                )
                              ],
                            ),
                            const Divider(
                              thickness: 1,
                              color: AppColors.lightGrey,
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/nurse.png',
                                        height: 60,
                                        width: 45,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.width10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        BigText(
                                          text: 'Nurse',
                                          size: Dimensions.font20,
                                          color: AppColors.pink,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        BigText(
                                          text: homepageController.emtDoc == null
                                              ? 'Not Assigned Yet'
                                              : homepageController.emtDoc['name'],
                                          size: Dimensions.font15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        BigText(
                                          text: homepageController.emtDoc == null
                                              ? 'Not Assigned Yet'
                                              : homepageController.emtDoc['mobileNumber'],
                                          size: Dimensions.font15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.phone,
                                    color: AppColors.pink,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: Dimensions.width10),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            SizedBox(
                              height: Dimensions.height40 * 5,
                              child: Image.network(
                                  'https://png.pngtree.com/png-vector/20220712/ourmid/pngtree-ambulance-vector-design-png-image_5892369.png'),
                            ),
                            BigText(
                              text:
                              "Don't Panic! We are trying our best to find an ambulance.",
                              color: AppColors.black,
                              maxLines: null,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(height: Dimensions.height20),
                  Align(
                    alignment: Alignment.center,
                    child: BigText(
                      text: 'Additional Information',
                      color: Colors.lightGreen[900],
                      size: Dimensions.font26 * 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: AppColors.lightGrey,
                    height: 40,
                  ),
                  // Your additional widgets for hospital type, emergency type, etc.
                  Text_Field(
                    radius: Dimensions.radius20,
                    text_field_width: double.maxFinite,
                    text_field_height: Dimensions.height20 * 3,
                    text_field: TextField(
                      controller: controller.preferredHospital,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: AppColors.pink,
                        ),
                        hintText: 'Preferred Hospital',
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  DropDown(
                    width: null,
                    height: Dimensions.height20 * 3,
                    name: 'Plans',
                    value: controller.value,
                    items: controller.dropDownList
                        .map((String items) => DropdownMenuItem(
                      alignment: Alignment.center,
                      value: items,
                      child: Text(items),
                    ))
                        .toList(),
                    onChanged: (newValue) {
                      controller.onChangedHospitalType(newValue.toString());
                    },
                  ),
                  SizedBox(height: Dimensions.height10),
                  Button(
                    on_pressed: () {
                      controller.onOpenEmergency();
                    },
                    text: 'Emergency Type',
                    width: double.maxFinite,
                    height: Dimensions.height20 * 3,
                    color: Colors.transparent,
                    textColor: AppColors.grey,
                    boxBorder: Border.all(color: AppColors.pink, width: 2),
                    radius: Dimensions.radius20,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Button(
              on_pressed: () {
                controller.onPageChanged(false);
              },
              text: 'Back',
              width: Dimensions.width40,
              height: null,
              color: Colors.transparent,
              textSize: Dimensions.font15 / 1.1,
              textColor: AppColors.pink,
            ),
          ),
          BigText(
            text:
            'Keep updating the situation as it will help us get you to the right hospital ASAP.',
            maxLines: null,
            size: Dimensions.font15 / 1.1,
            fontFamily: 'RedHatBold',
          ),
          Button(
            width: double.maxFinite,
            height: Dimensions.height40 * 1.5,
            radius: Dimensions.radius20 * 2,
            on_pressed: () {
              controller.onInformationUpdated(true);
              controller.onPageChanged(false);
            },
            text: 'UPDATE SITUATION',
            color: AppColors.pink,
          ),
        ],
      ),
    );
  }
}
