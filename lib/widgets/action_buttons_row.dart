import 'package:flutter/material.dart';

class ActionButtonsRow extends StatelessWidget {
  final String primaryText;
  final String secondaryText;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  const ActionButtonsRow({
    super.key,
    required this.primaryText,
    required this.secondaryText,
    required this.onPrimary,
    required this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.grey.shade400),
            ),
            onPressed: onPrimary,
            child: Text(
              primaryText,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.grey.shade400),
            ),
            onPressed: onSecondary,
            child: Text(
              secondaryText,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
