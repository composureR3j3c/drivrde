import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import '../Models/Users.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
StreamSubscription<Position>? homePageStreamSubscription;

DatabaseReference? rideReference;

AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
