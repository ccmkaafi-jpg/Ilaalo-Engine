import 'package:flutter/material.dart';
import 'screens/settings_screen.dart';
import 'services/ilaalo_native_service.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
        ),
        useMaterial3: true,
      ),
      home: const SubscriptionScreen(),
    );
  }
}

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _nativeStatus = 'Native Bridge lama tijaabin.';

  Future<void> _testNativeBridge() async {
    setState(() {
      _nativeStatus = 'La xiriiraya Android...';
    });

    try {
      final status =
          await IlaaloNativeService.getPlatformStatus();

      setState(() {
        _nativeStatus =
            '${status['platform']} • ${status['nativeBridge']}';
      });
    } catch (e) {
      setState(() {
        _nativeStatus = 'Bridge error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Ilaalo Engine VIP',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.verified_user_rounded,
              size: 90,
              color: Color(0xFFD0BCFF),
            ),
            const SizedBox(height: 24),
            const Text(
              'Aad u hel adeegyo dhameystiran',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ku raaxayso 10 maalmood oo tijaabo bilaash ah '
              '(Free Trial) ka hor intaanan billawgin \$10/bishiiba.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2930),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD0BCFF),
                  width: 1.5,
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    '10 Maalmood Free Trial',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD0BCFF),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$10 / Bishiiba',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Ka baajiso wakhtigaad doonto',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Native Bridge status
            Text(
              _nativeStatus,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _testNativeBridge,
                child: const Text(
                  'Tijaabi Native Bridge',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD0BCFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Biloow 10-ka Maalmood ee Bilaashka ah',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
