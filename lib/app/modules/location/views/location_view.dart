import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';

class LocationView extends GetView<LocationController> {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        title: const Text('GPS Location'),
        centerTitle: true,
        actions: [
          Obx(() => controller.hasLocation.value
              ? IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Clear',
                  onPressed: controller.clear,
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Getting GPS location...'),
                SizedBox(height: 8),
                Text(
                  'Make sure you are outdoors\nfor the best GPS signal.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          );
        }

        if (!controller.hasLocation.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_searching,
                      size: 80, color: Colors.green.shade200),
                  const SizedBox(height: 20),
                  const Text(
                    'Tap the button to get your\ncurrent GPS position',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Go outdoors for the best satellite reception.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                  if (controller.errorMessage.value.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                              color: Colors.red.shade800, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.green.shade200),
                ),
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.gps_fixed,
                              color: Colors.green.shade700, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'GPS Position',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      _DataRow(
                          label: 'Latitude',
                          value: controller.latitude.value.toStringAsFixed(7)),
                      const SizedBox(height: 8),
                      _DataRow(
                          label: 'Longitude',
                          value: controller.longitude.value.toStringAsFixed(7)),
                      const SizedBox(height: 8),
                      _DataRow(
                          label: 'Altitude',
                          value:
                              '${controller.altitude.value.toStringAsFixed(1)} m'),
                      const SizedBox(height: 8),
                      _DataRow(
                          label: 'Accuracy',
                          value:
                              '${controller.accuracy.value.toStringAsFixed(0)} m'),
                      if (controller.speed.value > 0) ...[
                        const SizedBox(height: 8),
                        _DataRow(
                            label: 'Speed',
                            value:
                                '${(controller.speed.value * 3.6).toStringAsFixed(1)} km/h'),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.getCurrentLocation,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Refresh Location'),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() => FloatingActionButton.extended(
            onPressed: controller.isLoading.value
                ? null
                : controller.getCurrentLocation,
            icon: const Icon(Icons.gps_fixed),
            label: Text(controller.hasLocation.value
                ? 'Update Location'
                : 'Get Location'),
            backgroundColor: Colors.green.shade400,
          )),
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;
  const _DataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
