# ⚡ Guía Rápida de Inicio - BigShot

Esta guía te ayudará a tener la aplicación corriendo en **menos de 15 minutos**.

---

## 📋 Pre-requisitos Rápidos

✅ **Antes de empezar, asegúrate de tener:**

```bash
# 1. Flutter instalado
flutter --version
# Deberías ver: Flutter 3.9.2 o superior

# 2. Android SDK configurado
flutter doctor
# Todos los checks de Android deben estar en ✓

# 3. Un dispositivo Android conectado o emulador iniciado
flutter devices
# Deberías ver al menos 1 dispositivo
```

---

## 🚀 5 Pasos para Ejecutar

### 1️⃣ Clonar y Preparar (2 min)

```bash
# Clona el repositorio
git clone https://github.com/Hir0Exe/PU-BigShot.git
cd PU-BigShot

# Instala dependencias
flutter pub get
```

### 2️⃣ Configurar Firebase (5 min)

#### A. Crear Proyecto Firebase

1. Ve a https://console.firebase.google.com/
2. **"Agregar proyecto"** → Nombre: `bigshot`
3. Desactiva Google Analytics (opcional)
4. **Crear proyecto**

#### B. Configurar Servicios

```
📍 Firebase Console → Authentication
   → "Comenzar"
   → Habilita "Correo electrónico/contraseña" ✅

📍 Firebase Console → Firestore Database
   → "Crear base de datos"
   → Modo "Producción"
   → Ubicación: La más cercana
   → "Habilitar"

📍 Firebase Console → Firestore → Reglas
   → Copia las reglas de FIREBASE_RULES.md
   → "Publicar"
```

#### C. Registrar App Android

```
📍 Firebase Console → Configuración del proyecto (⚙️)
   → Android (ícono)
   → Package name: com.hir0exe.flutter_big_shot_dev
   → "Registrar app"
   → NO descargues google-services.json aún
```

### 3️⃣ Configurar FlutterFire (3 min)

```bash
# Instala FlutterFire CLI (solo primera vez)
dart pub global activate flutterfire_cli

# Configura Firebase automáticamente
flutterfire configure

# Selecciona:
# - Tu proyecto Firebase
# - Plataformas: Android (presiona espacio para seleccionar)
# - Confirma la configuración
```

Esto creará automáticamente:
- ✅ `lib/firebase_options.dart`
- ✅ `android/app/google-services.json`

### 4️⃣ Verificar Configuración (2 min)

```bash
# Verifica que Flutter esté OK
flutter doctor

# Limpia build anterior (por si acaso)
flutter clean
flutter pub get

# Verifica dispositivo conectado
flutter devices
```

### 5️⃣ Ejecutar App (3 min)

```bash
# Ejecuta en tu dispositivo
flutter run

# O especifica el dispositivo
flutter run -d <DEVICE_ID>

# Primera vez puede tardar 2-3 minutos compilando
# Espera a ver: "Application started"
```

---

## 🎉 ¡Primer Uso!

### Crear tu Primera Cuenta

1. **En la app:** Tap en "Crear cuenta"
2. **Selecciona tipo:** "Usuario" o "Supermercado"
3. **Completa el formulario:**
   - Email: `test@example.com`
   - Contraseña: `test123456` (mínimo 6 caracteres)
4. **Si eres Supermercado:** Completa datos empresariales

### Probar la App

**Como Usuario Particular:**
- 🏠 Inicio: Ve ofertas disponibles
- 🔍 Búsqueda: Busca por categoría
- ❤️ Siguiendo: Vacío inicialmente
- ⚙️ Ajustes: Ver tu perfil

**Como Supermercado:**
- 📢 Mis Anuncios: Vacío inicialmente
- ➕ Crear tu primera oferta:
  - Tap en el botón "+"
  - Llena el formulario
  - "Publicar"

---

## 🐛 Errores Comunes

### Error: "No matching client found"

**Causa:** El package name no coincide.

**Solución rápida:**
```bash
# Verifica en android/app/build.gradle.kts
# Debe ser: applicationId = "com.hir0exe.flutter_big_shot_dev"

# Vuelve a configurar Firebase
flutterfire configure
```

### Error: "Email already in use"

**Solución:**
1. Firebase Console → Authentication → Usuarios
2. Elimina el usuario existente
3. Intenta de nuevo

### Error: Build fallido

**Solución:**
```bash
flutter clean
flutter pub get
flutter run
```

### Error: No se encuentra el dispositivo

**Solución:**
```bash
# En tu dispositivo Android:
# 1. Habilita "Opciones de Desarrollador"
#    (Ajustes → Sobre el teléfono → Toca 7 veces "Número de compilación")
# 2. Habilita "Depuración USB"
# 3. Conecta por USB
# 4. Acepta el permiso en el teléfono

flutter devices  # Debería aparecer ahora
```

---

## 💡 Comandos Útiles

```bash
# Ver logs en tiempo real
flutter logs

# Hot reload (mientras la app corre)
Presiona 'r' en la terminal

# Hot restart
Presiona 'R' en la terminal

# Limpiar y reconstruir
flutter clean && flutter pub get && flutter run

# Ver información detallada de Flutter
flutter doctor -v
```

---

## 📱 Atajos Durante Desarrollo

Mientras la app está corriendo, presiona en la terminal:

- `r` - Hot reload (recarga cambios)
- `R` - Hot restart (reinicia la app)
- `h` - Ver todos los comandos disponibles
- `c` - Limpiar la consola
- `q` - Salir

---

## 🎯 Próximos Pasos

Una vez que la app funcione:

1. **Lee el README completo** para entender el proyecto
2. **Explora FIREBASE_RULES.md** para configurar seguridad
3. **Revisa la estructura** en `lib/` para ver cómo está organizado
4. **Crea más usuarios de prueba** para probar el sistema de seguimiento

---

## 📞 ¿Necesitas Ayuda?

Si algo no funciona:

1. **Revisa TROUBLESHOOTING.md** (próximamente)
2. **Ejecuta:** `flutter doctor -v`
3. **Revisa los logs:** `flutter logs`
4. **Verifica Firebase Console:** ¿Los servicios están habilitados?

---

## ⏱️ Resumen de Tiempos

- ⚡ Clonar proyecto: 1-2 min
- 🔥 Configurar Firebase: 5 min
- 🛠️ FlutterFire: 3 min
- ✅ Verificación: 2 min
- 🚀 Primera ejecución: 3 min

**Total: ~15 minutos** ⏰

---

## ✅ Checklist Final

Antes de empezar a desarrollar:

- [ ] `flutter doctor` sin errores críticos
- [ ] Firebase proyecto creado
- [ ] Authentication habilitado
- [ ] Firestore habilitado y con reglas
- [ ] FlutterFire configurado (`firebase_options.dart` existe)
- [ ] `google-services.json` en `android/app/`
- [ ] App corre sin errores
- [ ] Puedo crear y hacer login

---

**¡Listo! Ahora tienes BigShot corriendo. 🎉**

Para documentación completa, consulta el [README.md](README.md)

