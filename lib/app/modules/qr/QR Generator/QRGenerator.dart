import 'package:ambu_go_user/app/modules/login/view/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/shared_preference.dart';
import '../../../../utils/colors.dart';
import 'GeneratedQR.dart';

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
              fontSize: 20,
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

class QRGenerator extends StatefulWidget {
  QRGenerator({Key? key}) : super(key: key);

  @override
  _QRGeneratorState createState() => _QRGeneratorState();
}

TextEditingController mycontroller = new TextEditingController();

class _QRGeneratorState extends State<QRGenerator> {
  final _rideFare = ''.obs; // Store the ride fare

  @override
  void initState() {
    // Retrieve the ride fare from Firebase when the widget is initialized
    retrieveRideFare();
    super.initState();
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

    } catch (e) {
      print('Error retrieving ride fare: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
          children: [
            Image.asset(
              'assets/images/qrcode.jpg', // Replace with the path to your image
              width: 300, // Adjust the width as needed
              height: 300, // Adjust the height as needed
            ),
            SizedBox(height: 20), // Add spacing between image and text
            Text(
              "Generate Ride Fare Qr code!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Add spacing between text and button
            Container(
              width: ((MediaQuery.of(context).size.width) / 2) - 45,
              height: 35,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink, // Set button color to pink
                ),
                child: Text(
                  "Generate QR",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: navigate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigate() {

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GeneratedQR(_rideFare.value)));
  }
}
