import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:camera_locations/app/config/mapbox_config.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class HomeController extends GetxController {
  late CameraController cameraController;
  final RxBool isCameraReady = false.obs;
  final RxBool isCameraError = false.obs;
  final RxString cameraErrorMessage = ''.obs;

  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxDouble accuracy = 0.0.obs;

  final RxString captureTime = ''.obs;

  final RxString locationName = ''.obs;

  final Rx<File?> capturedImage = Rx<File?>(null);
  final RxBool showPreview = false.obs;
  final RxString capturedImageBase64 = ''.obs;

  late DateTime _captureMoment;
  StreamSubscription<Position>? _gpsSubscription;
  Timer? _geocodeDebounce;

  @override
  void onInit() {
    super.onInit();
    initCamera();
    startLocationUpdates();
  }

  @override
  void onClose() {
    _gpsSubscription?.cancel();
    _geocodeDebounce?.cancel();
    super.onClose();
  }

  Future<void> initCamera() async {
    isCameraReady.value = false;
    isCameraError.value = false;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        isCameraError.value = true;
        cameraErrorMessage.value = "No cameras found on this device.";
        return;
      }

      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController.initialize();
      isCameraReady.value = true;
    } catch (e) {
      isCameraError.value = true;
      cameraErrorMessage.value = e.toString();
      debugPrint("Camera initialization error: $e");
    }
  }

  Future<void> startLocationUpdates() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied ||
          requested == LocationPermission.deniedForever) {
        return;
      }
    }

    Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        timeLimit: Duration(seconds: 5),
      ),
    ).then((pos) {
      latitude.value = pos.latitude;
      longitude.value = pos.longitude;
      accuracy.value = pos.accuracy;
      _fetchPlaceName(pos.latitude, pos.longitude);
    }).catchError((_) {});

    _gpsSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    ).listen((pos) {
      latitude.value = pos.latitude;
      longitude.value = pos.longitude;
      accuracy.value = pos.accuracy;
      _debouncePlaceName(pos.latitude, pos.longitude);
    }, onError: (_) {});
  }

  void _debouncePlaceName(double lat, double lng) {
    _geocodeDebounce?.cancel();
    _geocodeDebounce = Timer(const Duration(seconds: 1), () {
      _fetchPlaceName(lat, lng);
    });
  }

  Future<void> _fetchPlaceName(double lat, double lng) async {
    try {
      final url = Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/'
        '$lng,$lat.json'
        '?access_token=${MapboxConfig.accessToken}'
        '&types=locality,place,neighborhood,address,poi'
        '&limit=1',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map;
        final features = data['features'] as List?;
        if (features != null && features.isNotEmpty) {
          final placeName = features.first['place_name'] as String?;
          if (placeName != null && placeName.isNotEmpty) {
            locationName.value = placeName;
            return;
          }
        }
      }
    } catch (_) {}

    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        locationName.value =
            "${p.subLocality ?? ''}, ${p.locality ?? ''}, ${p.administrativeArea ?? ''}"
                .replaceAll(', ,', ',')
                .trim();
      }
    } catch (_) {
      locationName.value = "Unknown location";
    }
  }

  Future<void> capturePhoto() async {
    _captureMoment = DateTime.now();

    captureTime.value = DateFormat(
      'dd MMM yyyy HH:mm:ss',
    ).format(_captureMoment);

    final XFile file = await cameraController.takePicture();

    capturedImage.value = File(file.path);
    showPreview.value = true;
  }

  void discardPhoto() {
    capturedImage.value?.delete();
    capturedImage.value = null;
    showPreview.value = false;
  }

  Future<void> confirmSave() async {
    final file = capturedImage.value;
    if (file == null) return;

    final tempDir = Directory.systemTemp;
    final stampedFile = await stampImage(file, tempDir);
    final stampedBytes = await stampedFile.readAsBytes();
    capturedImageBase64.value = base64Encode(stampedBytes);
    await stampedFile.delete();

    capturedImage.value = null;
    showPreview.value = false;
  }

  Future<File> stampImage(File file, Directory outputDir) async {
    final bytes = await file.readAsBytes();
    var image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception("Failed to decode image");
    }

    final font = img.arial24;

    final white = img.ColorUint8.rgba(255, 255, 255, 255);
    final black = img.ColorUint8.rgba(0, 0, 0, 160);

    final boxHeight = (image.height * 0.30).toInt();

    image = img.fillRect(
      image,
      x1: 0,
      y1: image.height - boxHeight,
      x2: image.width,
      y2: image.height,
      color: black,
    );

    int y = image.height - boxHeight + 20;

    image = img.drawString(
      image,
      captureTime.value,
      x: 20,
      y: y,
      color: white,
      font: font,
    );
    y += 30;

    image = img.drawString(
      image,
      locationName.value,
      x: 20,
      y: y,
      color: white,
      font: font,
    );
    y += 30;

    image = img.drawString(
      image,
      "Lat: ${latitude.value.toStringAsFixed(6)}",
      x: 20,
      y: y,
      color: white,
      font: font,
    );
    y += 25;

    image = img.drawString(
      image,
      "Lng: ${longitude.value.toStringAsFixed(6)}",
      x: 20,
      y: y,
      color: white,
      font: font,
    );
    y += 25;

    image = img.drawString(
      image,
      "Acc: ±${accuracy.value.toStringAsFixed(1)} m",
      x: 20,
      y: y,
      color: white,
      font: font,
    );

    final output = img.encodeJpg(image, quality: 95);

    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }

    final fileName = 'GPS_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final savedFile = File('${outputDir.path}/$fileName');
    await savedFile.writeAsBytes(Uint8List.fromList(output));

    return savedFile;
  }
}
