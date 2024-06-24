import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ambu_go_user/helper/shared_preference.dart';
import 'package:ambu_go_user/utils/colors.dart';
import 'package:ambu_go_user/utils/dimensions.dart';
import 'package:ambu_go_user/widgets/big_text.dart';
import 'package:lottie/lottie.dart';
import 'package:ambu_go_user/app/modules/ambulance_details/controller/ambulance_controller.dart';
import 'package:ambu_go_user/app/modules/homepage/controller/homepage_controller.dart';
import '../../../../widgets/button.dart';
import '../../homepage/view/homepage.dart';
import '../../pay_stack/Payment/paystack_payment_page.dart';

class AmbulanceDetails extends GetView<AmbulanceDetailsController> {
  HomepageController homepageController = Get.find();
  ScrollController scrollController;

  AmbulanceDetails({super.key, required this.scrollController});

  // Method to launch phone call
  void _launchPhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Error launching phone call');
    }
  }

  // Method to handle retrieving ride info from Firestore
  void retrieveRideInfo() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> rideInfoDoc =
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(SPController().getUserId())
          .get();

      String rideKey = rideInfoDoc.id;
      String time = rideInfoDoc['time'].toString();



      // Call the appropriate function to handle rideKey and time
    } catch (e) {

    }
  }

  // Function to open QR code scanner
  void openQRScanner() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (qrCode == '-1') {
        // User canceled the scan.
        print('Scan canceled.');
      } else if (qrCode.isNotEmpty) {
        // QR code was successfully scanned.


        // Save the scanned QR code result to Firestore
        await FirebaseFirestore.instance.collection('scanned_codes').add({
          'result': qrCode,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Navigate to the Stripe payment page (uncomment the code below if needed)
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Wallet(), // Replace with your Stripe payment screen
        //   ),
        // );
      } else {
        // QR code scan failed.\
      }
    } on PlatformException {

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
                  bool completed = false;
                  List bookingAmbulance = [];
                  if (snapshot.hasData) {
                    final bookings = snapshot.data!.docs;
                    for (var booking in bookings) {
                      if (booking['ambulanceStatus'] == 'assigned' &&
                          booking['userId'] == SPController().getUserId()) {
                        homepageController.onGetDocuments(
                            booking['ambulanceDetails']['driverId'],
                            booking['emtId']);
                        bookingAmbulance.add(booking);
                        homepageController.onGetPatientLocation(
                            booking['ambulanceLocation']['lat'],
                            booking['ambulanceLocation']['lng']);
                      }
                      if (booking['ambulanceStatus'] == 'completed' &&
                          booking['userId'] == SPController().getUserId()) {
                        completed = true;
                        // Open QR code scanning functionality when booking status is completed
                        scanQRCode(context);
                      }

                    }
                  }
                  // Handle UI based on booking status
                  return completed
                      ? Homepage()
                      : _buildSearchingUI();
                },
              ),
            ),
          ),
          controller.informationUpdated
              ? Align(
              alignment: Alignment.centerRight,
              child: Button(
                on_pressed: () {
                  controller.onPageChanged(true);
                },
                text: 'Edit Additional Details?',
                width: Dimensions.width40 * 5,
                height: null,
                color: Colors.transparent,
                textSize: Dimensions.font15 / 1.1,
                textColor: AppColors.pink,
              ))
              : Container(),
          BigText(
            text:
            'Keep updating the situations as it will help us to get you to the right hospital.',
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
                on_pressed: () {},
                text: 'Generate QR code',
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

  void scanQRCode(context) async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (qrCode == '-1') {
        // User canceled the scan.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scan canceled.')),
        );
        return;
      }

      String getResult;
      if (qrCode.isNotEmpty) {
        // QR code was successfully scanned.
        getResult = qrCode;


        // Check if the scanned QR code is a valid price
        final scannedPrice = int.tryParse(qrCode);
        if (scannedPrice != null) {
          // Call the function to make the payment directly
          MakePayment(ctx: context, email: "ckamoga23@gmail.com", price: scannedPrice)
              .chargeCardAndMakePayment();
          return;
        }
      }

      // If the code reaches here, it means the QR code format is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid QR code format: $qrCode"),
        ),
      );
    } on PlatformException {
      // If an exception occurs, handle it and show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to scan QR Code.'),
        ),
      );
    }
  }




  // Method to build UI when booking status is completed
  Widget _buildCompletedUI(List bookingAmbulance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Your UI components when booking status is completed
      ],
    );
  }

  // Method to build UI when searching for ambulance
  Widget _buildSearchingUI() {
    return Column(
      children: [
        SizedBox(
          height: Dimensions.height40 * 5,
          child: Lottie.network(
            'https://lottie.host/7b9bf500-b3ba-4b28-8457-0f19ac94770d/BbwhUC7E4q.json',
            fit: BoxFit.contain,
          ),
        ),
        BigText(
          text: "Searching For Nearest Ambulance.",
          color: AppColors.black,
          fontWeight: FontWeight.bold,
          maxLines: 4,
          size: 20,
        )
      ],
    );
  }
}
