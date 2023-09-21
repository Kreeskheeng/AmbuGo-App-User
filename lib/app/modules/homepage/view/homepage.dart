// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:last_minute/app/modules/ambulance_details/controller/ambulance_controller.dart';
import 'package:last_minute/app/modules/ambulance_details/view/additional_details.dart';
import 'package:last_minute/app/modules/ambulance_details/view/ambulance_details.dart';
import 'package:last_minute/app/modules/homepage/controller/homepage_controller.dart';
import 'package:last_minute/app/modules/homepage/view/panel_widget.dart';
import 'package:last_minute/app/modules/login/view/login.dart';
import 'package:last_minute/app/modules/pay_stack/main.dart';
import 'package:last_minute/app/modules/qr/QR%20Generator/QRGenerator.dart';
import 'package:last_minute/app/modules/wallet/main.dart';
import 'package:last_minute/utils/colors.dart';
import 'package:last_minute/utils/dimensions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:last_minute/helper/snackbar.dart'; // Import your snackbar function
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:glassmorphism/glassmorphism.dart';
import 'package:last_minute/app/modules/pay_stack/Payment/paystack_payment_page.dart';
import 'package:shimmer/shimmer.dart';




// Define the TransparentAppBar class
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
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Image.asset(
            'assets/images/ambugo.jpg', // Update with your logo image path
            width: 40,
            height: 40,
          ),
          SizedBox(width: 2.0), // Add some spacing between logo and text
          Text(
            title,
            style: const TextStyle(
              color: AppColors.pink,
              fontFamily: 'RedHat',
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.indigo),
          onPressed: onNotificationPressed,
        ),
        IconButton(
          icon: Icon(Icons.logout, color: Colors.indigo),
          onPressed:onNotificationPressed,
        ),
      ],
    );

  }
}



class Homepage extends GetView<HomepageController> {
  AmbulanceDetailsController ambulanceController = Get.find();
  Completer<GoogleMapController> mapController = Completer();
  var currentMapType = Rx<MapType>(MapType.normal);


  void toggleMapType() {
    currentMapType.value = (currentMapType.value == MapType.normal)
        ? MapType.satellite
        : MapType.normal;
  }

  static const route = '/homepage';
  bool booked = false;


  Homepage({super.key, this.booked = false});

  static launch() => Get.toNamed(route);


  final panelController = PanelController();

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }




  @override
  Widget build(BuildContext context) {
    controller.ambulanceBookedBool(booked);
    return MaterialApp(
      home: Scaffold(
        appBar: TransparentAppBar(
          title: " AmbuLance Go.",
          onNotificationPressed: () {
            // TODO: Handle notification button press
            // Implement your notification logic here
          },
          onLogoutPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LogIn() ),
            );

          },
        ),
        body: SafeArea(

          child: Obx(
                () => controller.ambulanceBooked
                ? GetBuilder<AmbulanceDetailsController>(
              builder: (ambulanceController) {
                return SlidingUpPanel(
                  maxHeight: ambulanceController.additionalData
                      ? Dimensions.height40 * 17
                      : Dimensions.height40 * 12,
                  controller: panelController,
                  borderRadius:
                  BorderRadius.circular(Dimensions.radius30),
                  panelBuilder: (controller) =>
                  ambulanceController.additionalData
                      ? AdditionalData(
                    scrollController: controller,
                  )
                      : AmbulanceDetails(
                    scrollController: controller,
                  ),
                  body: Stack(
                    alignment: Alignment.center,
                    children: [
                      renderMap(),
                    ],
                  ),
                );
              },
            )
                : SlidingUpPanel(
              maxHeight: Dimensions.height40 * 6,
              minHeight: Dimensions.height40 * 6,
              isDraggable: false,
              controller: panelController,
              borderRadius:
              BorderRadius.circular(Dimensions.radius30),
              panelBuilder: (controller) => PanelWidget(),
              body: renderMap(),
            ),
          ),
        ),
      ),
    );
  }



  Widget renderMap() {
    return Obx(
          () => (controller.isLoading.value)
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.pink),
      )
          : Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  controller.currentLocation!.latitude!,
                  controller.currentLocation!.longitude!,
                ),
                zoom: 13.5,
              ),
              onCameraMove: (positioned) {
                controller.latLng.add(positioned.target);
              },
              markers: {
                if (controller.ambulanceBooked)
                  Marker(
                    onTap: () {
                      snackbar('Ambulance Location');
                    },
                    markerId: const MarkerId('driverLocation'),
                    position: controller.destinationLocation,
                    // Use the preloaded BitmapDescriptor
                  ),
                Marker(
                  onTap: () {
                    snackbar('Your Location');
                  },
                  markerId: const MarkerId('patientLocation'),
                  position: LatLng(
                    controller.currentLocation!.latitude!,
                    controller.currentLocation!.longitude!,
                  ),
                ),
              },
              polylines: {
                if (controller.ambulanceBooked)
                  Polyline(
                    polylineId: const PolylineId('route'),
                    points: controller.polylineCoordinates,
                    color: AppColors.pink,
                    width: 6,
                  ),
              },
            ),
          ),

          Positioned(
            top: 50,
            right: 16,
            child: GlassmorphicContainer(
              width: 120,
              height: 65,
              borderRadius: 35,
              blur: 15,
              alignment: Alignment.center,
              border: 0,
              linearGradient: LinearGradient(
                colors: [
                  Colors.indigo,
                  Colors.indigo,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderGradient: LinearGradient(
                colors: [
                  Colors.black54, // Use the same color as the linear gradient's end color
                  Colors.black54, // Use the same color as the linear gradient's start color
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Builder(
                builder: (context) => ElevatedButton(

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  QRGenerator() ),// Replace YourNextScreen with the appropriate widget
                    );
                    controller.toggleMapType();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    padding: EdgeInsets.zero,
                    primary: Colors.black38, // Make the button background transparent
                    elevation: 100, // No shadow
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [


                        Icon(Icons.monetization_on,),
                        SizedBox(width: 5.0, height: 65.0,),

                        Text(

                          "PAY RIDE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,

                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }


}
