import 'dart:async';

import 'package:driveridee/Globals/Global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTab extends StatelessWidget {
  HomeTab({Key? key}) : super(key: key);

  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController newGoogleMapController;

  double bottomPadding = 0;

  static final CameraPosition _kinit = const CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(9.005401, 38.763611),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  late Position currentPosition;

  late LocationPermission permission;
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(bottom: bottomPadding),
          initialCameraPosition: _kinit,
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
                    makeDriverOnline();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Row(
                      children: [
                        const Text(
                          "Online Now",
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

  void makeDriverOnline() {
    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentFirebaseUser!.uid, currentPosition.latitude,
        currentPosition.longitude);
        
  }
}
