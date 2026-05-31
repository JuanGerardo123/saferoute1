class AppStrings {
  // General
  static const String appName = 'SafeRoute';
  static const String appSlogan = 'Tu ciudad, más segura';

  // Splash
  static const String loading = 'Cargando...';

  // Login
  static const String login = 'Iniciar sesión';
  static const String loginSubtitle = 'Inicia sesión para continuar';
  static const String email = 'Correo electrónico';
  static const String emailHint = 'correo@ejemplo.com';
  static const String password = 'Contraseña';
  static const String passwordHint = '••••••••';
  static const String forgotPassword = '¿Olvidaste tu contraseña?';
  static const String noAccount = '¿No tienes cuenta? ';
  static const String register = 'Regístrate';

  // Registro
  static const String createAccount = 'Crear cuenta';
  static const String createAccountSubtitle = 'Únete a la comunidad SafeRoute';
  static const String username = 'Nombre de usuario';
  static const String usernameHint = 'usuario123';
  static const String confirmPassword = 'Confirmar contraseña';
  static const String alreadyHaveAccount = '¿Ya tienes cuenta? ';

  // Validaciones
  static const String fieldRequired = 'Este campo es obligatorio';
  static const String emailRequired = 'Ingresa tu correo';
  static const String passwordRequired = 'Ingresa tu contraseña';
  static const String passwordMin = 'Mínimo 6 caracteres';
  static const String passwordMismatch = 'Las contraseñas no coinciden';
  static const String usernameRequired = 'Ingresa un nombre de usuario';

  // Mapa
  static const String mapTitle = 'Mapa';
  static const String nearbyIncidents = 'Incidencias cercanas';
  static const String noIncidents = 'No hay incidencias activas cerca.';

  // Nueva incidencia
  static const String reportIncident = 'Reportar incidencia';
  static const String incidentType = 'Tipo de incidencia';
  static const String dangerLevel = 'Nivel de peligro';
  static const String description = 'Descripción';
  static const String descriptionHint = 'Describe el problema brevemente...';
  static const String publishReport = 'Publicar reporte';
  static const String locationDetected = 'Ubicación detectada automáticamente';
  static const String locationCurrent = 'Se usará tu posición actual';
  static const String descriptionRequired =
      'Escribe una descripción del problema.';
  static const String reportSuccess = '¡Reporte publicado correctamente!';

  // Tipos de incidencia
  static const String typeBache = 'Bache';
  static const String typeChoque = 'Choque';
  static const String typeTrafico = 'Tráfico';
  static const String typePeligro = 'Zona peligrosa';

  // Niveles de peligro
  static const String levelBajo = 'Bajo';
  static const String levelMedio = 'Medio';
  static const String levelAlto = 'Alto';

  // Detalle incidencia
  static const String detail = 'Detalle';
  static const String location = 'Ubicación';
  static const String reportedAt = 'Reportado';
  static const String reportedBy = 'Reportado por';
  static const String confirmations = 'usuarios confirmaron';
  static const String alsoSawIt = 'También lo vi';
  static const String markResolved = 'Marcar como resuelta';
  static const String resolvedSuccess = 'Incidencia marcada como resuelta.';
  static const String confirmSuccess = '¡Gracias por confirmar el reporte!';

  // Duplicado
  static const String duplicateTitle = 'Reporte similar encontrado';
  static const String duplicateBody =
      'Ya existe un reporte del mismo tipo a menos de 200m. '
      '¿Quieres confirmarlo en lugar de crear uno nuevo?';
  static const String confirmExisting = 'Confirmar existente';
  static const String cancel = 'Cancelar';

  // Perfil
  static const String profile = 'Perfil';
  static const String safeRouteUser = 'Usuario SafeRoute';
  static const String profileCard1 = 'Contribuyes a hacer tu ciudad más segura';
  static const String profileCard2 =
      'Tus reportes aparecen en el mapa en tiempo real';
  static const String logout = 'Cerrar sesión';

  // Errores
  static const String errorGeneric = 'Ocurrió un error. Intenta de nuevo.';
  static const String errorGpsDisabled =
      'El GPS está desactivado. Actívalo para continuar.';
  static const String errorLocationPermission =
      'Se necesita permiso de ubicación para usar SafeRoute.';
  static const String errorLocationPermanent =
      'Permiso de ubicación denegado permanentemente. Actívalo en configuración.';
}
