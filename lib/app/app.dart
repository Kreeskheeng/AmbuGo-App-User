import 'package:ambu_go_user/app/modules/login/controller/login_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



import '../helper/shared_preference.dart';
import '../routes/routes.dart';
import '../utils/theme.dart';
import '../utils/themepro.dart';
import 'modules/ambulance_details/controller/ambulance_controller.dart';
import 'modules/homepage/controller/homepage_controller.dart';
import 'modules/homepage/view/homepage.dart';
import 'modules/login/view/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.apptheme.copyWith(),
      getPages: AppRoutes.pages,
      home: FutureBuilder(
        future: FirebaseFirestore.instance.collection('bookings').get(),
        builder: (context, snapshot) {
          bool booked=false;
          if(snapshot.hasData){
            final bookings=snapshot.data!.docs;
            for(var booking in bookings){
              if(booking['userId']==SPController().getUserId() && booking['ambulanceStatus']!='completed'){
                        booked=true;
                      }
            }
          }
        if((SPController().getIsLoggedin()) && booked==true){
          Get.lazyPut(()=>HomepageController());
          Get.lazyPut(()=>AmbulanceDetailsController());
          return 
            Homepage(booked: true,);
        }
        else if((SPController().getIsLoggedin())){
          Get.lazyPut(()=>HomepageController());
          Get.lazyPut(()=>AmbulanceDetailsController());
          return Homepage();
        }
        else{
          Get.lazyPut(()=>LogInController());
          return const LogIn();
        }
      }),

      
          // (SPController().getIsLoggedin()) ? Homepage.route : LogIn.route,
    );
  }
}
