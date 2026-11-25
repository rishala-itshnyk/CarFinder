import 'dart:io';
import 'package:flutter/services.dart';

class NativeDeviceService {
  static const MethodChannel _bridgeChannel = MethodChannel('carfinder/native_bridge');

  static Future<bool> openRealBrowser(String targetUrl) async {
    try {
      final successResult = await _bridgeChannel.invokeMethod<bool>('openBrowser', {
        'url': targetUrl,
      });
      if (successResult == true) return true;
    } catch (_) {}

    try {
      if (Platform.isMacOS || Platform.isLinux) {
        await Process.run('open', [targetUrl]);
        return true;
      } else if (Platform.isWindows) {
        await Process.run('explorer', [targetUrl]);
        return true;
      }
    } catch (_) {}

    return false;
  }

  static Future<String?> pickDocumentFromGallery() async {
    try {
      final selectedPath = await _bridgeChannel.invokeMethod<String>('openGallery');
      if (selectedPath != null && selectedPath.isNotEmpty) {
        return selectedPath.split('/').last;
      }
    } catch (_) {}

    try {
      if (Platform.isMacOS) {
        final macDialogResult = await Process.run('osascript', [
          '-e',
          'POSIX path of (choose file of type {"public.image", "com.adobe.pdf"} with prompt "Виберіть фото документа")',
        ]);
        final chosenPath = macDialogResult.stdout.toString().trim();
        if (chosenPath.isNotEmpty) {
          return chosenPath.split('/').last;
        }
      }
    } catch (_) {}

    return null;
  }

  static Future<Map<String, String>> fetchCurrentWebDetails() async {
    try {
      final detailsMap = await _bridgeChannel.invokeMethod<Map<dynamic, dynamic>>('getWebViewDetails');
      if (detailsMap != null) {
        return {
          'address': (detailsMap['address'] as String?) ?? '',
          'heading': (detailsMap['heading'] as String?) ?? '',
        };
      }
    } catch (_) {}
    return {
      'address': '',
      'heading': '',
    };
  }
}
