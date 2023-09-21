// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:last_minute/app/modules/ambulance_details/controller/ambulance_controller.dart';
import 'package:last_minute/app/modules/homepage/controller/homepage_controller.dart';

import '../../../../helper/shared_preference.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimensions.dart';
import '../../../../widgets/big_text.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/drop_down.dart';
import '../../../../widgets/text_field.dart';
import 'package:url_launcher/url_launcher.dart';


class AdditionalData extends GetView<AmbulanceDetailsController> {
  HomepageController homepageController=Get.find();
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
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('bookings')
                          .snapshots(),
                      builder: ((context, snapshot) {
                        List bookingAmbulance=[];
                        bool completed = false;
                        if (snapshot.hasData) {
                        final bookings = snapshot.data!.docs;
                        for (var booking in bookings) {
                          if (booking['ambulanceStatus'] == 'assigned' &&
                              booking['userId'] == SPController().getUserId()) {
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
                        if (snapshot.hasData) {
                          final bookings = snapshot.data!.docs;
                          for (var booking in bookings) {
                            if (booking['ambulanceStatus'] == 'assigned' &&
                                booking['userId'] ==
                                    SPController().getUserId()) {
                                      bookingAmbulance.add(booking);
                              //assigned = true;
                            }
                            if(booking['ambulanceStatus'] == 'completed' &&
                                booking['userId'] ==
                                    SPController().getUserId()){
                                      completed=true;
                                    }

                          }
                        }
                        if(completed==true){
                          homepageController.ambulanceAssignedBool(false);
                           controller.onInformationUpdated(false);
                          homepageController.ambulanceBookedBool(false);
                        }
                        return 
                        homepageController.driverDoc!=null && bookingAmbulance.isNotEmpty
                            ? Column(
                                children: [
                                  Container(
                                    width: Dimensions.width20 * 4,
                                    height: Dimensions.height10 / 3,
                                    decoration: BoxDecoration(
                                        color: AppColors.lightGrey,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  SizedBox(
                                    height: Dimensions.height15,
                                  ),
                                  Container(
                                    width: double.maxFinite,
                                    height: Dimensions.height40 * 1.5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radius20),
                                        color: AppColors.deepGreen),
                                    child: Center(
                                        child: BigText(
                                      text: 'AMBULANCE IS ON THE WAY',
                                      color: AppColors.white,
                                    )),
                                  ),
                                   SizedBox(
                                     height: Dimensions.height20 * 1.5,
                                   ),
                                   Button(
                         on_pressed: () {},
                         text: 'Estimated Arrival: ${bookingAmbulance[0]['ambulanceLocation']['time']}',
                         color: AppColors.black,
                         textColor: AppColors.white,
                         width: Dimensions.width40 * 6,
                         height: Dimensions.height40 * 1.1,
                         textSize: Dimensions.font20 * 0.8,
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
                                                'https://amandeephospital.org/wp-content/uploads/2022/02/ambulance-ad.jpg'),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: Dimensions.radius30,
                                            backgroundImage: const NetworkImage(
                                                'https://amandeephospital.org/wp-content/uploads/2022/02/ambulance-ad.jpg'),
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
                                                                .emtDoc ==
                                                            null
                                                        ? 'Not Assigned Yet'
                                                        : homepageController
                                                            .emtDoc['name'],
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
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                      height: Dimensions.height40 * 5,
                                      child: Image.network(
                                          'https://media.istockphoto.com/id/1487081775/photo/emergency-services-team-checking-ambulance-interior.webp?b=1&s=170667a&w=0&k=20&c=7u7GXdZ2mnz1l5yY8X4vUBMH_UjcNGDAk1gnwu97TvY=')),
                                  BigText(
                                    text:
                                        "Don't Panic! We are trying best to search the Ambulance.",
                                    color: AppColors.black,
                                    maxLines: null,
                                  )
                                ],
                              );
                      })),


                  Text_Field(
                      radius: Dimensions.radius20,
                      text_field_width: double.maxFinite,
                      text_field_height: Dimensions.height20 * 3,
                      text_field: TextField(
                        controller: controller.preferredHospital,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.menu_open,
                            color: AppColors.pink,
                          ),
                          hintText: 'Preferred Hospital',
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
                        controller: controller.oxygen,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.menu_open,
                            color: AppColors.pink,
                          ),
                          hintText: 'Do You need Oxygen,Y/N!',
                        ),
                      )),

                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  DropDown(
                    width: null,
                    height: Dimensions.height20 * 3,
                    name: 'Plans',
                    value: controller.value,
                    items: controller.dropDownList.map((String items) {
                      return DropdownMenuItem(
                        alignment: Alignment.center,
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      controller.onChangedHospitalType(newValue.toString());
                    },
                  ),

                  SizedBox(
                    height: Dimensions.height10,
                  ),
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
                  )
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
              )),
          BigText(
            text:
                'Keep updating the situations as it will help us to get you to the right hospital ASAP.',
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
