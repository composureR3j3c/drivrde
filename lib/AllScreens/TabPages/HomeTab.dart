import 'dart:async';

import 'package:driveridee/Globals/Global.dart';
import 'package:driveridee/Notifications/pushNotificationService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key? key}) : super(key: key);

  static final CameraPosition _kinit = const CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(9.005401, 38.763611),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController newGoogleMapController;

  double bottomPadding = 0;

  late Position currentPosition;

  late LocationPermission permission;

  late String driverStatusText = "Offline Now - Go Online";

  late Color driverStatusColor = Colors.black;

  bool isDriverAvailable = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    readCurrentDriverInformation();
    // subscribeToNotif();
  }

  void locatePosition() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
      } else if (permission == LocationPermission.deniedForever) {
      } else {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        currentPosition = position;

        LatLng latLngPosition = LatLng(position.latitude, position.longitude);

        CameraPosition cameraPosition = new CameraPosition(
          target: latLngPosition,
          zoom: 14.4746,
        );
        newGoogleMapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        //   final address =
        //       await AssistantMethods.searchAddressForGeographicCoOrdinates(
        //           position, context);
        //   print("address##############");
        //   print(address);
        //   setState(() {
        //     bottomPadding = 300.0;
        //   });
      }
    }
  }

  // void subscribeToNotif() {
  //   PushNotifServices pushNotifServices = PushNotifServices();
  //   pushNotifServices.checkPermission();
  //   // pushNotifServices.getToken();
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(bottom: bottomPadding),
          initialCameraPosition: HomeTab._kinit,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },
          onCameraMove: (position) {
            locatePosition();
          },
        ),
        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black54,
        ),
        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (isDriverAvailable != true) {
                      makeDriverOnline();
                      getLiveLocation();

                      setState(() {
                        driverStatusColor = Colors.green;
                        driverStatusText = "Online Now";
                        isDriverAvailable = true;
                      });
                      Fluttertoast.showToast(msg: "you are Online Now.");
                    } else {
                      setState(() {
                        driverStatusColor = Colors.black;
                        driverStatusText = "Offline Now - Go Online";
                        isDriverAvailable = false;
                      });
                      Fluttertoast.showToast(msg: "you are Offline Now.");
                      makeDriverOffnline();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: driverStatusColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Row(
                      children: [
                        Text(
                          driverStatusText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const Icon(Icons.phone_android,
                            color: Colors.white, size: 26.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  readCurrentDriverInformation() async {
    currentFirebaseUser = fAuth.currentUser;
    PushNotifServices pushNotificationSystem = PushNotifServices();
    pushNotificationSystem.initializeFCM(context);
    pushNotificationSystem.generateAndGetToken();
  }

  void makeDriverOnline() async {
    rideReference = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRide");

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentFirebaseUser!.uid, currentPosition.latitude,
        currentPosition.longitude);

    rideReference!.onValue.listen((event) {});
  }

  void makeDriverOffnline() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    rideReference!.onDisconnect();
    rideReference!.remove();
    rideReference = null;

    Fluttertoast.showToast(msg: "you are Offline Now.");
  }

  void getLiveLocation() {
    homePageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isDriverAvailable == true) {
        Geofire.setLocation(
            currentFirebaseUser!.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}
