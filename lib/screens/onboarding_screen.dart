import 'package:flutter/material.dart';
import 'package:proximyco/theme/theme_extension.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameCtrl = TextEditingController();
  final _postalCodeCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _postalCodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ProximycoTheme>()!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_rounded,
                  size: 80,
                  color: theme.primaryBrand,
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  "Welcome to\nFavor Exchange",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  "Get 120 Root Minutes to start receiving help",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: theme.secondaryTextColor,
                  ),
                ),

                const SizedBox(height: 48),

                // Nickname
                TextFormField(
                  controller: _nicknameCtrl,
                  decoration: InputDecoration(
                    labelText: "Nickname",
                    prefixIcon: Icon(Icons.person, color: theme.primaryBrand),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Please enter a nickname";
                    }
                    if (v.trim().length < 2) {
                      return "Nickname must be at least 2 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Postal code
                TextFormField(
                  controller: _postalCodeCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: "Postal Code (Netherlands)",
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: theme.primaryBrand,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Please enter a postal code";
                    }
                    final regex = RegExp(r'^\d{4}\s?[A-Z]{2}$');
                    return regex.hasMatch(v.trim())
                        ? null
                        : "Invalid Dutch postal code (e.g., 1234 AB)";
                  },
                ),

                const SizedBox(height: 32),

                // Submit button
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryBrand,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
