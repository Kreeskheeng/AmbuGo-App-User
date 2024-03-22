// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ambu_go_user/app/modules/ambulance_details/controller/ambulance_controller.dart';
import 'package:ambu_go_user/app/modules/homepage/controller/homepage_controller.dart';
import 'package:ambu_go_user/app/modules/pay_stack/main.dart';
import 'package:ambu_go_user/helper/shared_preference.dart';
import 'package:ambu_go_user/utils/colors.dart';
import 'package:ambu_go_user/utils/dimensions.dart';
import 'package:ambu_go_user/widgets/big_text.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../widgets/button.dart';




class AmbulanceDetails extends GetView<AmbulanceDetailsController> {
  HomepageController homepageController = Get.find();
  ScrollController scrollController;
  AmbulanceDetails({super.key, required this.scrollController});

  void _launchPhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle error: unable to launch the phone call.
      print('Error launching phone call');
    }
  }

  void retrieveRideInfo() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> rideInfoDoc =
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(SPController().getUserId())
          .get();

      String rideKey = rideInfoDoc.id; // Document ID is the rideKey
      String time = rideInfoDoc['time'].toString(); // Change the field name as per your Firestore structure

      print('Retrieved ride key: $rideKey');
      print('Retrieved time: $time');

      // Call the appropriate function to handle rideKey and time
      //_handleRideInfo(rideKey, time);

    } catch (e) {
      print('Error retrieving ride info: $e');
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
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('bookings')
                        .snapshots(),
                    builder: (context, snapshot) {
                      bool completed=false;
                      List bookingAmbulance=[];
                      if (snapshot.hasData) {
                        final bookings = snapshot.data!.docs;
                        for (var booking in bookings) {
                          if (booking['ambulanceStatus'] == 'assigned' &&
                              booking['userId'] == SPController().getUserId()) {
                                print( booking['emtId']);
                            homepageController.onGetDocuments(
                                booking['ambulanceDetails']['driverId'],
                                booking['emtId']);
                                bookingAmbulance.add(booking);
                                homepageController.onGetPatientLocation(booking['ambulanceLocation']['lat'], booking['ambulanceLocation']['lng']);
                                
                          }
                          if(booking['ambulanceStatus'] == 'completed' &&
                              booking['userId'] == SPController().getUserId()){
                                completed=true;
                              }
                        }
                        
                      }
                      if(completed==true){
                        //bookingAmbulance.clear();  
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            homepageController.ambulanceAssignedBool(false);
                          homepageController.ambulanceBookedBool(false);
                          });
                          
                        }

                      return homepageController.driverDoc!=null && bookingAmbulance.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: Dimensions.width20 * 4,
                                  height: Dimensions.height10 / 3,
                                  decoration: BoxDecoration(
                                      color: AppColors.lightGrey,
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                SizedBox(
                                  height: Dimensions.height15,
                                ),
                                BigText(
                                  text: 'Ambulance Details',
                                  size: Dimensions.font20 * 1.3,
                                  fontWeight: FontWeight.w600,
                                ),
                                 SizedBox(
                                    height: Dimensions.height20 * 1.5,
                                  ),
                                  Button(
                        on_pressed: () {},
                        text: 'Estimated Arrival: ${bookingAmbulance[0]['ambulanceLocation']['t']}',
                        color: AppColors.black,
                        textColor: AppColors.white,
                        width: Dimensions.width40 * 6,
                        height: Dimensions.height40 * 1.1,
                        textSize: Dimensions.font20 * 0.8,
                      ),
                                SizedBox(
                                  height: Dimensions.height20 * 1.5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BigText(
                                      text: 'Ambulance Status  ',
                                      size: Dimensions.font15 * 1.2,
                                    ),
                                    BigText(
                                      text: 'On the Way',
                                      size: Dimensions.font15 * 1.2,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: Dimensions.height15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BigText(
                                      text: 'Date Of Ride  ',
                                      size: Dimensions.font15 * 1.2,
                                    ),
                                    BigText(
                                      text: controller.dateOfRide.value, // Update this line
                                      size: Dimensions.font15 * 1.2,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: Dimensions.height15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BigText(
                                      text: 'Ride key  ',
                                      size: Dimensions.font15 * 1.2,
                                    ),
                                    BigText(
                                      text: controller.rideId.value, // Update this line
                                      size: Dimensions.font15 * 1.2,
                                    )
                                  ],
                                ),

                                const Divider(
                                  thickness: 1,
                                  color: AppColors.lightGrey,
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: Dimensions.radius30,
                                          backgroundImage: const NetworkImage(
                                              'https://i.pinimg.com/originals/50/d4/29/50d429ea5c9afe0ef9cb3c96f784bea4.jpg'),
                                        ),
                                        SizedBox(
                                          width: Dimensions.width10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            BigText(
                                                text: homepageController
                                                    .driverDoc['name'],
                                                size: Dimensions.font15),
                                            BigText(
                                              text: 'Ambulance Driver',
                                              size: Dimensions.font15,
                                              color: AppColors.pink,
                                            ),
                                            BigText(
                                              text: homepageController
                                                  .driverDoc['mobileNumber'],
                                              size: Dimensions.font15,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.phone,
                                          color: AppColors.pink,
                                        ))
                                  ],
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: AppColors.lightGrey,
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: Dimensions.radius30,
                                          backgroundImage: const NetworkImage(
                                              'https://i.pinimg.com/originals/50/d4/29/50d429ea5c9afe0ef9cb3c96f784bea4.jpg'),
                                        ),
                                        SizedBox(
                                          width: Dimensions.width10,
                                        ),
                                        GetBuilder<HomepageController>(
                                          
                                          builder: (_) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                BigText(
                                                    text: homepageController
                                                                .emtDoc ==
                                                            null
                                                        ? 'Not Assigned Yet'
                                                        : homepageController
                                                                .emtDoc[
                                                            'name'],
                                                    size: Dimensions.font15),
                                                BigText(
                                                  text: 'Nurse',
                                                  size: Dimensions.font15,
                                                  color: AppColors.pink,
                                                ),
                                                BigText(
                                                    text: homepageController
                                                                .emtDoc ==
                                                            null
                                                        ? 'Not Assigned Yet'
                                                        : homepageController
                                                                .emtDoc[
                                                            'mobileNumber'],
                                                    size: Dimensions.font15),
                                              ],
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _launchPhoneCall(homepageController.driverDoc['mobileNumber']);
                                      },
                                      icon: const Icon(
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
                              ],
                            )
                          : Column(
                        children: [
                          SizedBox(
                            height: Dimensions.height40 * 5,
                            child: Lottie.network(
                              'https://lottie.host/7b9bf500-b3ba-4b28-8457-0f19ac94770d/BbwhUC7E4q.json', // URL to your Lottie animation
                              fit: BoxFit.contain, // Adjust the fit as needed
                            ),
                          ),
                          BigText(
                            text: "Searching For Nearest Ambulance.",
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            maxLines:4,
                            size: 20,
                          )
                        ],
                      );
                    })),
          ),
          controller.informationUpdated
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Button(
                    on_pressed: () {
                      controller.onPageChanged(true);
                    },
                    text: 'Edit Addtional Details?',
                    width: Dimensions.width40 * 5,
                    height: null,
                    color: Colors.transparent,
                    textSize: Dimensions.font15 / 1.1,
                    textColor: AppColors.pink,
                  ))
              : Container(),
          BigText(
            text:
                'Keep updating the situations as it will help us to get you to the right hospital ASAP.',
            maxLines: null,
            size: Dimensions.font15 / 1.1,
            fontFamily: 'RedHatBold',
          ),
          GetBuilder<AmbulanceDetailsController>(
            builder: (_) {
              return controller.informationUpdated
                  ? Button(
                      width: double.maxFinite,
                      height: Dimensions.height40 * 1.5,
                      radius: Dimensions.radius20 * 2,
                on_pressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  PayStack(initialEmail: 'ckamoga23@gmail.com', initialPrice: 500,) ),
                  );
                },
                      text: 'FIRST AID',
                      color: AppColors.pink,
                    )
                  : Button(
                      width: double.maxFinite,
                      height: Dimensions.height40 * 1.5,
                      radius: Dimensions.radius20 * 2,
                      on_pressed: () {
                        controller.onPageChanged(true);
                      },
                      text: 'ADD ADDITIONAL DATA',
                      color: AppColors.pink,
                    );
            },
          ),
        ],
      ),
    );
  }
}
