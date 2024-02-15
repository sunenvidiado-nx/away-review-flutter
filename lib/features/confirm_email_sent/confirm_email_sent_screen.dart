import 'package:away_review/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmEmailSentScreen extends StatelessWidget {
  const ConfirmEmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Image.asset('assets/icon/app-icon.png', height: 100),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'A confirmation email has been sent to your email address. Please verify your email address to continue.',
                style: context.textTheme.titleLarge?.copyWith(height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
