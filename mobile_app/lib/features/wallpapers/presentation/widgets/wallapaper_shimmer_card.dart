import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WallpaperShimmerCard extends StatelessWidget {
  const WallpaperShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: Duration(milliseconds: 1500),
      child: Container(
        width: 130,
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Shimmer image placeholder
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            // Shimmer text placeholder
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
