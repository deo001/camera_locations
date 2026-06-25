// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/home_controller.dart';

// class HomeView extends GetView<HomeController> {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue.shade100,
//         title: const Text('Camera Locations'),
//         centerTitle: true,
//         actions: [
//           Obx(
//             () => controller.capturedImage.value != null
//                 ? IconButton(
//                     icon: const Icon(Icons.refresh),
//                     tooltip: 'Clear',
//                     onPressed: controller.clearImage,
//                   )
//                 : const SizedBox.shrink(),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 16),
//                 Text('Taking photo & getting GPS...'),
//               ],
//             ),
//           );
//         }

//         if (controller.capturedImage.value == null) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.camera_alt_outlined,
//                     size: 80, color: Colors.blue.shade200),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Take a photo to see its location',
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 8),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: Text(
//                     'GPS coordinates will be captured in real-time at the moment you take the photo.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 13, color: Colors.grey),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               SizedBox(
//                 height: context.width * 0.5,
//                 width: context.width * 0.5,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.file(
//                     controller.capturedImage.value!,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Obx(() => _GpsCard(
//                     hasGps: controller.hasGps.value,
//                     gpsLoading: controller.gpsLoading.value,
//                     latitude: controller.gpsLatitude.value,
//                     longitude: controller.gpsLongitude.value,
//                     altitude: controller.gpsAltitude.value,
//                     accuracy: controller.gpsAccuracy.value,
//                     error: controller.gpsError.value,
//                   )),
//               const SizedBox(height: 12),
//               Obx(() => _ExifGpsCard(
//                     hasExifGps: controller.hasExifGps.value,
//                     latitude: controller.exifLatitude.value,
//                     longitude: controller.exifLongitude.value,
//                     altitude: controller.exifAltitude.value,
//                   )),
//               const SizedBox(height: 12),
//               Obx(() => _ExifCard(
//                     attributes: controller.allAttributes.value,
//                   )),
//             ],
//           ),
//         );
//       }),
//       floatingActionButton: Obx(
//         () => Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             FloatingActionButton.small(
//               heroTag: 'location',
//               onPressed: () => Get.toNamed('/location'),
//               backgroundColor: Colors.green.shade400,
//               child: const Icon(Icons.gps_fixed),
//             ),
//             const SizedBox(height: 12),
//             FloatingActionButton.extended(
//               heroTag: 'camera',
//               onPressed:
//                   controller.isLoading.value ? null : controller.takePhoto,
//               icon: const Icon(Icons.camera_alt),
//               label: Text(
//                 controller.capturedImage.value == null
//                     ? 'Take Photo'
//                     : 'Retake',
//               ),
//               backgroundColor: Colors.blue.shade400,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── GPS card (real-time, not from EXIF) ─────────────────────────────────────

// class _GpsCard extends StatelessWidget {
//   final bool hasGps;
//   final bool gpsLoading;
//   final double latitude;
//   final double longitude;
//   final double altitude;
//   final double accuracy;
//   final String error;

//   const _GpsCard({
//     required this.hasGps,
//     required this.gpsLoading,
//     required this.latitude,
//     required this.longitude,
//     required this.altitude,
//     required this.accuracy,
//     required this.error,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (gpsLoading && !hasGps) {
//       return Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: BorderSide(color: Colors.amber.shade200),
//         ),
//         color: Colors.amber.shade50,
//         child: const Padding(
//           padding: EdgeInsets.all(16),
//           child: Row(
//             children: [
//               SizedBox(
//                 width: 16,
//                 height: 16,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               ),
//               SizedBox(width: 12),
//               Text('Getting GPS position...',
//                   style: TextStyle(fontSize: 13)),
//             ],
//           ),
//         ),
//       );
//     }

//     if (!hasGps) {
//       if (error.isNotEmpty) {
//         return Card(
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//             side: BorderSide(color: Colors.red.shade200),
//           ),
//           color: Colors.red.shade50,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Icon(Icons.gps_off, color: Colors.red.shade700, size: 20),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(error,
//                       style: TextStyle(
//                           color: Colors.red.shade800, fontSize: 13)),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//       return const SizedBox.shrink();
//     }

//     final color = accuracy <= 5
//         ? Colors.green
//         : accuracy <= 10
//             ? Colors.amber
//             : Colors.orange;

//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: color.shade200),
//       ),
//       color: color.shade50,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.gps_fixed, color: color.shade700, size: 20),
//                 const SizedBox(width: 8),
//                 Text(
//                   'GPS Position',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15,
//                     color: color.shade800,
//                   ),
//                 ),
//                 const Spacer(),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: color.shade100,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     '\u00b1${accuracy.toStringAsFixed(0)}m',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 13,
//                       color: color.shade900,
//                       fontFamily: 'monospace',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(height: 20),
//             _Row(label: 'Latitude', value: latitude.toStringAsFixed(7)),
//             const SizedBox(height: 6),
//             _Row(label: 'Longitude', value: longitude.toStringAsFixed(7)),
//             const SizedBox(height: 6),
//             _Row(
//                 label: 'Altitude',
//                 value: '${altitude.toStringAsFixed(1)} m'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── EXIF-embedded GPS card (extracted from the photo file itself) ──────────

// class _ExifGpsCard extends StatelessWidget {
//   final bool hasExifGps;
//   final double latitude;
//   final double longitude;
//   final double altitude;

//   const _ExifGpsCard({
//     required this.hasExifGps,
//     required this.latitude,
//     required this.longitude,
//     required this.altitude,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (!hasExifGps) {
//       return Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: BorderSide(color: Colors.grey.shade300),
//         ),
//         color: Colors.grey.shade50,
//         child: const Padding(
//           padding: EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Icon(Icons.location_off, color: Colors.grey, size: 20),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   "No GPS data embedded in this photo's EXIF.",
//                   style: TextStyle(fontSize: 13, color: Colors.grey),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.purple.shade200),
//       ),
//       color: Colors.purple.shade50,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.image_search,
//                     color: Colors.purple.shade700, size: 20),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Photo Location (from EXIF)',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15,
//                     color: Colors.purple.shade800,
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(height: 20),
//             _Row(label: 'Latitude', value: latitude.toStringAsFixed(7)),
//             const SizedBox(height: 6),
//             _Row(label: 'Longitude', value: longitude.toStringAsFixed(7)),
//             const SizedBox(height: 6),
//             _Row(
//                 label: 'Altitude',
//                 value: '${altitude.toStringAsFixed(1)} m'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Row extends StatelessWidget {
//   final String label;
//   final String value;
//   const _Row({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label,
//             style: const TextStyle(color: Colors.grey, fontSize: 13)),
//         Text(
//           value,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//             fontFamily: 'monospace',
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ── EXIF data card ───────────────────────────────────────────────────────────

// class _ExifCard extends StatelessWidget {
//   final Map<String, Object> attributes;
//   const _ExifCard({required this.attributes});

//   @override
//   Widget build(BuildContext context) {
//     if (attributes.isEmpty) return const SizedBox.shrink();

//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.blue.shade200),
//       ),
//       color: Colors.blue.shade50,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.info, color: Colors.blue.shade700, size: 20),
//                 const SizedBox(width: 8),
//                 Text(
//                   'EXIF Metadata',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15,
//                     color: Colors.blue.shade800,
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(height: 20),
//             ...attributes.entries.map(
//               (e) => Padding(
//                 padding: const EdgeInsets.only(bottom: 4),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: 140,
//                       child: Text(
//                         '${e.key}:',
//                         style: const TextStyle(
//                             color: Colors.grey, fontSize: 12),
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         e.value.toString(),
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                           fontFamily: 'monospace',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (!controller.isCameraReady.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.showPreview.value && controller.capturedImage.value != null) {
          return _buildPreview(context);
        }

        return _buildCamera(context);
      }),
    );
  }

  Widget _buildCamera(BuildContext context) {
    return Stack(
      children: [
        CameraPreview(controller.cameraController),

        Positioned(
          top: 60,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location: ${controller.locationName.value}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Lat: ${controller.latitude.value}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Lng: ${controller.longitude.value}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Acc: ±${controller.accuracy.value} m",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Time: ${controller.captureTime.value}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton(
              onPressed: () => controller.capturePhoto(),
              child: const Icon(Icons.camera),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.file(
            controller.capturedImage.value!,
            fit: BoxFit.contain,
            color: Colors.black.withValues(alpha: 0.4),
            colorBlendMode: BlendMode.darken,
          ),
        ),

        Positioned(
          top: 60,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.captureTime.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.locationName.value,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Lat: ${controller.latitude.value.toStringAsFixed(6)}",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    "Lng: ${controller.longitude.value.toStringAsFixed(6)}",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    "Acc: ±${controller.accuracy.value.toStringAsFixed(1)} m",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: 'discard',
                backgroundColor: Colors.red.shade700,
                onPressed: () => controller.discardPhoto(),
                child: const Icon(Icons.close),
              ),
              FloatingActionButton(
                heroTag: 'save',
                backgroundColor: Colors.green.shade700,
                onPressed: () => controller.confirmSave(),
                child: const Icon(Icons.check),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
