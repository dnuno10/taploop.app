import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_web_storage_factory_stub.dart'
    if (dart.library.html) 'supabase_web_storage_factory_web.dart'
    as impl;

LocalStorage? createSafeSupabaseLocalStorage(String persistSessionKey) {
  return impl.createSafeSupabaseLocalStorage(persistSessionKey);
}

GotrueAsyncStorage? createSafePkceStorage() {
  return impl.createSafePkceStorage();
}
