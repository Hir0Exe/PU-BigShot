# 📝 Changelog

Todos los cambios notables a este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

---

## [1.0.0] - 2025-10-29

### 🎉 Release Inicial

Primera versión funcional de BigShot - Plataforma de Ofertas de Supermercados.

### ✨ Características Implementadas

#### Autenticación
- ✅ Login con email y contraseña
- ✅ Registro de usuarios (particular y empresarial)
- ✅ Selección de tipo de usuario
- ✅ Formulario extendido para registro empresarial
- ✅ Función de eliminar cuenta (irreversible)
- ✅ Cerrar sesión

#### Usuario Particular
- ✅ **Vista de Inicio**
  - Feed de ofertas con prioridad para empresas seguidas
  - Sistema de seguir/dejar de seguir supermercados
  - Indicadores visuales de seguimiento
  - Badges de categorías
  - Fechas de expiración con colores
  - Pull-to-refresh

- ✅ **Vista de Búsqueda**
  - Búsqueda por texto (título, descripción, nombre del negocio)
  - Filtros por categoría (9 categorías predefinidas)
  - Opción para incluir/excluir ofertas vencidas
  - Panel de filtros desplegable
  - Resultados en tiempo real

- ✅ **Vista de Siguiendo**
  - Lista de supermercados seguidos
  - Información de cada empresa
  - Botón para dejar de seguir con confirmación
  - Estado vacío informativo

- ✅ **Vista de Ajustes**
  - Información del perfil
  - Opciones de configuración (preparadas)
  - Cerrar sesión
  - Eliminar cuenta (con advertencias)

#### Usuario Empresarial (Supermercado)
- ✅ **Registro Empresarial**
  - Formulario completo con datos corporativos
  - Campos: Nombre, NIT/RUT, Sucursales, Dirección, Ciudad, Teléfono, Email, Sitio Web
  - Preparado para subir logo y registro mercantil

- ✅ **Vista Mis Anuncios**
  - Lista de ofertas publicadas
  - Cards con información detallada
  - Opción de eliminar ofertas
  - Botón flotante para crear nueva oferta

- ✅ **Crear Anuncio**
  - Formulario completo
  - Selector de categorías
  - Campo personalizado para categoría "OTROS"
  - Descripción con contador de caracteres
  - Selector de imagen (preparado, requiere Storage)
  - Selector de fecha de expiración
  - Botones de publicar y cancelar

- ✅ **Configuración Empresarial**
  - Visualización de datos de la empresa
  - Información corporativa detallada
  - Cerrar sesión
  - Eliminar cuenta (elimina también ofertas)

### 🗄️ Base de Datos (Firestore)

#### Colecciones Implementadas
- **users**: Información básica de usuarios
- **businesses**: Datos detallados de empresas
- **offers**: Ofertas publicadas
- **follows**: Seguimientos usuario-empresa

### 🎨 Diseño y UI

- **Paleta de colores:**
  - Primario: `#7B4397` (Morado)
  - Fondo: `#E8D5F2` (Lila claro)
  - Acentos: Verde, Naranja, Rojo

- **Componentes:**
  - Bottom Navigation (4 tabs para usuarios, 3 para empresas)
  - Cards con elevación y bordes redondeados
  - Chips para categorías
  - Diálogos de confirmación
  - SnackBars para feedback
  - Circular progress indicators

### 🔧 Servicios Implementados

#### AuthService
- Login, registro, logout
- Gestión de tipos de usuario
- Eliminación completa de cuenta
- Manejo de errores de Firebase Auth

#### OfferService
- CRUD de ofertas
- Búsqueda con filtros
- Priorización de ofertas seguidas
- Ordenamiento en memoria (sin índices compuestos)

#### FollowService
- Seguir/dejar de seguir empresas
- Obtener lista de seguimientos
- Verificar estado de seguimiento
- Contar seguidores

#### BusinessService
- Guardar/obtener datos empresariales
- Preparado para upload de archivos (Storage)

### 📦 Dependencias

```yaml
firebase_core: ^4.2.0
firebase_auth: ^6.1.1
cloud_firestore: ^6.0.3
firebase_storage: ^13.0.3
google_sign_in: ^7.2.0
provider: ^6.1.5+1
image_picker: ^1.2.0
```

### 🔐 Seguridad

- Reglas de Firestore implementadas
- Validación de propiedad de recursos
- Autenticación requerida para todas las operaciones
- Reglas de Storage preparadas (Storage no habilitado)

### 📚 Documentación

- ✅ README.md completo con instrucciones paso a paso
- ✅ QUICKSTART.md para inicio rápido (15 minutos)
- ✅ FIREBASE_RULES.md con todas las reglas de seguridad
- ✅ CONTRIBUTING.md con guías de contribución
- ✅ Archivos de ejemplo (.example) para configuración
- ✅ .gitignore actualizado para proteger archivos sensibles

### ⚠️ Limitaciones Conocidas

#### Temporalmente Deshabilitado
- **Google Sign-In:** Comentado en el código, requiere configuración adicional
- **Subida de Imágenes:** Firebase Storage no configurado, código preparado

#### Por Implementar (Futuro)
- [ ] Notificaciones push
- [ ] Tests unitarios y de integración
- [ ] Modo oscuro
- [ ] Soporte iOS
- [ ] Internacionalización (i18n)
- [ ] Cache de imágenes
- [ ] Compartir ofertas
- [ ] Sistema de valoraciones

### 🐛 Bugs Conocidos

- **Ninguno reportado** en esta versión

### 🔄 Cambios Técnicos

- **Android:**
  - minSdk: 21
  - targetSdk: 34
  - Kotlin DSL para build.gradle
  - NDK deshabilitado (no requerido)
  - multiDex habilitado

- **Flutter:**
  - Versión: 3.9.2+
  - Dart: 3.9.2+

### 📝 Notas de Migración

Si migras del proyecto original (flutter_twitter_clone):

1. Este es un proyecto completamente nuevo
2. No hay migración de datos necesaria
3. Configurar Firebase desde cero
4. El package name cambió a: `com.hir0exe.flutter_big_shot_dev`

### 🙏 Agradecimientos

- Proyecto base inspirado en flutter_twitter_clone
- Desarrollado como proyecto universitario
- Comunidad de Flutter y Firebase

---

## [Unreleased]

### Planeado para próximas versiones

- [ ] Notificaciones cuando empresas seguidas publican ofertas
- [ ] Chat entre usuarios y empresas
- [ ] Mapa de ubicación de supermercados
- [ ] Sistema de valoraciones de ofertas
- [ ] Compartir ofertas en redes sociales
- [ ] Modo oscuro
- [ ] Soporte multiidioma
- [ ] Tests automatizados
- [ ] CI/CD Pipeline

---

## Formato de Versiones

```
[MAJOR.MINOR.PATCH] - YYYY-MM-DD

MAJOR: Cambios incompatibles con versiones anteriores
MINOR: Nueva funcionalidad compatible
PATCH: Correcciones de bugs compatibles
```

### Tipos de Cambios

- **✨ Added**: Nuevas características
- **🔧 Changed**: Cambios en funcionalidad existente
- **⚠️ Deprecated**: Características que serán removidas
- **🗑️ Removed**: Características eliminadas
- **🐛 Fixed**: Corrección de bugs
- **🔒 Security**: Mejoras de seguridad

---

**Última actualización:** 2025-10-29

