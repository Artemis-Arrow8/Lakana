import 'package:flutter/material.dart';

/// Badge d'affichage du quota freemium d'analyses gratuites
class FreemiumQuotaBadge extends StatelessWidget {
  final int remainingQuotas;
  final int maxQuotas;
  final VoidCallback? onTapUpgrade;

  const FreemiumQuotaBadge({
    Key? key,
    required this.remainingQuotas,
    this.maxQuotas = 2,
    this.onTapUpgrade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLow = remainingQuotas == 0;

    return GestureDetector(
      onTap: onTapUpgrade,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isLow ? Colors.red.shade50 : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isLow ? Colors.red.shade200 : Colors.blue.shade200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLow ? Icons.lock_clock_outlined : Icons.shield_outlined,
              size: 16,
              color: isLow ? Colors.red.shade700 : Colors.blue.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              "$remainingQuotas/$maxQuotas gratuit(s)",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isLow ? Colors.red.shade700 : Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}