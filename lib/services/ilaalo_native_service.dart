import 'package:flutter/services.dart';

class IlaaloNativeService {
  static const MethodChannel _channel =
      MethodChannel('com.ilaalo.engine/native');

  static Future<Map<String, dynamic>> getPlatformStatus() async {
    final result = await _channel.invokeMethod<dynamic>(
      'getPlatformStatus',
    );

    if (result is Map) {
      return Map<String, dynamic>.from(result);
    }

    throw PlatformException(
      code: 'INVALID_RESPONSE',
      message: 'Native bridge wuxuu soo celiyay xog aan la filayn.',
    );
  }
}
