# SafeRoute

Aplicación móvil para **Android** que permite reportar y consultar incidencias urbanas en tiempo real sobre un mapa interactivo. Los usuarios pueden avisar sobre baches, choques, tráfico o zonas peligrosas, y la comunidad puede confirmar o marcar como resueltos esos reportes.

## Características

- **Autenticación** con email y contraseña (Firebase Auth)
- **Mapa en tiempo real** con OpenStreetMap y marcadores por incidencia
- **Reportar incidencias** con tipo, nivel de peligro y descripción
- **Detección de duplicados** cercanos (mismo tipo a menos de 200 m)
- **Confirmación comunitaria** de reportes existentes
- **Marcar incidencias como resueltas**
- **Perfil de usuario** con cierre de sesión

## Tecnologías

| Área | Tecnología |
|------|------------|
| Framework | Flutter |
| Backend | Firebase (Auth + Firestore) |
| Mapa | flutter_map + OpenStreetMap |
| Ubicación | geolocator |
| Estado | Provider |

## Requisitos

- Flutter SDK `^3.11.3`
- Android Studio o VS Code con extensiones de Flutter/Dart
- Cuenta de Firebase con el proyecto configurado
- Archivo `android/app/google-services.json` en su lugar

## Instalación

```bash
# Clonar el repositorio
git clone <url-del-repositorio>
cd saferoute

# Instalar dependencias
flutter pub get

# Ejecutar en dispositivo o emulador Android
flutter run
```

## Estructura del proyecto

```
lib/
├── core/           # Tema, rutas y constantes
├── data/           # Modelos, repositorios y servicios
├── features/       # Módulos: auth, map, incidents, profile
├── shared/         # Widgets reutilizables
└── main.dart       # Punto de entrada
```

## Colecciones Firestore

- **`users`** — Perfil del usuario (uid, username, email, createdAt)
- **`incidents`** — Reportes de incidencias con ubicación, tipo, peligro y estado

## Licencia

Proyecto privado — no publicado en pub.dev.
