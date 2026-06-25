import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxDouble altitude = 0.0.obs;
  final RxDouble accuracy = 0.0.obs;
  final RxDouble speed = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasLocation = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      hasLocation.value = false;
      errorMessage.value = '';

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          errorMessage.value =
              'Location permission is required.\nGrant it in Settings.';
          isLoading.value = false;
          return;
        }
      }

      Position? bestPosition;
      StreamSubscription<Position>? subscription;
      final completer = Completer<void>();

      subscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      ).listen((pos) {
        final best = bestPosition;
        if (best == null || pos.accuracy < best.accuracy) {
          bestPosition = pos;
          latitude.value = pos.latitude;
          longitude.value = pos.longitude;
          altitude.value = pos.altitude;
          accuracy.value = pos.accuracy;
          speed.value = pos.speed;
        }
        if (pos.accuracy <= 5.0) {
          subscription?.cancel();
          if (!completer.isCompleted) completer.complete();
        }
      });

      Future.delayed(const Duration(seconds: 15), () {
        subscription?.cancel();
        if (!completer.isCompleted) completer.complete();
      });

      await completer.future;

      if (bestPosition == null) {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation,
          ),
        );
        latitude.value = pos.latitude;
        longitude.value = pos.longitude;
        altitude.value = pos.altitude;
        accuracy.value = pos.accuracy;
        speed.value = pos.speed;
      }

      hasLocation.value = true;
    } catch (e) {
      debugPrint('Error getting location: $e');
      errorMessage.value = 'Could not get location: $e';
      hasLocation.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    latitude.value = 0.0;
    longitude.value = 0.0;
    altitude.value = 0.0;
    accuracy.value = 0.0;
    speed.value = 0.0;
    hasLocation.value = false;
    errorMessage.value = '';
  }
}
