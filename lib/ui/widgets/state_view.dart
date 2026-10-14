import 'package:flutter/material.dart';

class StateView extends StatelessWidget {
  const StateView({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(width: 42, height: 42, child: CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF6696FF)))
            else
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(color: Color(0xFF1A2942), shape: BoxShape.circle),
                child: Icon(icon, color: const Color(0xFF82A9FF), size: 32),
              ),
            const SizedBox(height: 22),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF9AA8BF), height: 1.5, fontSize: 13)),
            if (!isLoading) ...[
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(buttonLabel),
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF5C8FF0), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
