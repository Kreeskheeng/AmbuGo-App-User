// ignore_for_file: avoid_init_to_null

import 'dart:async';
import 'dart:developer';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:location/location.dart';
import 'package:flutter/material.dart';

import '../../../../helper/loading.dart';
import '../../../../helper/shared_preference.dart';

class HomepageController extends GetxController {
  RxString qrCodeResult = 'QR Code Result'.obs;

  void updateQRCodeResult(String result) {
    qrCodeResult.value = result;
  }

  RxBool isLoading = true.obs;
  Location location = Location();
  LocationData? currentLocation;
  late bool _serviceEnabled;
  late StreamController<LatLng> latLng = StreamController.broadcast();

  //location
  TextEditingController enterLocation = TextEditingController();
  late List<geocoding.Placemark> placemarks;
  RxString? selectedAddress = "Loading".obs;

  void onChangedselectedAddress(String addressLocation) {
    selectedAddress!(addressLocation);
  }

  var currentMapType = Rx<MapType>(MapType.normal);

  void toggleMapType() {
    currentMapType.value = (currentMapType.value == MapType.normal)
        ? MapType.satellite
        : MapType.normal;
  }

  //ride
  final _rideFare = ''.obs; // Store the ride fare
  String get rideFare => _rideFare.value;

  @override
  void onReady() {
    retrieveRideFare();
    super.onReady();
  }

  // Retrieve the ride fare from Firebase
  void retrieveRideFare() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> rideInfoDoc =
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(SPController().getUserId())
          .get();
      String rideFare = rideInfoDoc['rideFare'].toString(); // Change the field name as per your Firestore structure
      print('Retrieved ride fare: $rideFare');

      _rideFare(rideFare);

      if (rideInfoDoc['ambulanceStatus'] == 'completed') {
        // Navigate to the ride_fare page
        Get.offNamed('');
      } else {
        // Generate and display QR code for ride fare
        //displayQRCodeInPanel(rideFare);
      }
    } catch (e) {
      print('Error retrieving ride fare: $e');
    }
  }

  //nextPage
  void ambulanceBookedBool(bool x) {
    _ambulanceBooked(x);
    if (x == false) {
      polylineCoordinates.clear();
      update();
    }
  }

  var driverDoc = null;
  var emtDoc = null;

  void onGetDocuments(String driverId, String emtId) async {
    driverDoc = await FirebaseFirestore.instance.collection('driver').doc(driverId).get();
    if (emtId != '') {
      emtDoc = await FirebaseFirestore.instance.collection('staff').doc(emtId).get();
      update();
    }
    update();
  }

  final _ambulanceBooked = false.obs;
  bool get ambulanceBooked => _ambulanceBooked.value;

  void onAmbulanceBooked(bool x) async {
    LoadingUtils.showLoader();

    String userId = SPController().getUserId();

    // Fetch the user's name from the "users" collection
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    String userName = userSnapshot.get('name');

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(userId)
        .set({
      'userId': userId,
      'userName': userName, // Include the user's name
      'ambulanceStatus': 'not assigned',
      'location': {
        "lat": currentLocation!.latitude,
        "lng": currentLocation!.longitude,
        'time': DateTime.now().toString(),
      },
      'rideKey': '',
      'ambulanceDetails': {
        'driverId': '',
      },
      'emtId': '',
      'ambulanceLocation': {
        'lat': 0.0,
        'lng': 0.0,
        'time': ''
      },
      'additionalData': {
        'preferredHospital': '',
        'hospitalType': 'Private and Public',
        'emergencyType': []
      },
      'medicalReport': {},
      'nearest hospital': {},
      'declinedDrivers': [], // Include an empty list for declined drivers
    });

    LoadingUtils.hideLoader();
    _ambulanceBooked(x);

    // Notify driver
    await notifyDriver(userId, userName);
  }

  Future<void> notifyDriver(String userId, String userName) async {
    final url = 'https://your-backend.example.com/request-ambulance';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'userName': userName,
        'location': {
          "lat": currentLocation!.latitude,
          "lng": currentLocation!.longitude,
        },
      }),
    );

    if (response.statusCode == 200) {
      print('Driver notified successfully');
    } else {
      print('Failed to notify driver');
    }
  }

  @override
  void onInit() {
    getpermission();
    getCurrentLocation();
    super.onInit();
  }

  void onCameraIdle() async {
    log("Getting placemarks");
    placemarks = await geocoding.placemarkFromCoordinates(
        currentLocation!.latitude!, currentLocation!.longitude!);
    onChangedselectedAddress(
        "${placemarks[1].name!}, ${placemarks[2].name!}, ${placemarks[3].name!}, ${placemarks.first.name!}");
  }

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
          (location) async {
        currentLocation = location;
        latLng.add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
        log("Got Current Location");
        isLoading.value = false;
      },
    );
    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      update();

      if (ambulanceBooked) {
        getPolyPoints();
        onUpdateLocationFirebase(DateTime.now().toString()); // Capture current time and date
      } else {
        onCameraIdle();
      }
    });
  }

  void getpermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        debugPrint('Location Denied once');
      }
    }
  }

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyBtFdD1MNJWvqevGFtv5KgpHcgQXBusi4E',
        PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
        PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!));

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        update();
      }
    }
  }

  final _destinationLocation = const LatLng(0, 0).obs;
  LatLng get destinationLocation => _destinationLocation.value;

  final _time = ''.obs;
  String get time => _time.value;

  void onUpdateLocationFirebase(String currentTime) async {
    FirebaseFirestore.instance.collection('bookings').doc(SPController().getUserId()).update({
      'location': {
        'time': currentTime, // Use the provided current time and date
        'lat': currentLocation!.latitude,
        'lng': currentLocation!.longitude,
      }
    });
  }

  final _ambulanceAssigned = false.obs;
  bool get ambulanceAssigned => _ambulanceAssigned.value;

  void ambulanceAssignedBool(bool x) {
    _ambulanceAssigned(x);
  }

  void onGetPatientLocation(double lat, double lng) async {
    _destinationLocation(LatLng(lat, lng));
    getPolyPoints();
    _ambulanceAssigned(true);

    // Update the ambulance's location with the current time and date
    onUpdateLocationFirebase(DateTime.now().toString());

    getPolyPoints();
    _ambulanceAssigned(true);
  }
}
