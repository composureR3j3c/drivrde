// import 'dart:js';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driveridee/Globals/Global.dart';
import 'package:driveridee/Models/UserRideRequestInfo.dart';
import 'package:driveridee/Widgets/NotificationDialogBox.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotifServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeFCM(BuildContext context) async {
    // Terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //display ride request information - user information who request a ride
        readUserRideRequestInformation(
            remoteMessage.data["rideRequestId"], context);
      }
    });

    //2. Foreground
    //When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      //display ride request information - user information who request a ride
      readUserRideRequestInformation(
          remoteMessage!.data["rideRequestId"], context);
    });

    //3. Background
    //When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      //display ride request information - user information who request a ride
      readUserRideRequestInformation(
          remoteMessage!.data["rideRequestId"], context);
    });
  }

  readUserRideRequestInformation(
      String userRideRequestId, BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("Ride_Request")
        .child(userRideRequestId)
        .once()
        .then((snapData) {
      if (snapData.snapshot.value != null) {
        audioPlayer.open(Audio("sounds/music_notification.mp3"));
        audioPlayer.play();

        double originLat = double.parse(
            (snapData.snapshot.value! as Map)["pickup"]["latitude"]);
        double originLng = double.parse(
            (snapData.snapshot.value! as Map)["pickup"]["longitude"]);
        String originAddress =
            (snapData.snapshot.value! as Map)["pickup_address"];

        double destinationLat = double.parse(
            (snapData.snapshot.value! as Map)["dropoff"]["latitude"]);
        double destinationLng = double.parse(
            (snapData.snapshot.value! as Map)["dropoff"]["longitude"]);
        String destinationAddress =
            (snapData.snapshot.value! as Map)["dropoff_address"];

        String userName = (snapData.snapshot.value! as Map)["rider_name"];
        String userPhone = (snapData.snapshot.value! as Map)["rider_phone"];

        UserRideRequestInformation userRideRequestDetails =
            UserRideRequestInformation();

        userRideRequestDetails.originLatLng = LatLng(originLat, originLng);
        userRideRequestDetails.originAddress = originAddress;

        userRideRequestDetails.destinationLatLng =
            LatLng(destinationLat, destinationLng);
        userRideRequestDetails.destinationAddress = destinationAddress;

        userRideRequestDetails.userName = userName;
        userRideRequestDetails.userPhone = userPhone;

        showDialog(
            context: context,
            builder: (BuildContext context) => NotificationDialogBox(
                userRideRequestDetails: userRideRequestDetails,
            ),
        );
      } else {
        Fluttertoast.showToast(msg: "This Ride Request Id do not exists.");
      }
    });
  }

  Future generateAndGetToken() async {
    String? registrationToken = await messaging.getToken();
    print("FCM Registration Token: ");
    print(registrationToken);

    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("token")
        .set(registrationToken);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }

  // Future checkPermission() async {
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     String? token = await messaging.getToken();
  //     print("#token");
  //     print(token);
  //     print("#token");

  //     DatabaseReference driversRef =
  //         FirebaseDatabase.instance.ref().child("drivers");
  //     driversRef.child(currentFirebaseUser!.uid).child("token").set(token);

  //     await messaging.subscribeToTopic("allusers");
  //     await messaging.subscribeToTopic("alldrivers");
  //     ForgroundListener();
  //   } else {}
  // }

  void ForgroundListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
