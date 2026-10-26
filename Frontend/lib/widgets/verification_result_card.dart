import 'package:flutter/material.dart';

class VerificationResultCard extends StatelessWidget {
  final String status;
  final String explanation;

  const VerificationResultCard({
    Key? key,
    required this.status,
    required this.explanation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Détermination des couleurs selon le niveau de risque
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData statusIcon;

    switch (status.toUpperCase()) {
      case "SÉCURISÉ":
        backgroundColor = Colors.green.shade50;
        borderColor = Colors.green.shade200;
        textColor = Colors.green.shade800;
        statusIcon = Icons.verified_user_outlined;
        break;
      case "SUSPECT":
        backgroundColor = Colors.orange.shade50;
        borderColor = Colors.orange.shade200;
        textColor = Colors.orange.shade800;
        statusIcon = Icons.warning_amber_outlined;
        break;
      case "DANGEREUX":
        backgroundColor = Colors.red.shade50;
        borderColor = Colors.red.shade200;
        textColor = Colors.red.shade800;
        statusIcon = Icons.dangerous_outlined;
        break;
      default:
        backgroundColor = Colors.grey.shade50;
        borderColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
        statusIcon = Icons.info_outline;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, color: textColor, size: 28),
              const SizedBox(width: 12),
              Text(
                "Niveau : $status",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          Text(
            explanation,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}