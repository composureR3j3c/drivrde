import 'package:driveridee/AllScreens/mainScreen.dart';
import 'package:driveridee/Globals/Global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Widgets/ProgressDialog.dart';

class CarInfo extends StatefulWidget {
  CarInfo({Key? key}) : super(key: key);

  @override
  State<CarInfo> createState() => _CarInfoState();
}

class _CarInfoState extends State<CarInfo> {
  TextEditingController carModelTextEditingController = TextEditingController();

  TextEditingController carNumberTextEditingController =
      TextEditingController();

  TextEditingController carColorTextEditingController = TextEditingController();

  validateForm() {
    if (carNumberTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Car Number.");
    } else if (carModelTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Car Model.");
    } else if (carColorTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter Car Color.");
    } else {
      saveCarInfoNow();
    }
  }

  saveCarInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    String userId = currentFirebaseUser!.uid;

    if (userId != null) {
      Map CarInfoMap = {
        "car_color": carColorTextEditingController.text.trim(),
        "car_model": carModelTextEditingController.text.trim(),
        "car_number": carNumberTextEditingController.text.trim(),
      };

      DatabaseReference reference =
          FirebaseDatabase.instance.ref().child("drivers");
      reference.child(userId).child("Car_details").set(CarInfoMap);

      Fluttertoast.showToast(msg: "Car details has been registered.");
      Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Car details has not been registered.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 22.0,
            ),
            Image.asset(
              "images/logo1.png",
              width: 390.0,
              height: 250.0,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22, 22, 22, 32),
              child: Column(
                children: [
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    "Enter car Detail",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Brand-Bold",
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TextField(
                    controller: carModelTextEditingController,
                    style: const TextStyle(color: Colors.grey),
                    decoration: const InputDecoration(
                      labelText: "Car Model",
                      hintText: "Car Model",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TextField(
                    controller: carNumberTextEditingController,
                    style: const TextStyle(color: Colors.grey),
                    decoration: const InputDecoration(
                      labelText: "Car Number",
                      hintText: "Car Number",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  TextField(
                    controller: carColorTextEditingController,
                    style: const TextStyle(color: Colors.grey),
                    decoration: const InputDecoration(
                      labelText: "Car Color",
                      hintText: "Car Color",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      validateForm();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreenAccent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: Row(
                        children: [
                          const Text(
                            "NEXT",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                          ),
                          Icon(Icons.arrow_forward,
                              color: Colors.white, size: 26.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
