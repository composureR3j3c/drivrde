import 'dart:async';

import 'package:driveridee/AllScreens/searchScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../Helpers/assistantMethods.dart';
import '../Models/directDetails.dart';
import '../Provider/appdata.dart';
import '../Widgets/Colorize.dart';
import '../Widgets/Divider.dart';
import '../Widgets/Drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {

  late TabController tabController;
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
    return Container();
  }

}
