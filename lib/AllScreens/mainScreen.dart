import 'dart:async';

import 'package:driveridee/AllScreens/TabPages/EarningsTab.dart';
import 'package:driveridee/AllScreens/TabPages/HomeTab.dart';
import 'package:driveridee/AllScreens/TabPages/ProfileTab.dart';
import 'package:driveridee/AllScreens/TabPages/RatingsTab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Models/directDetails.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController tabController;
  var selectedIndex = 0;
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController newGoogleMapController;
  static final CameraPosition _kinit = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(9.005401, 38.763611),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  late Position currentPosition;
  var geoLocator = Geolocator();
  late LocationPermission permission;
  double bottomPadding = 0;
  double rideDetailContainerHeight = 0;
  double requestHeight = 0;
  double searchContainerHeight = 320;

  bool searchScreen = true;
  late DirectDetails tripDirectDetails = DirectDetails();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTab(),
          EarnigsTab(),
          RatingsTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), label: "Account"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Ratings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.teal,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12.0,
        showUnselectedLabels: true,
        onTap: onItemclicked,
      ),
    );
  }

  void onItemclicked(int index) {
    selectedIndex = index;
    tabController.index = selectedIndex;
  }
}
