import 'dart:async';
import 'dart:js';
import 'dart:typed_data';
import 'package:ambu_go_user/app/modules/homepage/controller/homepage_controller.dart';
import 'package:ambu_go_user/app/modules/homepage/view/panel_widget.dart';
import 'package:ambu_go_user/app/modules/pay_stack/Payment/paystack_payment_page.dart';
import 'package:ambu_go_user/app/modules/pay_stack/main.dart';
import 'package:ambu_go_user/app/modules/qr/QR%20Generator/QRGenerator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../helper/snackbar.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimensions.dart';
import '../../ambulance_details/controller/ambulance_controller.dart';
import '../../ambulance_details/view/additional_details.dart';
import '../../ambulance_details/view/ambulance_details.dart';
// import '../../mobile_money/client.dart';
import 'home.dart';



class Homepage extends GetView<HomepageController> {
  final HomepageController controller = Get.put(HomepageController());
  AmbulanceDetailsController ambulanceController = Get.find();
  Completer<GoogleMapController> mapController = Completer();
  var currentMapType = Rx<MapType>(MapType.normal);

  String getResult = 'QR Code Result';


  void toggleMapType() {
    currentMapType.value = (currentMapType.value == MapType.normal)
        ? MapType.satellite
        : MapType.normal;
  }

  static const route = '/homepage';
  bool booked = false;

  Homepage({Key? key, this.booked = false}) : super(key: key); // Define key parameter in constructor

  static launch() => Get.toNamed(route);

  final PanelController panelController = PanelController();

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }
  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
  final _advancedDrawerController = AdvancedDrawerController();

  Future<BitmapDescriptor> _loadMarkerIcon(String assetPath) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    final Uint8List byteList = byteData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(byteList);
  }



  @override
  Widget build(BuildContext context) {
    controller.ambulanceBookedBool(booked);
    return AdvancedDrawer(
      backdropColor: Colors.indigo.shade700,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade900,
            blurRadius: 20.0,
            spreadRadius: 5.0,
            offset: const Offset(-20.0, 0.0),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      drawer: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80.0,
                  height: 80.0,
                  margin: const EdgeInsets.only(
                    left: 20,
                    top: 24.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/king.jpg'),
                ),
                const SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text(
                    "Krees Kheeng",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                const Divider(color: Colors.white70,),
                ListTile(
                  onTap: () { Get.to( Homepage());},
                  leading: const Icon(Iconsax.home),
                  title: const Text('Dashboard'),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Iconsax.chart_2),
                  title: const Text('Analytics'),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Iconsax.profile_2user),
                  title: const Text('Contacts'),
                ),
                const SizedBox(height: 50,),
                Divider(color: Colors.grey.shade800),
                ListTile(
                    onTap: () { },
                  leading: const Icon(Iconsax.setting_2),
                  title: const Text('Settings'),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Iconsax.support),
                  title: const Text('Support'),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('                      Ambulance Go Inc.',
                    style: TextStyle(color: Colors.grey.shade500),),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(


        appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(

          color: Colors.indigo,
          onPressed: _handleMenuButtonPressed,
          icon: ValueListenableBuilder<AdvancedDrawerValue>(


            valueListenable: _advancedDrawerController,
            builder: (_, value, __) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  value.visible ? Iconsax.close_square : Iconsax.menu,
                  key: ValueKey<bool>(value.visible),
                ),
              );
            },
          ),
        ),

        title: Row(
          children: [
            Image.asset(
              'assets/images/ambugo.jpg',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 2.0),
            const Text(
              'Ambulance Go',
              style: TextStyle(
                color: Colors.pink,
                fontFamily: 'RedHat',
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Iconsax.notification,
              color: Colors.indigo,
              size: 30,
            ),
          ),
        ],
      ),
        body: SafeArea(
          child: Obx(() => controller.ambulanceBooked
              ? GetBuilder<AmbulanceDetailsController>(
            builder: (ambulanceController) {
              return SlidingUpPanel(
                maxHeight: ambulanceController.additionalData
                    ? Dimensions.height40 * 17
                    : Dimensions.height40 * 12,
                controller: panelController,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                panelBuilder: (controller) =>
                ambulanceController.additionalData
                    ? AdditionalData(scrollController: controller)
                    : AmbulanceDetails(scrollController: controller),
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
            borderRadius: BorderRadius.circular(Dimensions.radius30),
            panelBuilder: (controller) => PanelWidget(),
            body: renderMap(),
          )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed functionality here
          },
          child: const Icon(Iconsax.home, color: Colors.white, size: 27),
          backgroundColor: Colors.indigo,
          shape: const CircleBorder(), // This makes the FloatingActionButton round
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(// Set width of the SizedBox

          shape: const CircularNotchedRectangle(),
          color: Colors.white,
          elevation: 10,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40), // Add space on the left side
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () { Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PayStack(
                            initialEmail: 'ckamoga23@gmail.com',
                            initialPrice: 5000,
                          )),
                    );
                      // was taking me to wallet
                    },
                    icon: const Icon(Iconsax.activity, size: 35, color: Colors.indigo),
                  ),
                 // Text(
                 //   'Activity',
                 //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                //  ),

                ],
              ),
              const SizedBox(width: 40), // Add more space between items
              const Expanded(
                child: SizedBox(), // Spacer to center the middle icon
              ),
              const SizedBox(
                width: 70, // Set width of the SizedBox
                height: 10, // Set height of the SizedBox
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              const SizedBox(width: 20), // Add more space between items
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      },
                    icon: const Icon(Iconsax.personalcard, size: 35, color: Colors.indigo),
                  ),
                  //Text(
                 //   'My Account',
                 //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                 // ),

                ],
              ),
              const SizedBox(width: 40), // Add space on the right side
            ],
          ),
        ),
      ),
    );
  }


  Widget renderMap() {
    return Obx(() => (controller.isLoading.value)
        ? const Center(
      child: CircularProgressIndicator(color: AppColors.pink),
    )
        : FutureBuilder(
      future: _loadMarkerIcons(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.pink));
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading marker icons'));
        } else {
          return Stack(
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
                       //icon: _driverMarkerIcon,
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
                      //icon: _patientMarkerIcon,
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
            ],
          );
        }
      },
    ));
  }

  BitmapDescriptor _driverMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _patientMarkerIcon = BitmapDescriptor.defaultMarker;

  Future<void> _loadMarkerIcons() async {
    _driverMarkerIcon = await _loadMarkerIcon('assets/images/ambulance_icon.png');
    _patientMarkerIcon = await _loadMarkerIcon('assets/images/pointer.png');
  }

}
