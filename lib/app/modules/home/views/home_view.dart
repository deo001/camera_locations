// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:profiling_tool/app/modules/register_farmer/controllers/camera_controller.dart';

// class CameraWidgetView extends GetView<CameraWidgetController> {
//   const CameraWidgetView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         if (controller.isCameraError.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.error_outline, size: 60, color: Colors.red),
//                 const SizedBox(height: 16),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                   child: Text(
//                     "Camera Error:\n${controller.cameraErrorMessage.value}",
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton.icon(
//                   onPressed: () => controller.initCamera(),
//                   icon: const Icon(Icons.refresh),
//                   label: const Text("Retry"),
//                 ),
//                 const SizedBox(height: 12),
//                 TextButton(
//                   onPressed: () => Get.back(),
//                   child: const Text("Go Back"),
//                 ),
//               ],
//             ),
//           );
//         }

//         if (!controller.isCameraReady.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.showPreview.value &&
//             controller.capturedImage.value != null) {
//           return _buildPreview(context);
//         }

//         return _buildCamera(context);
//       }),
//     );
//   }

//   Widget _buildCamera(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: CameraPreview(controller.cameraController),
//         ),

//         /// DARK OVERLAY TOP
//         SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withValues(alpha: 0.55),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Obx(
//                   () => Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         children: const [
//                           Icon(
//                             Icons.location_on,
//                             color: Colors.redAccent,
//                             size: 20,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             "Current Location",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         controller.locationName.value.isEmpty
//                             ? "Fetching location..."
//                             : controller.locationName.value,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               "Lat: ${controller.latitude.value.toStringAsFixed(6)}",
//                               style: const TextStyle(color: Colors.white70),
//                             ),
//                           ),
//                           Expanded(
//                             child: Text(
//                               "Lng: ${controller.longitude.value.toStringAsFixed(6)}",
//                               style: const TextStyle(color: Colors.white70),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         "Accuracy: ±${controller.accuracy.value.toStringAsFixed(1)} m",
//                         style: const TextStyle(color: Colors.white70),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         "Capture Time: ${controller.captureTime.value}",
//                         style: const TextStyle(color: Colors.white70),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),

//         /// BOTTOM CONTROLS
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             height: 170,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.transparent,
//                   Colors.black.withValues(alpha: 0.9),
//                 ],
//               ),
//             ),
//             child: Center(
//               child: GestureDetector(
//                 onTap: controller.capturePhoto,
//                 child: Container(
//                   width: 85,
//                   height: 85,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: Colors.white,
//                       width: 6,
//                     ),
//                   ),
//                   child: Center(
//                     child: Container(
//                       width: 65,
//                       height: 65,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPreview(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.file(
//               controller.capturedImage.value!,
//               fit: BoxFit.contain,
//             ),
//           ),

//           /// TOP INFO
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withValues(alpha: 0.6),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Obx(
//                   () => Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         controller.captureTime.value,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         controller.locationName.value,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         "Latitude : ${controller.latitude.value.toStringAsFixed(6)}",
//                         style: const TextStyle(color: Colors.white70),
//                       ),
//                       Text(
//                         "Longitude : ${controller.longitude.value.toStringAsFixed(6)}",
//                         style: const TextStyle(color: Colors.white70),
//                       ),
//                       Text(
//                         "Accuracy : ±${controller.accuracy.value.toStringAsFixed(1)} m",
//                         style: const TextStyle(color: Colors.white70),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           /// BOTTOM BUTTONS
//           Positioned(
//             bottom: 40,
//             left: 20,
//             right: 20,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red.shade700,
//                       padding: const EdgeInsets.symmetric(vertical: 18),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                     onPressed: controller.discardPhoto,
//                     icon: const Icon(Icons.close, color: Colors.white),
//                     label: const Text(
//                       "Retake",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green.shade700,
//                       padding: const EdgeInsets.symmetric(vertical: 18),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                     onPressed: () async {
//                       await controller.confirmSave();

//                       Get.back(result: {
//                         'imageBase64': controller.capturedImageBase64.value,
//                         'latitude':
//                             controller.latitude.value.toStringAsFixed(20),
//                         'longitude':
//                             controller.longitude.value.toStringAsFixed(20),
//                       });
//                     },
//                     icon: const Icon(Icons.check, color: Colors.white),
//                     label: const Text(
//                       "Use Photo",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:camera_locations/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const Color _accentGreen = Color(0xFF43A047);
  static const Color _accentRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isCameraError.value) {
          return _buildError(context);
        }

        if (!controller.isCameraReady.value) {
          return _buildLoading();
        }

        if (controller.showPreview.value &&
            controller.capturedImage.value != null) {
          return _buildPreview(context);
        }

        return _buildCamera(context);
      }),
    );
  }

  // ---------------------------------------------------------------------
  // Loading
  // ---------------------------------------------------------------------
  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: _accentGreen,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            "Starting camera...",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Error
  // ---------------------------------------------------------------------
  Widget _buildError(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _accentRed.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error_outline,
                    size: 44, color: _accentRed),
              ),
              const SizedBox(height: 18),
              const Text(
                "Camera Error",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                controller.cameraErrorMessage.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => controller.initCamera(),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Go Back",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Camera (live)
  // ---------------------------------------------------------------------
  Widget _buildCamera(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: CameraPreview(controller.cameraController)),
        _topGradient(),
        _bottomGradient(),
        Positioned(
          top: 56,
          left: 16,
          right: 16,
          child: Obx(
            () => _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: _accentGreen, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          controller.locationName.value.isEmpty
                              ? "Detecting location..."
                              : controller.locationName.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  _infoRow(
                    icon: Icons.my_location,
                    text:
                        "Lat: ${controller.latitude.value.toStringAsFixed(6)}",
                  ),
                  const SizedBox(height: 4),
                  _infoRow(
                    icon: Icons.my_location,
                    text:
                        "Lng: ${controller.longitude.value.toStringAsFixed(6)}",
                  ),
                  const SizedBox(height: 4),
                  _infoRow(
                    icon: Icons.gps_fixed,
                    text:
                        "Accuracy: ±${controller.accuracy.value.toStringAsFixed(1)} m",
                  ),
                  const SizedBox(height: 4),
                  _infoRow(
                    icon: Icons.access_time,
                    text: controller.captureTime.value.isEmpty
                        ? "Not captured yet"
                        : controller.captureTime.value,
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
            child: GestureDetector(
              onTap: () => controller.capturePhoto(),
              child: Container(
                width: 76,
                height: 76,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _accentGreen,
                        _accentGreen.withValues(alpha: 0.75),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _accentGreen.withValues(alpha: 0.5),
                        blurRadius: 14,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.camera_alt,
                      color: Colors.white, size: 30),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Preview (after capture)
  // ---------------------------------------------------------------------
  Widget _buildPreview(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.file(
            controller.capturedImage.value!,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 24,
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: _accentGreen, size: 15),
                          const SizedBox(width: 6),
                          Text(
                            controller.captureTime.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: _accentGreen, size: 15),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              controller.locationName.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Lat ${controller.latitude.value.toStringAsFixed(5)}",
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Lng ${controller.longitude.value.toStringAsFixed(5)}",
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Accuracy ±${controller.accuracy.value.toStringAsFixed(1)}m",
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 52,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentRed,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          controller.discardPhoto();
                        },
                        icon: const Icon(Icons.refresh, size: 22),
                        label: const Text(
                          "Jaribu Tena",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentGreen,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          await controller.confirmSave();
                          Get.back(result: {
                            'imageBase64': controller.capturedImageBase64.value,
                            'latitude':
                                controller.latitude.value.toStringAsFixed(20),
                            'longitude':
                                controller.longitude.value.toStringAsFixed(20),
                          });
                        },
                        icon: const Icon(Icons.check_circle, size: 22),
                        label: const Text(
                          "Tumia Picha Hii",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Shared bits
  // ---------------------------------------------------------------------
  Widget _topGradient() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Container(
          height: 170,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.55),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomGradient() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Container(
          height: 170,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withValues(alpha: 0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String text,
    Color color = Colors.white,
    double fontSize = 13,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 15, color: _accentGreen),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: fontSize),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
