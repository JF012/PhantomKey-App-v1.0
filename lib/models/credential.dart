import 'dart:convert';
import '../utils/constants.dart';

// ============================================================
// MODELO DE DATOS - Representa una credencial almacenada
// ============================================================

class Credential {
  final String id;           // ID único (UUID)
  final String title;        // Nombre del servicio (ej: "Instagram")
  final String username;     // Usuario o email
  final String password;     // Contraseña (se almacena cifrada)
  final String? url;         // URL del servicio (opcional)
  final String? notes;       // Notas adicionales (opcional)
  final CredentialCategory category; // Categoría
  final DateTime createdAt;  // Fecha de creación
  final DateTime updatedAt;  // Última modificación

  Credential({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    this.url,
    this.notes,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convertir a JSON para almacenar
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'username': username,
        'password': password,
        'url': url,
        'notes': notes,
        'category': category.index,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  // Crear desde JSON al recuperar
  factory Credential.fromJson(Map<String, dynamic> json) => Credential(
        id: json['id'],
        title: json['title'],
        username: json['username'],
        password: json['password'],
        url: json['url'],
        notes: json['notes'],
        category: CredentialCategory.values[json['category']],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  // Serializar lista completa a JSON string
  static String encodeList(List<Credential> credentials) =>
      jsonEncode(credentials.map((c) => c.toJson()).toList());

  // Deserializar lista desde JSON string
  static List<Credential> decodeList(String jsonString) {
    final List<dynamic> list = jsonDecode(jsonString);
    return list.map((item) => Credential.fromJson(item)).toList();
  }

  // Crear copia con modificaciones
  Credential copyWith({
    String? title,
    String? username,
    String? password,
    String? url,
    String? notes,
    CredentialCategory? category,
  }) =>
      Credential(
        id: id,
        title: title ?? this.title,
        username: username ?? this.username,
        password: password ?? this.password,
        url: url ?? this.url,
        notes: notes ?? this.notes,
        category: category ?? this.category,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
}
