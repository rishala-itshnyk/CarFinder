import 'package:flutter/material.dart';

class BottomImage extends StatelessWidget {
  final String imageUrl;

  const BottomImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, errorObject, stackTrace) {
          return Container(
            color: Colors.blueGrey.shade900,
            alignment: Alignment.center,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_car,
                  size: 56,
                  color: Colors.white70,
                ),
                SizedBox(height: 6),
                Text(
                  'Tesla Model 3 / Copart Lot',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
