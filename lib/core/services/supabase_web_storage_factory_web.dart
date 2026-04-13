// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import 'package:supabase_flutter/supabase_flutter.dart';

final Map<String, String> _memoryStorage = <String, String>{};

bool _canUseLocalStorage = true;
bool _localStorageProbeDone = false;

bool _hasStorageAccess() {
  if (_localStorageProbeDone) return _canUseLocalStorage;
  _localStorageProbeDone = true;

  try {
    const probeKey = '__taploop_storage_probe__';
    html.window.localStorage[probeKey] = '1';
    html.window.localStorage.remove(probeKey);
    _canUseLocalStorage = true;
  } catch (_) {
    _canUseLocalStorage = false;
  }

  return _canUseLocalStorage;
}

String? _readValue(String key) {
  if (_hasStorageAccess()) {
    try {
      return html.window.localStorage[key];
    } catch (_) {
      _canUseLocalStorage = false;
    }
  }
  return _memoryStorage[key];
}

Future<void> _writeValue(String key, String value) async {
  if (_hasStorageAccess()) {
    try {
      html.window.localStorage[key] = value;
      return;
    } catch (_) {
      _canUseLocalStorage = false;
    }
  }
  _memoryStorage[key] = value;
}

Future<void> _removeValue(String key) async {
  if (_hasStorageAccess()) {
    try {
      html.window.localStorage.remove(key);
      return;
    } catch (_) {
      _canUseLocalStorage = false;
    }
  }
  _memoryStorage.remove(key);
}

class _SafeSupabaseLocalStorage extends LocalStorage {
  const _SafeSupabaseLocalStorage({required this.persistSessionKey});

  final String persistSessionKey;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async => _readValue(persistSessionKey) != null;

  @override
  Future<String?> accessToken() async => _readValue(persistSessionKey);

  @override
  Future<void> removePersistedSession() => _removeValue(persistSessionKey);

  @override
  Future<void> persistSession(String persistSessionString) {
    return _writeValue(persistSessionKey, persistSessionString);
  }
}

class _SafePkceStorage extends GotrueAsyncStorage {
  @override
  Future<String?> getItem({required String key}) async => _readValue(key);

  @override
  Future<void> removeItem({required String key}) => _removeValue(key);

  @override
  Future<void> setItem({required String key, required String value}) {
    return _writeValue(key, value);
  }
}

LocalStorage createSafeSupabaseLocalStorage(String persistSessionKey) {
  return _SafeSupabaseLocalStorage(persistSessionKey: persistSessionKey);
}

GotrueAsyncStorage createSafePkceStorage() => _SafePkceStorage();
