import 'vcard_web_helper_stub.dart'
    if (dart.library.html) 'vcard_web_helper_web.dart'
    as impl;

Future<String?> presentVCardOnWeb({
  required String fileName,
  required List<int> bytes,
  required String mimeType,
}) {
  return impl.presentVCardOnWeb(
    fileName: fileName,
    bytes: bytes,
    mimeType: mimeType,
  );
}
