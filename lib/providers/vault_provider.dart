import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/credential.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../utils/app_strings.dart';

// ============================================================
// PROVIDER DEL VAULT - Estado global
// CRUD + filtros + tema + idioma
// ============================================================

class VaultProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final Uuid _uuid = const Uuid();

  List<Credential> _credentials = [];
  CredentialCategory? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = true;
  bool _isUnlocked = false;
  bool _isDarkMode = true;
  bool _isSpanish = true;

  // ---- GETTERS ----
  bool get isLoading => _isLoading;
  bool get isUnlocked => _isUnlocked;
  bool get isDarkMode => _isDarkMode;
  bool get isSpanish => _isSpanish;
  CredentialCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<Credential> get credentials {
    var filtered = _credentials;

    if (_selectedCategory != null) {
      filtered = filtered.where((c) => c.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((c) {
        return c.title.toLowerCase().contains(query) ||
            c.username.toLowerCase().contains(query) ||
            (c.url?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return filtered;
  }

  int get totalCredentials => _credentials.length;

  int countByCategory(CredentialCategory category) =>
      _credentials.where((c) => c.category == category).length;

  // ---- CAMBIAR TEMA ----
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    AppColors.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  // ---- CAMBIAR IDIOMA ----
  void toggleLanguage() {
    _isSpanish = !_isSpanish;
    AppStrings.setSpanish(_isSpanish);
    notifyListeners();
  }

  // ---- DESBLOQUEAR / BLOQUEAR ----
  void unlock() {
    _isUnlocked = true;
    notifyListeners();
  }

  void lock() {
    _isUnlocked = false;
    notifyListeners();
  }

  // ---- CRUD ----
  Future<void> loadCredentials() async {
    _isLoading = true;
    notifyListeners();
    _credentials = await _storage.loadCredentials();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCredential({
    required String title,
    required String username,
    required String password,
    String? url,
    String? notes,
    required CredentialCategory category,
  }) async {
    final now = DateTime.now();
    final credential = Credential(
      id: _uuid.v4(),
      title: title,
      username: username,
      password: password,
      url: url,
      notes: notes,
      category: category,
      createdAt: now,
      updatedAt: now,
    );

    _credentials.add(credential);
    await _storage.saveCredentials(_credentials);
    notifyListeners();
  }

  Future<void> updateCredential(Credential updated) async {
    final index = _credentials.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      _credentials[index] = updated;
      await _storage.saveCredentials(_credentials);
      notifyListeners();
    }
  }

  Future<void> deleteCredential(String id) async {
    _credentials.removeWhere((c) => c.id == id);
    await _storage.saveCredentials(_credentials);
    notifyListeners();
  }

  void setCategory(CredentialCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
