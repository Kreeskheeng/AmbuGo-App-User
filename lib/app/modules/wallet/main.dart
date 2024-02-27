import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../helper/shared_preference.dart';
import '../homepage/view/homepage.dart';
import '../qr/QR Generator/QRGenerator.dart';
import 'pages/Qr.dart';


class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  late ScrollController _scrollController;
  bool _isScrolled = false;

  List<dynamic> _services = [
    ['QR Code', Iconsax.scan, Color(0xFFf0f0f0), Color(0xFFd9d9d9)],
    // Neumorphism design
    ['Send', Iconsax.money_send4, Color(0xFFf0f0f0), Color(0xFFd9d9d9)],
    // Neumorphism design
    ['Get code', Iconsax.card, Color(0xFFf0f0f0), Color(0xFFd9d9d9)],
    // Neumorphism design
  ];

  List<dynamic> _transactions = [];

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);
    retrieveRideFare();
    super.initState();
    super.initState();
  }

  void _listenToScrollChange() {
    if (_scrollController.offset >= 100.0) {
      setState(() {
        _isScrolled = true;
      });
    } else {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  final _advancedDrawerController = AdvancedDrawerController();
  final _rideFare = ''.obs; // Store the ride fare

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

  TextEditingController mycontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            offset: Offset(-20.0, 0.0),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      drawer: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80.0,
                  height: 80.0,
                  margin: EdgeInsets.only(
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
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Text(
                    "Krees Kheeng",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(),
                Divider(color: Colors.white70,),
                ListTile(
                  onTap: () {},
                  leading: Icon(Iconsax.home),
                  title: Text('Dashboard'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Iconsax.chart_2),
                  title: Text('Analytics'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Iconsax.profile_2user),
                  title: Text('Contacts'),
                ),
                SizedBox(height: 50,),
                Divider(color: Colors.grey.shade800),
                ListTile(
                  onTap: () {},
                  leading: Icon(Iconsax.setting_2),
                  title: Text('Settings'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Iconsax.support),
                  title: Text('Support'),
                ),
                Spacer(),
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
        backgroundColor: Colors.grey.shade100,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              elevation: 0,
              pinned: true,
              stretch: true,
              toolbarHeight: 80,
              backgroundColor: Colors.white,
              leading: IconButton(
                color: Colors.indigo,
                onPressed: _handleMenuButtonPressed,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (_, value, __) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      child: Icon(
                        value.visible ? Iconsax.close_square : Iconsax.menu,
                        key: ValueKey<bool>(value.visible),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                      Iconsax.notification, color: Colors.indigo),
                  onPressed: () {},
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              centerTitle: true,
              title: AnimatedOpacity(
                opacity: _isScrolled ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/ambugo.jpg',
                      width: 40,
                      height: 40,
                    ),

                    Text(
                      'Ambulance Go',
                      style: TextStyle(
                        color: Colors.pink,
                        fontFamily: 'RedHat',
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),

                  ],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                titlePadding: const EdgeInsets.only(left: 20, right: 20),
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isScrolled ? 0.0 : 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FadeIn(
                        duration: const Duration(milliseconds: 500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/ambugo.jpg',
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(width: 2.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ambulance Go',
                                  style: TextStyle(
                                    color: Colors.pink,
                                    fontFamily: 'RedHat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                Text(
                                  '    Mobile Wallet',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontFamily: 'RedHat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      FadeIn(
                        duration: const Duration(milliseconds: 500),
                        child: MaterialButton(
                          height: 30,
                          padding: EdgeInsets.symmetric(horizontal: 20,
                              vertical: 0),
                          onPressed: () {},
                          child: Text('Bal\: 850.500 Shs', style: TextStyle(
                              color: Colors.indigo, fontSize: 10),),
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.grey.shade300, width: 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: 30,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: 8,),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(20),
              // Add padding around the SliverGrid
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Set the number of columns to 3
                  mainAxisSpacing: 10.0, // Spacing between rows
                  crossAxisSpacing: 10.0, // Spacing between columns
                  childAspectRatio: 1.0, // Aspect ratio for each grid item
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Builder(
                      builder: (context) {
                        return SizedBox(
                          height: 70,
                          // Reduce the height to make the button smaller
                          child: ElevatedButton(
                            onPressed: () {
                              _onServiceButtonPressed(_services[index][0]);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _services[index][3], backgroundColor: _services[index][2],
                              // Light shadow color
                              elevation: 8,
                              // Adjust elevation value for the depth of the neumorphism effect
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _services[index][1],
                                  color: Colors.pink,
                                  // Icon color (changed to the default grey)
                                  size: 30, // Increase the size to make the icon bigger
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _services[index][0],
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 12), // Increased font size
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: _services.length,
                ),
              ),
            ),
            SliverFillRemaining(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  children: [
                    FadeInDown(
                      duration: Duration(milliseconds: 500),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Today', style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),),
                            SizedBox(width: 10,),
                            Text('Shs 75,000.00', style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,)),
                          ]
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 20),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          return FadeInDown(
                            duration: Duration(milliseconds: 500),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.network(
                                        _transactions[index][1], width: 50,
                                        height: 50,),
                                      SizedBox(width: 15,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(_transactions[index][0],
                                            style: TextStyle(
                                                color: Colors.grey.shade900,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),),
                                          SizedBox(height: 5,),
                                          Text(_transactions[index][2],
                                            style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 12),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(_transactions[index][3],
                                    style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: SizedBox(
          width: 80,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homepage()),
              );
            },
            child: Icon(Iconsax.alarm, size: 30),
            backgroundColor: Colors.indigo,
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.grey.shade200,
          elevation: 10,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 40), // Add space on the left side
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {

                    },
                    icon: Icon(Iconsax.home, size: 35, color: Colors.indigo),
                  ),
                  Text(
                    'Home',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              SizedBox(width: 40), // Add more space between items
              Expanded(
                child: SizedBox(), // Spacer to center the middle icon
              ),
              SizedBox(
                width: 70, // Set width of the SizedBox
                height: 70, // Set height of the SizedBox
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              SizedBox(width: 40), // Add more space between items
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Wallet() ),
                      );

                    },
                    icon: Icon(Iconsax.personalcard, size: 35, color: Colors.indigo),
                  ),
                  Text(
                    'My account',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              SizedBox(width: 40), // Add space on the right side
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  void _onServiceButtonPressed(String serviceName) async {
    if (serviceName == 'QR Code') {
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
          print('Scanned QR Code: $qrCode');

          // Save the scanned QR code result to Firestore
          await FirebaseFirestore.instance
              .collection('scanned_codes')
              .add({'result': qrCode});
        } else {
          // QR code scan failed.
          print('Failed to scan QR Code.');
        }
      } on PlatformException {
        print('Failed to scan QR Code.');
      }
    }

    if (serviceName == 'billx') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyCustomWidget()));
    }

    if (serviceName == 'Get Code') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  QRGenerator() ), // Change this line
      );
    }
  }
}
