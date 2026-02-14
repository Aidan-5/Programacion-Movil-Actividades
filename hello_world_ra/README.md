# hello_world_ra

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Hello World AR - Realidad Aumentada con Flutter

Aplicación de demostración de Realidad Aumentada desarrollada con Flutter que permite colocar objetos 3D en el mundo real mediante detección de planos.

## 🚀 Características

- ✅ Detección de planos horizontales (ARCore/ARKit)
- ✅ Colocación de objetos 3D mediante tap en pantalla
- ✅ Gestión de permisos de cámara
- ✅ Interfaz intuitiva con instrucciones en tiempo real
- ✅ Capacidad de eliminar objetos colocados

## 📋 Requisitos Previos

### Herramientas Necesarias
- Flutter SDK (3.0.0 o superior)
- Android Studio / Xcode
- Dispositivo físico con soporte para ARCore (Android) o ARKit (iOS)

### Requisitos del Dispositivo
- **Android**: API 24+ con ARCore instalado
- **iOS**: iOS 11+ con chip A9 o superior

## 🔧 Instalación y Ejecución

### 1. Clonar el repositorio
```bash
git clone <tu-repositorio>
cd hello_world_ra
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Configurar para Android
Asegúrate de tener un dispositivo físico Android conectado con:
- Depuración USB habilitada
- ARCore instalado desde Google Play Store

```bash
flutter run
```

### 4. Configurar para iOS
Conecta un dispositivo iOS físico y ejecuta:

```bash
cd ios
pod install
cd ..
flutter run
```

## 📱 Uso de la Aplicación

1. **Conceder Permisos**: Al iniciar, la app solicitará acceso a la cámara
2. **Detectar Superficie**: Mueve el dispositivo lentamente para escanear el entorno
3. **Colocar Objetos**: Toca la pantalla sobre una superficie detectada para colocar un cubo 3D
4. **Limpiar Escena**: Usa el botón "Limpiar Todo" para eliminar todos los objetos

## 🏗️ Estructura del Proyecto

```
lib/
├── main.dart                  # Punto de entrada y gestión de permisos
└── screens/
    └── ar_view_screen.dart    # Vista principal de Realidad Aumentada
```

## 🔑 Dependencias Principales

- `ar_flutter_plugin`: Plugin de AR multiplataforma
- `permission_handler`: Gestión de permisos del sistema
- `vector_math`: Operaciones matemáticas 3D

## ⚠️ Notas Importantes

- **No funciona en emuladores**: AR requiere sensores físicos
- **ARCore**: Los dispositivos Android deben tener ARCore instalado
- **Permisos**: La cámara debe estar autorizada para usar la app
- **Iluminación**: Funciona mejor en ambientes bien iluminados

## 🐛 Solución de Problemas

### La app no detecta superficies
- Mueve el dispositivo más lentamente
- Apunta a superficies texturizadas (no superficies lisas)
- Verifica que haya buena iluminación

### Error de compilación en Android
- Verifica que `minSdk` sea 24 o superior
- Asegúrate de tener NDK instalado en Android Studio

### Error en iOS
- Verifica que el dispositivo sea compatible (A9+, iOS 11+)
- Revisa que los permisos estén en Info.plist

## 📹 Video de Demostración

[Aquí debe ir el enlace a tu video de demostración mostrando la app funcionando]

## 👨‍💻 Desarrollo

Desarrollado como proyecto de práctica para validar configuración de entorno AR con Flutter.

**Tecnologías**: Flutter, ARCore, ARKit, Dart

---

## 📄 Licencia

Este proyecto es con fines educativos.