import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  final String playerName;

  const TypingIndicator({super.key, required this.playerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "$playerName is typing...",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
