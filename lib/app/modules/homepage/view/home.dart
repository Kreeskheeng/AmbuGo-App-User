import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:last_minute/app/modules/homepage/view/homepage.dart';
import 'package:last_minute/app/modules/wallet/main.dart';

void _handleMenuButtonPressed() {
  _advancedDrawerController1.showDrawer();
}
final _advancedDrawerController1 = AdvancedDrawerController();



class AmbulanceGoApp extends StatelessWidget {
  const AmbulanceGoApp({super.key});
  static const route = '/AmbulanceGoApp';

  static launch() => Get.toNamed(route);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdvancedDrawer(
        backdropColor: Colors.indigo.shade700,
        controller: _advancedDrawerController1,
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
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(

              color: Colors.indigo,
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(


                valueListenable: _advancedDrawerController1,
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

            title: Row(
              children: [
                Image.asset(
                  'assets/images/ambugo.jpg',
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 2.0),
                Text(
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
                icon: Icon(
                  Iconsax.notification,
                  color: Colors.indigo,
                  size: 30,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Text(
                  'Welcome to Ambulance Go!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                _buildUserDetails(context),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBigFeatureButton(
                      context,
                      'Request\nAmbulance',
                      'assets/images/ambuicon.png',
                          () => Get.to(Homepage()), // Updated onTap function
                    ),
                    _buildBigFeatureButton(
                      context,
                      'Mobile\nWallet',
                      'assets/images/walleticon.png',
                          () => Get.to(Wallet()), // Updated onTap function
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSmallFeatureButton(
                      context,
                      'Insurance\nCoverage',
                      'assets/images/insuranceicon.png',
                          () => Get.to(EmergencyContactsPage()), // Updated onTap function
                    ),
                    _buildSmallFeatureButton(
                      context,
                      'Live\nTracking',
                      'assets/images/trackicon.png',
                          () => Get.to(LiveTrackingPage()), // Updated onTap function
                    ),
                    _buildSmallFeatureButton(
                      context,
                      'First Aid\nGuide',
                      'assets/images/firstaidicon.png',
                          () => Get.to(FirstAidGuidePage()), // Updated onTap function
                    ),
                  ],
                ),
                SizedBox(height: 30),
                _buildAdvertisement(context),
              ],
            ),
          ),
          floatingActionButton: SizedBox(
            width: 80,
            height: 70,
            child: FloatingActionButton(
              onPressed: () {
                Get.to(Homepage());
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
                SizedBox(width: 40),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Iconsax.activity, size: 35, color: Colors.indigo),
                    ),
                    Text(
                      'Activity',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(width: 40),
                Expanded(
                  child: SizedBox(),
                ),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                  ),
                ),
                SizedBox(width: 40),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Iconsax.personalcard, size: 35, color: Colors.indigo),
                    ),
                    Text(
                      'My account',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(width: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetails(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, John Doe',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Arriving Faster, Saving Lives Together!',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/king.jpg'),
          ),
        ],
      ),
    );
  }

  Widget _buildBigFeatureButton(BuildContext context, String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade200,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400]!,
              offset: Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-4.0, -4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 90,
              height: 90,
            ),
            SizedBox(height: 2),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallFeatureButton(BuildContext context, String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade200,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400]!,
              offset: Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-4.0, -4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 80,
              height: 80,
            ),
            SizedBox(height: 3),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvertisement(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Check out our latest feature!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Introducing Premium Membership. Enjoy priority assistance, exclusive discounts, and more!',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          SizedBox(height: 5),
          Image.asset(
            'assets/images/adv.png',
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Implement action for advertisement button
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.indigo,
              onPrimary: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text(
              'Learn More',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}





class EmergencyContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Contacts'),
      ),
      body: Center(
        child: Text('Emergency Contacts Page'),
      ),
    );
  }
}

class LiveTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Tracking'),
      ),
      body: Center(
        child: Text('Live Tracking Page'),
      ),
    );
  }
}

class FirstAidGuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Aid Guide'),
      ),
      body: Center(
        child: Text('First Aid Guide Page'),
      ),
    );
  }
}
