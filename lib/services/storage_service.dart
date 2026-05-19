import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/credential.dart';
import 'crypto_service.dart';

// ============================================================
// SERVICIO DE ALMACENAMIENTO - Usa flutter_secure_storage
// para guardar credenciales cifradas en Keychain/Keystore
// ============================================================

class StorageService {
  // Instancia del almacenamiento seguro del dispositivo
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Clave donde se guardan todas las credenciales
  static const String _credentialsKey = 'phantom_key_credentials';

  final CryptoService _crypto = CryptoService();

  // ---- GUARDAR TODAS LAS CREDENCIALES ----
  // Cifra la lista completa antes de almacenar
  Future<void> saveCredentials(List<Credential> credentials) async {
    final jsonString = Credential.encodeList(credentials);
    final encrypted = _crypto.encryptText(jsonString);
    await _storage.write(key: _credentialsKey, value: encrypted);
  }

  // ---- CARGAR TODAS LAS CREDENCIALES ----
  // Descifra y deserializa la lista almacenada
  Future<List<Credential>> loadCredentials() async {
    try {
      final encrypted = await _storage.read(key: _credentialsKey);
      if (encrypted == null || encrypted.isEmpty) return [];
      final jsonString = _crypto.decryptText(encrypted);
      return Credential.decodeList(jsonString);
    } catch (e) {
      // Si hay error al cargar, retornar lista vacía
      return [];
    }
  }

  // ---- LIMPIAR TODOS LOS DATOS ----
  Future<void> clearAll() async {
    await _storage.delete(key: _credentialsKey);
  }
}
