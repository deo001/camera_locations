// import 'dart:io';
// import 'package:exif/exif.dart' as exif_dart;
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';

// class HomeController extends GetxController {
//   final ImagePicker _picker = ImagePicker();

//   final Rx<File?> capturedImage = Rx<File?>(null);
//   final RxBool isLoading = false.obs;
//   final Rx<Map<String, Object>> allAttributes = Rx<Map<String, Object>>({});

//   // Real-time GPS (not from EXIF)
//   final RxDouble gpsLatitude = 0.0.obs;
//   final RxDouble gpsLongitude = 0.0.obs;
//   final RxDouble gpsAltitude = 0.0.obs;
//   final RxDouble gpsAccuracy = 0.0.obs;
//   final RxBool hasGps = false.obs;
//   final RxBool gpsLoading = false.obs;
//   final RxString gpsError = ''.obs;

//   // GPS extracted from the photo's own EXIF metadata (embedded by the
//   // camera/OS at capture time), as opposed to the live Geolocator reading.
//   final RxDouble exifLatitude = 0.0.obs;
//   final RxDouble exifLongitude = 0.0.obs;
//   final RxDouble exifAltitude = 0.0.obs;
//   final RxBool hasExifGps = false.obs;

//   Future<void> takePhoto() async {
//     try {
//       isLoading.value = true;
//       hasGps.value = false;
//       gpsError.value = '';
//       hasExifGps.value = false;

//       final XFile? photo = await _picker.pickImage(
//         source: ImageSource.camera,
//         requestFullMetadata: true,
//       );

//       if (photo == null) {
//         isLoading.value = false;
//         return;
//       }

//       final File permanentFile = await _saveToPermanentPath(photo);
//       capturedImage.value = permanentFile;

//       // Run EXIF reading and GPS capture in parallel
//       await Future.wait([_readExif(permanentFile.path), _captureGps()]);
//     } catch (e) {
//       gpsError.value = 'Error: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<File> _saveToPermanentPath(XFile photo) async {
//     final dir = await getApplicationDocumentsDirectory();
//     final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
//     final File localFile = File('${dir.path}/$fileName');
//     await photo.saveTo(localFile.path);
//     return localFile;
//   }

//   Future<void> _readExif(String path) async {
//     try {
//       final bytes = await File(path).readAsBytes();
//       final rawTags = await exif_dart.readExifFromBytes(bytes);
//       final displayAttrs = <String, Object>{};
//       for (final entry in rawTags.entries) {
//         displayAttrs[entry.key] = entry.value.printable;
//       }
//       allAttributes.value = displayAttrs;

//       // Pull the lat/long/altitude the camera embedded directly in the
//       // image file, instead of relying only on the live GPS reading.
//       _extractGpsFromExif(rawTags);
//     } catch (_) {}
//   }

//   /// Parses the 'GPS GPSLatitude' / 'GPS GPSLongitude' EXIF tags. Each is a
//   /// degrees/minutes/seconds rational triplet, so this converts them to
//   /// decimal degrees and applies the N/S/E/W ref tag for the correct sign.
//   void _extractGpsFromExif(Map<String, exif_dart.IfdTag> rawTags) {
//     final lat = _dmsTagToDecimal(
//       rawTags['GPS GPSLatitude'],
//       rawTags['GPS GPSLatitudeRef'],
//     );
//     final lng = _dmsTagToDecimal(
//       rawTags['GPS GPSLongitude'],
//       rawTags['GPS GPSLongitudeRef'],
//     );

//     if (lat == null || lng == null) {
//       // No GPS block in this image's EXIF (very common — see note below).
//       hasExifGps.value = false;
//       return;
//     }

//     exifLatitude.value = lat;
//     exifLongitude.value = lng;

//     final altitudeTag = rawTags['GPS GPSAltitude'];
//     if (altitudeTag != null) {
//       final altValues = altitudeTag.values.toList();
//       if (altValues.isNotEmpty) {
//         double altitude = _ratioToDouble(altValues.first);
//         // GPSAltitudeRef: '0' = above sea level, '1' = below sea level
//         if (rawTags['GPS GPSAltitudeRef']?.printable.trim() == '1') {
//           altitude = -altitude;
//         }
//         exifAltitude.value = altitude;
//       }
//     }

//     hasExifGps.value = true;
//   }

//   double? _dmsTagToDecimal(
//     exif_dart.IfdTag? coordinateTag,
//     exif_dart.IfdTag? refTag,
//   ) {
//     if (coordinateTag == null) return null;
//     final values = coordinateTag.values.toList();
//     if (values.length != 3) return null;

//     final degrees = _ratioToDouble(values[0]);
//     final minutes = _ratioToDouble(values[1]);
//     final seconds = _ratioToDouble(values[2]);
//     double decimal = degrees + (minutes / 60) + (seconds / 3600);

//     final ref = refTag?.printable.trim().toUpperCase();
//     if (ref == 'S' || ref == 'W') decimal = -decimal;
//     return decimal;
//   }

//   double _ratioToDouble(Object value) {
//     if (value is exif_dart.Ratio) return value.toDouble();
//     if (value is num) return value.toDouble();
//     return 0.0;
//   }

//   Future<void> _captureGps() async {
//     gpsLoading.value = true;
//     try {
//       final permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         final requested = await Geolocator.requestPermission();
//         if (requested == LocationPermission.denied ||
//             requested == LocationPermission.deniedForever) {
//           gpsError.value = 'Location permission denied.';
//           return;
//         }
//       }

//       final LocationSettings settings = Platform.isAndroid
//           ? AndroidSettings(
//               accuracy: LocationAccuracy.bestForNavigation,
//               forceLocationManager: true,
//               timeLimit: const Duration(seconds: 15),
//               intervalDuration: Duration.zero,
//             )
//           : const LocationSettings(
//               accuracy: LocationAccuracy.bestForNavigation,
//               timeLimit: Duration(seconds: 15),
//             );

//       final position = await Geolocator.getCurrentPosition(
//         locationSettings: settings,
//       );

//       gpsLatitude.value = position.latitude;
//       gpsLongitude.value = position.longitude;
//       gpsAltitude.value = position.altitude;
//       gpsAccuracy.value = position.accuracy;
//       hasGps.value = true;
//     } catch (e) {
//       gpsError.value = 'GPS error: $e';
//     } finally {
//       gpsLoading.value = false;
//     }
//   }

//   void clearImage() {
//     capturedImage.value = null;
//     allAttributes.value = {};
//     gpsLatitude.value = 0.0;
//     gpsLongitude.value = 0.0;
//     gpsAltitude.value = 0.0;
//     gpsAccuracy.value = 0.0;
//     hasGps.value = false;
//     gpsError.value = '';
//     exifLatitude.value = 0.0;
//     exifLongitude.value = 0.0;
//     exifAltitude.value = 0.0;
//     hasExifGps.value = false;
//   }
// }

import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:gal/gal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class HomeController extends GetxController {
  late CameraController cameraController;
  final RxBool isCameraReady = false.obs;

  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxDouble accuracy = 0.0.obs;

  final RxString captureTime = ''.obs;

  final RxString locationName = ''.obs;

  final Rx<File?> capturedImage = Rx<File?>(null);
  final RxBool showPreview = false.obs;

  late DateTime _captureMoment;

  @override
  void onInit() {
    super.onInit();
    initCamera();
    updateGps();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize();
    isCameraReady.value = true;
  }

  Future<void> updateGps() async {
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
        accuracy.value = pos.accuracy;
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
      accuracy.value = pos.accuracy;
    }

    try {
      final placemarks = await placemarkFromCoordinates(
        latitude.value,
        longitude.value,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        locationName.value =
            "${p.subLocality ?? ''}, ${p.locality ?? ''}, ${p.administrativeArea ?? ''}"
                .replaceAll(', ,', ',')
                .trim();
      }
    } catch (e) {
      locationName.value = "Unknown location";
    }
  }

  Future<void> capturePhoto() async {
    _captureMoment = DateTime.now();

    captureTime.value = DateFormat(
      'dd MMM yyyy HH:mm:ss',
    ).format(_captureMoment);

    await updateGps();

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

    await stampImage(file);

    capturedImage.value = null;
    showPreview.value = false;

    Get.snackbar("Saved", "Image captured & saved to gallery");
  }

  Future<void> stampImage(File file) async {
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

    final dir = Directory('/storage/emulated/0/DCIM/GPSCamera');

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final fileName = 'GPS_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final savedFile = File('${dir.path}/$fileName');
    await savedFile.writeAsBytes(Uint8List.fromList(output));

    await Gal.putImage(savedFile.path);
  }
}
