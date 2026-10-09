import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _pin1Controller = TextEditingController();
  final _pin2Controller = TextEditingController();
  final _bankPinController = TextEditingController();
  final _shortcodeController = TextEditingController(text: '806');

  bool _loading = true;
  bool _saving = false;
  bool _unlocked = false;
  bool _showPin1 = false;
  bool _showPin2 = false;
  bool _showBankPin = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final account = await _storage.read(key: 'ilaalo_account_number');
      final shortcode = await _storage.read(key: 'ilaalo_shortcode');

      if (!mounted) return;

      setState(() {
        _accountController.text = account ?? '';
        _shortcodeController.text = shortcode ?? '806';
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings lama akhrin karin. Dib u tijaabi.'),
        ),
      );
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      // Waxaa la kaydinayaa account number-ka iyo shortcode-ka oo keliya.
      // PIN1, PIN2 iyo Bank PIN weli lama kaydinayo.
      await _storage.write(
        key: 'ilaalo_account_number',
        value: _accountController.text.trim(),
      );

      await _storage.write(
        key: 'ilaalo_shortcode',
        value: _shortcodeController.text.trim(),
      );

      _pin1Controller.clear();
      _pin2Controller.clear();
      _bankPinController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Settings waa la kaydiyey. PIN-yada lama kaydin.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kaydintu way fashilantay.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _accountController.dispose();
    _pin1Controller.dispose();
    _pin2Controller.dispose();
    _bankPinController.dispose();
    _shortcodeController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(
    String label, {
    String? helper,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      helperText: helper,
      border: const OutlineInputBorder(),
      suffixIcon: suffixIcon,
    );
  }

  Widget _credentialField({
    required String label,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback toggleVisibility,
    String? helper,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: _unlocked,
        obscureText: !visible,
        keyboardType: TextInputType.number,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        decoration: _decoration(
          label,
          helper: helper,
          suffixIcon: IconButton(
            tooltip: visible ? 'Qari' : 'Muuji',
            onPressed: () {
              if (_unlocked) toggleVisibility();
            },
            icon: Icon(
              visible ? Icons.visibility_off : Icons.visibility,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFFD0BCFF);
    const background = Color(0xFF121212);
    const panel = Color(0xFF242127);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: panel,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Automation Credentials',
                    style: TextStyle(
                      color: purple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _unlocked = !_unlocked);
                    },
                    icon: Icon(
                      _unlocked ? Icons.lock_open : Icons.lock,
                    ),
                    label: Text(
                      _unlocked
                          ? 'Hide Sensitive Fields'
                          : 'Unlock Sensitive Fields',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _accountController,
                    enabled: _unlocked,
                    keyboardType: TextInputType.phone,
                    decoration: _decoration(
                      'Account number',
                      helper: 'Confirm Security PIN to edit.',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Geli lambarka akoonka.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _credentialField(
                    label: 'PIN1',
                    controller: _pin1Controller,
                    visible: _showPin1,
                    toggleVisibility: () {
                      setState(() => _showPin1 = !_showPin1);
                    },
                  ),
                  _credentialField(
                    label: 'PIN2',
                    controller: _pin2Controller,
                    visible: _showPin2,
                    toggleVisibility: () {
                      setState(() => _showPin2 = !_showPin2);
                    },
                  ),
                  _credentialField(
                    label: 'Bank PIN',
                    controller: _bankPinController,
                    visible: _showBankPin,
                    toggleVisibility: () {
                      setState(() => _showBankPin = !_showBankPin);
                    },
                    helper:
                        'Required only for Dara-Salaam Bank deposits. Must be 6 digits.',
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  TextFormField(
                    controller: _shortcodeController,
                    enabled: _unlocked,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: _decoration('Shortcode'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Geli shortcode-ka.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _saving ? null : _saveSettings,
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: const Text('Save Settings'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 12),
                  const Text(
                    'Transfer Controls & Execution',
                    style: TextStyle(
                      color: purple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: panel,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: purple,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Transfer automation is not connected yet.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lacag-dirista tooska ah lama bilaabi karo ilaa '
                          'habka wareejinta iyo xaqiijintiisa la hirgeliyo '
                          'lana tijaabiyo.',
                          style: TextStyle(
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
