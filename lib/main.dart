import 'package:flutter/material.dart';

void main() {
  runApp(const IlaaloEngineApp());
}

class IlaaloEngineApp extends StatelessWidget {
  const IlaaloEngineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ilaalo Engine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      home: const SubscriptionScreen(),
    );
  }
}

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Ilaalo Engine VIP', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user_rounded, size: 90, color: Color(0xFFD0BCFF)),
            const SizedBox(height: 24),
            const Text(
              'Aad u hel adeegyo dhameystiran',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ku raaxayso 10 maalmood oo tijaabo bilaash ah (Free Trial) ka hor intaanan billawgin \$10/bishiiba.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2930),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD0BCFF), width: 1.5),
              ),
              child: const Column(
                children: [
                  Text(
                    '10 Maalmood Free Trial',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD0BCFF)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$10 / Bishiiba',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    'Ka baajiso wakhtigaad doonto',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD0BCFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                child: const Text(
                  'Biloow 10-ka Maalmood ee Bilaashka ah',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
