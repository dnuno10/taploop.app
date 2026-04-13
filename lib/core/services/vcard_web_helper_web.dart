// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;

bool _isIOSMobileSafari() {
  final ua = html.window.navigator.userAgent;
  final vendor = html.window.navigator.vendor ?? '';
  final isIOS =
      RegExp(r'iPhone|iPad|iPod', caseSensitive: false).hasMatch(ua) ||
      (html.window.navigator.platform == 'MacIntel' &&
          (html.window.navigator.maxTouchPoints ?? 0) > 1);
  final isSafari =
      ua.contains('Safari') &&
      !ua.contains('CriOS') &&
      !ua.contains('FxiOS') &&
      !ua.contains('EdgiOS') &&
      !ua.contains('OPiOS') &&
      !ua.contains('GSA');

  return isIOS && vendor == 'Apple Computer, Inc.' && isSafari;
}

Future<String?> presentVCardOnWeb({
  required String fileName,
  required List<int> bytes,
  required String mimeType,
}) async {
  try {
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..type = mimeType
      ..style.display = 'none';

    if (_isIOSMobileSafari()) {
      anchor
        ..target = '_self'
        ..rel = 'noopener';
    } else {
      anchor.download = fileName;
    }

    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();

    unawaited(
      Future<void>.delayed(
        const Duration(seconds: 2),
        () => html.Url.revokeObjectUrl(url),
      ),
    );
    return _isIOSMobileSafari() ? 'opened' : 'downloaded';
  } catch (_) {
    return null;
  }
}
