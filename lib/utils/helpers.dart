

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class Helpers {

  static Future<String> determineAddress() async {
    bool serviceEnabled;
    LocationPermission permission;
    RxString userAddress = ''.obs;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      permission = await Geolocator.requestPermission();
      var address = Geolocator.getCurrentPosition().then((position) async{
        log('called from service disabled');
        userAddress.value = await getLatLngFromAddress(position);
        log('address after call : ${userAddress.value}');
        return userAddress.value;
      });

      return Future.value(address);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        await Geolocator.getCurrentPosition().then((position) async{
          log('called from denied');
          userAddress.value = await getLatLngFromAddress(position);
        });
        Fluttertoast.showToast(
            msg: "Location permissions are denied",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      await Geolocator.getCurrentPosition().then((position) async{
        log('called from denied forever');
        userAddress.value = await getLatLngFromAddress(position);
      });

      Fluttertoast.showToast(
          msg:
          "Location permissions are permanently denied, we cannot request permissions.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    if(userAddress.value==''){
      await Geolocator.getCurrentPosition().then((position) async{
        log('called from outside');
        userAddress.value = await getLatLngFromAddress(position);
      });
    }

    log('address : $userAddress');
    return userAddress.value;
  }

  static Future<String> getLatLngFromAddress(Position position) async {
    List<Placemark> locationList = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = locationList[0];

    var userAddress = '${place.locality}, ${place.country}, ${place.postalCode}';
    log('user Address : $userAddress');
    return userAddress;
  }


}