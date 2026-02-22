import 'dart:io';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/visit_model.dart';
import '../../widgets/detail_row.dart';
import '../../widgets/sync_status_badge.dart';

class VisitDetailScreen extends StatelessWidget {
  final VisitModel visit;

  const VisitDetailScreen({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Visit Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: SyncStatusBadge(
                isSynced: visit.isSynced,
                textColor: Colors.white,
                borderColor: Colors.white,
                backgroundColor: Colors.white.withOpacity(0.15),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VisitPhoto(imagePath: visit.imagePath),

            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visit.farmerName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 14, color: Color(0xFF9E9E9E)),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('EEEE, dd MMMM yyyy · hh:mm a')
                            .format(visit.visitDate),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 16),
                  DetailRow(
                    icon: Icons.location_city_outlined,
                    label: 'Village',
                    value: visit.village,
                  ),
                  DetailRow(
                    icon: Icons.grass_outlined,
                    label: 'Crop Type',
                    value: visit.cropType,
                  ),
                  DetailRow(
                    icon: Icons.notes_outlined,
                    label: 'Notes',
                    value: visit.notes?.isNotEmpty == true
                        ? visit.notes!
                        : 'No notes added',
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.location_on_rounded,
                              color: AppTheme.primaryColor, size: 18),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'GPS Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _LiveMapView(
                    latitude: visit.latitude,
                    longitude: visit.longitude,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.my_location_rounded,
                              color: AppTheme.primaryColor, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Lat: ${visit.latitude.toStringAsFixed(6)}   |   Long: ${visit.longitude.toStringAsFixed(6)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF424242),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _VisitPhoto extends StatelessWidget {
  final String imagePath;
  const _VisitPhoto({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) return _placeholder();

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Shimmer.fromColors(
            baseColor: const Color(0xFFE0E0E0),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              width: double.infinity,
              height: 250,
              color: Colors.white,
            ),
          );
        },
        errorBuilder: (context, error, stack) => _placeholder(),
      );
    }

    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 250,
      color: const Color(0xFFE8F5E9),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported_outlined,
              size: 52, color: Color(0xFF81C784)),
          SizedBox(height: 8),
          Text(
            'Image not available',
            style: TextStyle(color: Color(0xFF9E9E9E)),
          ),
        ],
      ),
    );
  }
}

class _LiveMapView extends StatelessWidget {
  final double latitude;
  final double longitude;

  const _LiveMapView({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    final LatLng visitLocation = LatLng(latitude, longitude);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
      child: SizedBox(
        height: 220,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: visitLocation,
            initialZoom: 13,
            minZoom: 5,
            maxZoom: 18,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.field_visit_logger',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: visitLocation,
                  width: 48,
                  height: 48,
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}