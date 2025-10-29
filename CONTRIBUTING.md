# 🤝 Guía de Contribución - BigShot

¡Gracias por tu interés en contribuir a BigShot! Este documento te guiará sobre cómo puedes ayudar a mejorar el proyecto.

---

## 📋 Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [¿Cómo Puedo Contribuir?](#cómo-puedo-contribuir)
- [Configuración del Entorno](#configuración-del-entorno)
- [Proceso de Desarrollo](#proceso-de-desarrollo)
- [Estándares de Código](#estándares-de-código)
- [Proceso de Pull Request](#proceso-de-pull-request)
- [Reportar Bugs](#reportar-bugs)
- [Sugerir Mejoras](#sugerir-mejoras)

---

## 📜 Código de Conducta

Este proyecto se adhiere a un código de conducta profesional y respetuoso:

- ✅ Sé respetuoso y constructivo
- ✅ Acepta críticas constructivas
- ✅ Enfócate en lo mejor para la comunidad
- ❌ No uses lenguaje ofensivo o inapropiado
- ❌ No ataques personalmente a otros colaboradores

---

## 🚀 ¿Cómo Puedo Contribuir?

### 1. Reportar Bugs 🐛

¿Encontraste un error? Ayúdanos a mejorarlo:

1. **Verifica** que no exista un issue similar
2. **Crea un nuevo issue** con:
   - Descripción clara del problema
   - Pasos para reproducirlo
   - Comportamiento esperado vs actual
   - Screenshots (si aplica)
   - Versión de Flutter/Android

### 2. Proponer Nuevas Funcionalidades 💡

¿Tienes una idea genial?

1. **Abre un issue** con el tag `enhancement`
2. **Describe:**
   - Qué problema resuelve
   - Cómo funcionaría
   - Por qué es importante
3. **Espera feedback** antes de empezar a codear

### 3. Mejorar la Documentación 📚

La documentación siempre puede mejorar:

- Corregir typos
- Aclarar instrucciones confusas
- Agregar ejemplos
- Traducir a otros idiomas

### 4. Escribir Código 💻

¡La mejor manera de contribuir!

---

## 🛠️ Configuración del Entorno

### Prerequisitos

- Flutter SDK 3.9.2+
- Android SDK
- Git
- Un editor de código (VS Code, Android Studio)

### Setup Inicial

```bash
# 1. Fork el repositorio en GitHub

# 2. Clona tu fork
git clone https://github.com/TU_USUARIO/flutter_twitter_clone.git
cd flutter_twitter_clone

# 3. Agrega el repositorio original como remote
git remote add upstream https://github.com/REPO_ORIGINAL/flutter_twitter_clone.git

# 4. Instala dependencias
flutter pub get

# 5. Configura Firebase (ver QUICKSTART.md)
flutterfire configure

# 6. Ejecuta la app
flutter run
```

---

## 🔄 Proceso de Desarrollo

### 1. Crear una Rama

```bash
# Actualiza tu rama main
git checkout main
git pull upstream main

# Crea una nueva rama para tu feature
git checkout -b feature/nombre-descriptivo

# O para un bugfix
git checkout -b fix/descripcion-del-bug
```

### 2. Hacer Cambios

- **Escribe código limpio y comentado**
- **Sigue los estándares de Dart/Flutter**
- **Prueba tus cambios manualmente**
- **Asegúrate de que no haya errores de lint**

```bash
# Verifica lint
flutter analyze

# Formatea el código
dart format lib/
```

### 3. Commit

```bash
# Agrega tus cambios
git add .

# Commit con mensaje descriptivo
git commit -m "feat: Agregar filtro de búsqueda por precio"
```

**Formato de commits:**

- `feat:` Nueva funcionalidad
- `fix:` Corrección de bug
- `docs:` Cambios en documentación
- `style:` Formato, sin cambios de código
- `refactor:` Refactorización de código
- `test:` Agregar o modificar tests
- `chore:` Mantenimiento, dependencias

### 4. Push

```bash
# Sube tu rama a tu fork
git push origin feature/nombre-descriptivo
```

---

## 📏 Estándares de Código

### Dart/Flutter

```dart
// ✅ BUENO: Nombres descriptivos, comentarios claros
/// Obtiene las ofertas activas con prioridad para empresas seguidas
Future<List<OfferModel>> getOffersWithPriority(
  List<String> followedBusinessIds,
) async {
  try {
    final snapshot = await _firestore.collection('offers').get();
    // Filtrar y ordenar...
    return offers;
  } catch (e) {
    print('Error obteniendo ofertas: $e');
    return [];
  }
}

// ❌ MALO: Nombres poco claros, sin manejo de errores
Future<List<OfferModel>> getO(List<String> ids) async {
  var s = await _firestore.collection('offers').get();
  return s.docs.map((d) => OfferModel.fromMap(d.data(), d.id)).toList();
}
```

### Estructura de Archivos

```
lib/
├── models/          # Solo modelos de datos
├── services/        # Lógica de negocio y APIs
├── providers/       # Estado (Provider)
├── screens/         # Pantallas completas
└── widgets/         # Widgets reutilizables
```

### Imports

```dart
// 1. Imports de Dart
import 'dart:async';

// 2. Imports de Flutter
import 'package:flutter/material.dart';

// 3. Imports de paquetes externos
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// 4. Imports relativos del proyecto
import '../models/user_model.dart';
import '../services/auth_service.dart';
```

### Comentarios

```dart
// ✅ BUENO: Explica el "por qué"
// Ordenamos en memoria para evitar índices compuestos en Firestore
offers.sort((a, b) => b.createdAt.compareTo(a.createdAt));

// ❌ MALO: Explica el "qué" (obvio del código)
// Ordena las ofertas
offers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
```

---

## 🔀 Proceso de Pull Request

### Antes de Crear el PR

- [ ] Tu código compila sin errores
- [ ] Has probado todos los cambios manualmente
- [ ] El código está formateado (`dart format`)
- [ ] No hay errores de lint (`flutter analyze`)
- [ ] Actualizaste la documentación si es necesario
- [ ] Tu commit sigue el formato requerido

### Crear el PR

1. **Ve a GitHub** y abre tu fork
2. **Click en "Compare & pull request"**
3. **Título descriptivo:**
   ```
   feat: Agregar filtro de búsqueda por precio
   ```
4. **Descripción detallada:**
   ```markdown
   ## Descripción
   Agrega un filtro para buscar ofertas por rango de precio
   
   ## Cambios
   - Nuevo slider de rango de precio en SearchScreen
   - Método filterByPrice en OfferService
   - Tests para la nueva funcionalidad
   
   ## Screenshots
   [Agrega capturas de pantalla]
   
   ## Checklist
   - [x] Código probado
   - [x] Documentación actualizada
   - [ ] Tests agregados (pendiente)
   ```

### Revisión

- Espera feedback de los mantenedores
- Responde a comentarios constructivamente
- Realiza cambios solicitados en la misma rama
- Cuando esté aprobado, será merged

---

## 🐛 Reportar Bugs

### Template de Issue para Bugs

```markdown
**Descripción del Bug**
Descripción clara del problema.

**Pasos para Reproducir**
1. Ve a '...'
2. Haz click en '...'
3. Scroll hasta '...'
4. Ver error

**Comportamiento Esperado**
Qué debería pasar.

**Comportamiento Actual**
Qué está pasando.

**Screenshots**
Si aplica, agrega screenshots.

**Entorno:**
- Flutter version: [flutter --version]
- Android version: [ej: Android 13]
- Dispositivo: [ej: Samsung Galaxy S21]

**Logs**
```
Pega aquí los logs relevantes de `flutter logs`
```

**Contexto Adicional**
Cualquier otra información relevante.
```

---

## 💡 Sugerir Mejoras

### Template de Issue para Mejoras

```markdown
**¿Tu feature está relacionada a un problema?**
Descripción clara del problema. Ej: "Es frustrante cuando..."

**Describe la solución que te gustaría**
Descripción clara de lo que quieres que pase.

**Alternativas consideradas**
Otras soluciones que pensaste.

**Contexto Adicional**
Mockups, ejemplos de otras apps, etc.
```

---

## 🎨 Guías de UI/UX

### Colores

```dart
// Usa los colores definidos
const primaryColor = Color(0xFF7B4397);
const backgroundColor = Color(0xFFE8D5F2);
```

### Espaciado

```dart
// Usa múltiplos de 8
const SizedBox(height: 8),  // ✅
const SizedBox(height: 16), // ✅
const SizedBox(height: 24), // ✅

const SizedBox(height: 13), // ❌
```

### Feedback al Usuario

```dart
// Siempre muestra feedback para acciones
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Oferta creada exitosamente')),
);
```

---

## 🧪 Testing (Futuro)

Por ahora, testing manual es suficiente. En el futuro:

```bash
# Correr tests
flutter test

# Cobertura
flutter test --coverage
```

---

## 📝 Checklist de Contribución

Antes de enviar tu PR, verifica:

- [ ] Mi código sigue el estilo del proyecto
- [ ] He revisado mi propio código
- [ ] He comentado código complejo
- [ ] He actualizado la documentación
- [ ] Mis cambios no generan warnings
- [ ] He probado en dispositivo Android real
- [ ] He formateado el código (`dart format`)
- [ ] No hay errores de lint (`flutter analyze`)

---

## 🏆 Reconocimiento

Los contribuidores serán reconocidos en:
- README.md (sección de Contributors)
- CHANGELOG.md (en cada release)

---

## 📞 ¿Preguntas?

Si tienes preguntas sobre cómo contribuir:

1. Revisa la documentación existente
2. Busca en issues cerrados
3. Abre un nuevo issue con el tag `question`

---

## 🙏 Gracias

Cada contribución, por pequeña que sea, es valiosa. ¡Gracias por hacer de BigShot un mejor proyecto!

---

**Happy Coding! 💜**

