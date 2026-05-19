// ============================================================
// LOCALIZACIÓN - Strings en Español e Inglés
// Se accede con: S.of(context).appName
// ============================================================

class AppStrings {
  static bool _isSpanish = true;

  static void setSpanish(bool value) => _isSpanish = value;
  static bool get isSpanish => _isSpanish;

  // ---- GENERAL ----
  static String get appName => 'PhantomKey';
  static String get appSlogan =>
      _isSpanish ? 'Tus contraseñas, invisibles para todos'
                 : 'Your passwords, invisible to everyone';

  // ---- LOCK SCREEN ----
  static String get tapToUnlock =>
      _isSpanish ? 'Toca para desbloquear' : 'Tap to unlock';
  static String get verifying =>
      _isSpanish ? 'Verificando...' : 'Verifying...';
  static String get authFailed =>
      _isSpanish ? 'Autenticación fallida. Intenta de nuevo.'
                 : 'Authentication failed. Try again.';
  static String get faceId => 'Face ID';
  static String get fingerprint =>
      _isSpanish ? 'Huella Digital' : 'Fingerprint';
  static String get unlock =>
      _isSpanish ? 'Desbloquear' : 'Unlock';
  static String get useFaceId =>
      _isSpanish ? 'Usa Face ID para desbloquear'
                 : 'Use Face ID to unlock';
  static String get useFingerprint =>
      _isSpanish ? 'Usa tu huella digital'
                 : 'Use your fingerprint';
  static String get useBiometrics =>
      _isSpanish ? 'Usa biometría para desbloquear'
                 : 'Use biometrics to unlock';
  static String get faceIdReason =>
      _isSpanish ? 'Mira hacia tu dispositivo para desbloquear PhantomKey'
                 : 'Look at your device to unlock PhantomKey';
  static String get fingerprintReason =>
      _isSpanish ? 'Coloca tu dedo en el sensor para desbloquear PhantomKey'
                 : 'Place your finger on the sensor to unlock PhantomKey';
  static String get genericReason =>
      _isSpanish ? 'Desbloquea tu PhantomKey'
                 : 'Unlock your PhantomKey';

  // ---- HOME SCREEN ----
  static String passwordsCount(int count) =>
      _isSpanish ? '$count contraseñas guardadas'
                 : '$count passwords saved';
  static String get searchHint =>
      _isSpanish ? 'Buscar credenciales...' : 'Search credentials...';
  static String get allFilter =>
      _isSpanish ? 'Todas' : 'All';
  static String get noCredentials =>
      _isSpanish ? 'Sin credenciales' : 'No credentials';
  static String get addFirstPassword =>
      _isSpanish ? 'Toca + para agregar tu primera contraseña'
                 : 'Tap + to add your first password';

  // ---- CATEGORÍAS ----
  static String get catSocialMedia =>
      _isSpanish ? 'Redes Sociales' : 'Social Media';
  static String get catWork =>
      _isSpanish ? 'Trabajo' : 'Work';
  static String get catBank =>
      _isSpanish ? 'Banco' : 'Bank';
  static String get catAcademic =>
      _isSpanish ? 'Académico' : 'Academic';

  // ---- DETAIL SCREEN ----
  static String get detail =>
      _isSpanish ? 'Detalle' : 'Detail';
  static String get userEmail =>
      _isSpanish ? 'Usuario / Email' : 'User / Email';
  static String get password =>
      _isSpanish ? 'Contraseña' : 'Password';
  static String get passwordCopied =>
      _isSpanish ? 'Contraseña copiada' : 'Password copied';
  static String get copied =>
      _isSpanish ? 'copiado' : 'copied';
  static String get notes =>
      _isSpanish ? 'Notas' : 'Notes';
  static String get created =>
      _isSpanish ? 'Creada' : 'Created';
  static String get modified =>
      _isSpanish ? 'Modificada' : 'Modified';
  static String get deleteCredential =>
      _isSpanish ? 'Eliminar credencial' : 'Delete credential';
  static String deleteConfirm(String title) =>
      _isSpanish ? '¿Seguro que quieres eliminar "$title"? Esta acción no se puede deshacer.'
                 : 'Are you sure you want to delete "$title"? This action cannot be undone.';
  static String get cancel =>
      _isSpanish ? 'Cancelar' : 'Cancel';
  static String get delete =>
      _isSpanish ? 'Eliminar' : 'Delete';

  // ---- ADD CREDENTIAL SCREEN ----
  static String get newCredential =>
      _isSpanish ? 'Nueva Credencial' : 'New Credential';
  static String get save =>
      _isSpanish ? 'Guardar' : 'Save';
  static String get category =>
      _isSpanish ? 'Categoría' : 'Category';
  static String get serviceTitle =>
      _isSpanish ? 'Título del servicio' : 'Service name';
  static String get serviceTitleHint =>
      _isSpanish ? 'Ej: Instagram, Gmail, Banco...'
                 : 'Ex: Instagram, Gmail, Bank...';
  static String get userOrEmail =>
      _isSpanish ? 'Usuario o Email' : 'User or Email';
  static String get userOrEmailHint =>
      _isSpanish ? 'Ej: usuario@email.com' : 'Ex: user@email.com';
  static String get passwordHint =>
      _isSpanish ? 'Ingresa o genera una contraseña'
                 : 'Enter or generate a password';
  static String get generate =>
      _isSpanish ? 'Generar' : 'Generate';
  static String get urlOptional => 'URL (${_isSpanish ? 'opcional' : 'optional'})';
  static String get urlHint => 'Ej: https://instagram.com';
  static String get notesOptional =>
      _isSpanish ? 'Notas (opcional)' : 'Notes (optional)';
  static String get notesHint =>
      _isSpanish ? 'Información adicional...' : 'Additional info...';
  static String get required =>
      _isSpanish ? 'Campo requerido' : 'Required field';

  // ---- GENERATOR SCREEN ----
  static String get generator =>
      _isSpanish ? 'Generador' : 'Generator';
  static String get copy =>
      _isSpanish ? 'Copiar' : 'Copy';
  static String get configuration =>
      _isSpanish ? 'Configuración' : 'Settings';
  static String get length =>
      _isSpanish ? 'Longitud' : 'Length';
  static String get uppercase =>
      _isSpanish ? 'Mayúsculas (A-Z)' : 'Uppercase (A-Z)';
  static String get lowercase =>
      _isSpanish ? 'Minúsculas (a-z)' : 'Lowercase (a-z)';
  static String get numbers =>
      _isSpanish ? 'Números (0-9)' : 'Numbers (0-9)';
  static String get symbols =>
      _isSpanish ? 'Símbolos (!@#\$%)' : 'Symbols (!@#\$%)';

  // ---- STRENGTH ----
  static String get weak =>
      _isSpanish ? 'Débil' : 'Weak';
  static String get medium =>
      _isSpanish ? 'Media' : 'Medium';
  static String get strong =>
      _isSpanish ? 'Fuerte' : 'Strong';
  static String get veryStrong =>
      _isSpanish ? 'Muy Fuerte' : 'Very Strong';

  // ---- SETTINGS SCREEN ----
  static String get settings =>
      _isSpanish ? 'Ajustes' : 'Settings';
  static String get appearance =>
      _isSpanish ? 'Apariencia' : 'Appearance';
  static String get theme =>
      _isSpanish ? 'Tema' : 'Theme';
  static String get darkMode =>
      _isSpanish ? 'Modo Oscuro' : 'Dark Mode';
  static String get lightMode =>
      _isSpanish ? 'Modo Claro' : 'Light Mode';
  static String get language =>
      _isSpanish ? 'Idioma' : 'Language';
  static String get security =>
      _isSpanish ? 'Seguridad' : 'Security';
  static String get encryption =>
      _isSpanish ? 'Cifrado' : 'Encryption';
  static String get storage =>
      _isSpanish ? 'Almacenamiento' : 'Storage';
  static String get localOnly =>
      _isSpanish ? 'Solo local · Sin servidores externos'
                 : 'Local only · No external servers';
  static String get about =>
      _isSpanish ? 'Acerca de' : 'About';
}
