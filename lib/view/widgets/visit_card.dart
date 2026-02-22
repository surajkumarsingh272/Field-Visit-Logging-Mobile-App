import 'dart:io';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/visit_model.dart';
import 'sync_status_badge.dart';

class VisitCard extends StatelessWidget {
  final VisitModel visit;
  final VoidCallback onTap;

  const VisitCard({super.key, required this.visit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _VisitThumbnail(imagePath: visit.imagePath),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visit.farmerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B1B1B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: Color(0xFF757575)),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            '${visit.village} · ${visit.cropType}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF757575),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd MMM yyyy, hh:mm a')
                              .format(visit.visitDate),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                        SyncStatusBadge(isSynced: visit.isSynced),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFBDBDBD)),
            ],
          ),
        ),
      ),
    );
  }
}

class _VisitThumbnail extends StatelessWidget {
  final String imagePath;
  const _VisitThumbnail({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (imagePath.isEmpty) return _placeholder();

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _shimmer();
        },
        errorBuilder: (context, error, stack) => _placeholder(),
      );
    }

    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(file, width: 72, height: 72, fit: BoxFit.cover);
    }

    return _placeholder();
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        width: 72,
        height: 72,
        color: Colors.white,
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 72,
      height: 72,
      color: const Color(0xFFE8F5E9),
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Color(0xFF81C784),
        size: 32,
      ),
    );
  }
}