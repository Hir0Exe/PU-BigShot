# 🛍️ BigShot - Plataforma de Ofertas de Supermercados

**BigShot** es una aplicación móvil desarrollada en Flutter que conecta usuarios particulares con supermercados/empresas para descubrir ofertas y promociones en tiempo real.

## 📱 Características Principales

### Para Usuarios Particulares
- ✅ **Feed de Ofertas:** Visualiza todas las ofertas disponibles con prioridad para supermercados seguidos
- 🔍 **Búsqueda y Filtros:** Busca ofertas por texto, categoría y fecha de expiración
- ❤️ **Sistema de Seguimiento:** Sigue tus supermercados favoritos
- ⚙️ **Gestión de Cuenta:** Configuración de perfil y eliminación de cuenta

### Para Usuarios Empresariales (Supermercados)
- 📢 **Crear Anuncios:** Publica ofertas con título, descripción, categoría e imagen
- 📊 **Gestión de Ofertas:** Visualiza y elimina tus anuncios publicados
- 🏢 **Perfil Empresarial:** Información detallada de la empresa (NIT/RUT, sucursales, etc.)
- ⚙️ **Configuración:** Gestión de cuenta empresarial

### Categorías Disponibles
- 🥬 Frescos
- 🛒 Despensa
- 🥤 Bebidas
- 🧴 Cuidado Personal
- 🏠 Productos del Hogar
- 💻 Tecnología
- 👕 Ropa y Calzado
- 🧸 Juguetes
- ➕ Otros (personalizable)

---

## 🚀 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

### 1. Flutter SDK
- **Versión requerida:** Flutter 3.9.2 o superior
- **Descarga:** https://docs.flutter.dev/get-started/install
- **Verificación:**
  ```bash
  flutter --version
  flutter doctor
  ```

### 2. Android SDK
- **Android Studio** instalado con:
  - Android SDK Platform 34
  - Android SDK Build-Tools 35.0.0
  - Android SDK Command-line Tools
- **Verificación:**
  ```bash
  flutter doctor -v
  ```

### 3. Firebase CLI (Opcional pero recomendado)
```bash
npm install -g firebase-tools
firebase login
```

### 4. FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 5. Dispositivo o Emulador Android
- **Físico:** Habilitar "Modo Desarrollador" y "Depuración USB"
- **Emulador:** Crear un AVD en Android Studio (API 34 recomendado)

---

## 🔥 Configuración de Firebase

### Paso 1: Crear Proyecto en Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Haz clic en **"Agregar proyecto"**
3. Nombre del proyecto: `bigshot` (o el que prefieras)
4. Sigue los pasos y crea el proyecto

### Paso 2: Configurar Firebase Authentication

1. En Firebase Console → **Authentication**
2. Clic en **"Comenzar"**
3. Habilita el método de inicio de sesión:
   - **Correo electrónico/contraseña:** ✅ Habilitado
   - *Google Sign-In:* ⚠️ Opcional (actualmente deshabilitado en el código)

### Paso 3: Configurar Firestore Database

1. En Firebase Console → **Firestore Database**
2. Clic en **"Crear base de datos"**
3. Selecciona modo:
   - **Producción** (con reglas personalizadas)
   - Ubicación: Elige la más cercana a tu región

4. **Configurar Reglas de Seguridad:**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Usuarios
       match /users/{userId} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && request.auth.uid == userId;
       }
       
       // Empresas
       match /businesses/{businessId} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && request.auth.uid == businessId;
       }
       
       // Ofertas
       match /offers/{offerId} {
         allow read: if request.auth != null;
         allow create: if request.auth != null;
         allow update, delete: if request.auth != null && 
                                  request.auth.uid == resource.data.businessId;
       }
       
       // Seguimientos
       match /follows/{followId} {
         allow read: if request.auth != null;
         allow create, delete: if request.auth != null && 
                                   request.auth.uid == request.resource.data.userId;
       }
     }
   }
   ```

### Paso 4: Configurar Firebase Storage (Opcional)

> ⚠️ **Nota:** Actualmente la subida de imágenes está deshabilitada en el código. Para habilitarla:

1. En Firebase Console → **Storage**
2. Clic en **"Comenzar"**
3. Selecciona ubicación y crea el bucket

4. **Configurar Reglas de Storage:**
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /business_logos/{userId}/{fileName} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && request.auth.uid == userId;
       }
       
       match /business_documents/{userId}/{fileName} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && request.auth.uid == userId;
       }
       
       match /offer_images/{userId}/{fileName} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

### Paso 5: Registrar la Aplicación Android

1. En Firebase Console → **Configuración del proyecto** (⚙️)
2. Selecciona **Android** (ícono de Android)
3. **Nombre del paquete Android:** `com.hir0exe.flutter_big_shot_dev`
   - ⚠️ **IMPORTANTE:** Debe coincidir exactamente con este nombre
4. (Opcional) Apodo de la app: `BigShot`
5. (Opcional) Certificado de firma SHA-1:
   - Para debug:
     ```bash
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     ```
   - En Windows PowerShell:
     ```powershell
     keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
     ```
6. Descarga el archivo **`google-services.json`**
7. ⚠️ **NO copies el archivo manualmente.** Usa FlutterFire CLI (siguiente paso)

### Paso 6: Configurar FlutterFire

En el directorio raíz del proyecto, ejecuta:

```bash
flutterfire configure
```

Esto:
- Seleccionará tu proyecto de Firebase
- Generará el archivo `lib/firebase_options.dart`
- Colocará el `google-services.json` en la ubicación correcta
- Configurará automáticamente Android y iOS (si aplica)

---

## 📦 Instalación del Proyecto

### 1. Clonar el Repositorio

```bash
git clone https://github.com/Hir0Exe/PU-BigShot.git
cd PU-BigShot
```

### 2. Instalar Dependencias

```bash
flutter pub get
```

### 3. Verificar la Configuración

```bash
flutter doctor -v
```

Soluciona cualquier problema que aparezca con ❌ o ⚠️.

### 4. Configurar Variables de Entorno (Android)

Edita o crea el archivo `android/local.properties`:

```properties
sdk.dir=<RUTA_A_TU_ANDROID_SDK>
flutter.sdk=<RUTA_A_TU_FLUTTER_SDK>
```

**Ejemplo en Windows:**
```properties
sdk.dir=C:\\Users\\TuUsuario\\AppData\\Local\\Android\\sdk
flutter.sdk=C:\\src\\flutter
```

**Ejemplo en macOS/Linux:**
```properties
sdk.dir=/Users/tuusuario/Library/Android/sdk
flutter.sdk=/Users/tuusuario/flutter
```

### 5. Verificar `google-services.json`

Asegúrate de que existe en:
```
android/app/google-services.json
```

Y que el `package_name` coincida con:
```json
{
  "client": [
    {
      "package_name": "com.hir0exe.flutter_big_shot_dev"
    }
  ]
}
```

---

## ▶️ Ejecutar la Aplicación

### En Dispositivo Físico (Recomendado)

1. **Conecta tu dispositivo Android** vía USB
2. **Habilita la depuración USB:**
   - Ajustes → Acerca del teléfono → Toca 7 veces en "Número de compilación"
   - Ajustes → Opciones de desarrollador → Depuración USB ✅
3. **Verifica la conexión:**
   ```bash
   flutter devices
   ```
4. **Ejecuta la app:**
   ```bash
   flutter run
   ```

### En Emulador Android

1. **Abre Android Studio** → AVD Manager
2. **Crea o inicia un emulador** (API 34 recomendado)
3. **Verifica:**
   ```bash
   flutter devices
   ```
4. **Ejecuta:**
   ```bash
   flutter run
   ```

### Comandos Útiles

```bash
# Limpiar build y cachés
flutter clean

# Obtener dependencias
flutter pub get

# Ejecutar en modo debug
flutter run

# Ejecutar en modo release (optimizado)
flutter run --release

# Ver logs en tiempo real
flutter logs

# Hot reload (durante ejecución)
Presiona 'r' en la terminal

# Hot restart
Presiona 'R' en la terminal
```

---

## 📂 Estructura del Proyecto

```
lib/
├── main.dart                      # Punto de entrada de la app
├── firebase_options.dart          # Configuración de Firebase (auto-generado)
│
├── models/                        # Modelos de datos
│   ├── user_model.dart           # Usuario (particular/empresarial)
│   ├── business_model.dart       # Datos de empresa
│   ├── offer_model.dart          # Ofertas/Anuncios
│   └── follow_model.dart         # Seguimientos
│
├── services/                      # Lógica de negocio y Firebase
│   ├── auth_service.dart         # Autenticación (login, registro, eliminar cuenta)
│   ├── business_service.dart     # Gestión de empresas
│   ├── offer_service.dart        # Gestión de ofertas
│   └── follow_service.dart       # Gestión de seguimientos
│
├── providers/                     # Gestión de estado (Provider)
│   └── auth_provider.dart        # Estado de autenticación
│
├── screens/                       # Pantallas de la aplicación
│   ├── auth/                     # Autenticación
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── user_type_selection_screen.dart
│   │
│   ├── business/                 # Pantallas empresariales
│   │   ├── business_home_screen.dart
│   │   ├── business_registration_screen.dart
│   │   ├── business_settings_screen.dart
│   │   └── create_offer_screen.dart
│   │
│   └── home/                     # Pantallas de usuario particular
│       ├── user_home_screen.dart
│       ├── user_search_screen.dart
│       ├── user_following_screen.dart
│       └── user_settings_screen.dart
│
└── widgets/                       # Widgets reutilizables (futuro)
```

---

## 🎯 Funcionalidades Detalladas

### Flujo de Autenticación

1. **Pantalla de Inicio de Sesión**
   - Email y contraseña
   - Botón "Crear cuenta"

2. **Selección de Tipo de Usuario**
   - Usuario Particular
   - Usuario Empresarial (Supermercado)

3. **Registro**
   - Usuario Particular: Email y contraseña
   - Usuario Empresarial: Email, contraseña + formulario empresarial

### Usuario Particular

#### 🏠 Inicio
- Feed de ofertas con prioridad para empresas seguidas
- Botón "Seguir/Dejar de seguir" en cada oferta
- Badge con categoría
- Fecha de expiración con indicadores visuales
- Pull-to-refresh

#### 🔍 Búsqueda
- Barra de búsqueda por texto
- Filtros por categoría (chips seleccionables)
- Checkbox "Incluir ofertas vencidas"
- Resultados en tiempo real

#### ❤️ Siguiendo
- Lista de supermercados seguidos
- Botón para dejar de seguir
- Badge "Siguiendo"

#### ⚙️ Ajustes
- Información del perfil
- Opciones de configuración (preparadas para futuro)
- Cerrar sesión
- **Eliminar cuenta** (irreversible)

### Usuario Empresarial

#### 🏢 Mis Anuncios
- Lista de ofertas publicadas
- Información de cada oferta (título, categoría, descripción, fecha)
- Botón para eliminar ofertas
- Botón flotante "+" para crear nuevo anuncio

#### ➕ Crear Anuncio
- Nombre de la promoción
- Selector de categoría
- Campo personalizado para categoría "OTROS"
- Descripción
- Selector de imagen (preparado, requiere Firebase Storage)
- Fecha de expiración

#### ⚙️ Configuración
- Información de la empresa
- Datos corporativos (NIT/RUT, sucursales, dirección, etc.)
- Cerrar sesión
- **Eliminar cuenta** (elimina también todas las ofertas)

---

## 🔧 Configuraciones Avanzadas

### Habilitar Google Sign-In

1. **En `lib/services/auth_service.dart`:**
   - Descomenta las líneas relacionadas con Google Sign-In
   - Elimina el `throw UnimplementedError(...)`

2. **Configurar en Firebase:**
   - Firebase Console → Authentication → Proveedores
   - Habilita Google
   - Descarga el `google-services.json` actualizado

3. **Agregar SHA-1 y SHA-256:**
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
   Copia los certificados a Firebase Console

### Habilitar Subida de Imágenes (Firebase Storage)

1. **Configurar Storage en Firebase Console** (ver Paso 4 arriba)

2. **En el código:**
   - `lib/screens/business/business_registration_screen.dart`:
     - Descomenta las líneas de `uploadLogo` y `uploadRegistroMercantil`
   - `lib/screens/business/create_offer_screen.dart`:
     - Descomenta la línea de subida de imagen en `_createOffer`
   - `lib/services/business_service.dart`:
     - Implementa los métodos de upload

---

## ⚠️ Problemas Comunes y Soluciones

### 1. Error: "No matching client found for package name"

**Causa:** El package name en `google-services.json` no coincide con el de la app.

**Solución:**
- Verifica en `android/app/build.gradle.kts`:
  ```kotlin
  applicationId = "com.hir0exe.flutter_big_shot_dev"
  ```
- Debe coincidir con el `package_name` en Firebase Console

### 2. Error: "The email address is already in use"

**Causa:** El email ya está registrado en Firebase Authentication.

**Solución:**
- Firebase Console → Authentication → Usuarios
- Elimina el usuario existente
- O usa un email diferente

### 3. Error: "Developer Mode required for symlinks"

**Causa:** Windows requiere permisos especiales para symlinks.

**Solución:**
- Ajustes de Windows → Actualización y Seguridad → Para desarrolladores
- Activa "Modo de desarrollador"

### 4. Error de espacio en disco

**Solución:**
```bash
flutter clean
flutter pub get
```

Limpia también:
- `%USERPROFILE%\.gradle\caches`
- `%USERPROFILE%\.android\build-cache`

### 5. Error: "NDK not found"

**Causa:** El NDK está deshabilitado intencionalmente en este proyecto.

**Solución:** Ya está resuelto en `android/app/build.gradle.kts`

### 6. Hot reload no funciona

**Solución:**
- Presiona `R` (hot restart) en lugar de `r`
- O reinicia la app completamente: `flutter run`

---

## 🔒 Seguridad

### Datos Sensibles

- ⚠️ **NUNCA** subas `google-services.json` a repositorios públicos
- Agrega a `.gitignore`:
  ```
  android/app/google-services.json
  ios/Runner/GoogleService-Info.plist
  lib/firebase_options.dart
  ```

### Reglas de Firestore

Las reglas actuales permiten:
- Usuarios autenticados pueden leer sus propios datos
- Usuarios solo pueden escribir en sus propios documentos
- Empresas solo pueden editar/eliminar sus propias ofertas
- Cualquier usuario autenticado puede leer ofertas

### Autenticación

- Las contraseñas nunca se almacenan en texto plano
- Firebase maneja el hash y la seguridad
- Los tokens de sesión caducan automáticamente

---

## 🛠️ Tecnologías Utilizadas

- **Flutter 3.9.2+** - Framework de desarrollo
- **Dart 3.9.2+** - Lenguaje de programación
- **Firebase Authentication** - Gestión de usuarios
- **Cloud Firestore** - Base de datos NoSQL
- **Firebase Storage** - Almacenamiento de archivos (preparado)
- **Provider** - Gestión de estado
- **Image Picker** - Selección de imágenes

### Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^4.2.0
  firebase_auth: ^6.1.1
  cloud_firestore: ^6.0.3
  firebase_storage: ^13.0.3
  google_sign_in: ^7.2.0
  provider: ^6.1.5+1
  image_picker: ^1.2.0
```

---

## 📝 Notas de Desarrollo

### Cambios Recientes
- ✅ Sistema de seguimiento implementado
- ✅ Búsqueda con filtros por categoría
- ✅ Prioridad de ofertas para empresas seguidas
- ✅ Función de eliminar cuenta (completa)
- ⏳ Google Sign-In deshabilitado temporalmente
- ⏳ Subida de imágenes deshabilitada (Storage no configurado)

### Próximas Funcionalidades (Sugeridas)
- [ ] Notificaciones push
- [ ] Chat entre usuarios y empresas
- [ ] Sistema de valoraciones
- [ ] Mapa de ubicación de supermercados
- [ ] Compartir ofertas en redes sociales
- [ ] Modo oscuro
- [ ] Soporte multiidioma

---

## 👥 Contribuir

Si deseas contribuir al proyecto:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

---

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la [MIT License](LICENSE).

---

## 📞 Soporte

Si tienes problemas con la configuración:

1. Revisa la sección de **Problemas Comunes**
2. Ejecuta `flutter doctor -v` y soluciona los warnings
3. Verifica que Firebase esté correctamente configurado
4. Revisa los logs: `flutter logs`

---

## ✨ Créditos

Desarrollado como proyecto universitario.

**Versión:** 1.0.0  
**Última actualización:** Octubre 2025

---

## 🚀 ¡Comienza Ahora!

```bash
# 1. Clona el proyecto
git clone https://github.com/Hir0Exe/PU-BigShot.git
cd PU-BigShot

# 2. Instala dependencias
flutter pub get

# 3. Configura Firebase
flutterfire configure

# 4. Ejecuta en tu dispositivo
flutter run
```

**¡Disfruta desarrollando con BigShot! 🎉**
