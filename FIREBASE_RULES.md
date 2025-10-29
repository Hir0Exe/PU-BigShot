# 🔒 Reglas de Seguridad de Firebase

Este documento contiene las reglas de seguridad que debes configurar en Firebase Console para que la aplicación funcione correctamente.

---

## 📊 Firestore Database Rules

Ve a: **Firebase Console → Firestore Database → Reglas**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // ======================
    // COLECCIÓN: users
    // ======================
    // Documentos de usuarios (particulares y empresariales)
    match /users/{userId} {
      // Cualquier usuario autenticado puede leer
      allow read: if request.auth != null;
      
      // Solo el propio usuario puede crear/actualizar/eliminar su documento
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // ======================
    // COLECCIÓN: businesses
    // ======================
    // Información detallada de empresas/supermercados
    match /businesses/{businessId} {
      // Cualquier usuario autenticado puede leer información de empresas
      allow read: if request.auth != null;
      
      // Solo la propia empresa puede escribir sus datos
      allow write: if request.auth != null && request.auth.uid == businessId;
    }
    
    // ======================
    // COLECCIÓN: offers
    // ======================
    // Ofertas publicadas por empresas
    match /offers/{offerId} {
      // Cualquier usuario autenticado puede leer ofertas
      allow read: if request.auth != null;
      
      // Cualquier usuario autenticado puede crear ofertas
      // (La validación de tipo de usuario se hace en la app)
      allow create: if request.auth != null;
      
      // Solo la empresa propietaria puede actualizar/eliminar sus ofertas
      allow update, delete: if request.auth != null && 
                                request.auth.uid == resource.data.businessId;
    }
    
    // ======================
    // COLECCIÓN: follows
    // ======================
    // Seguimientos de usuarios a empresas
    match /follows/{followId} {
      // Cualquier usuario autenticado puede leer follows
      allow read: if request.auth != null;
      
      // Solo el usuario puede crear/eliminar sus propios follows
      allow create, delete: if request.auth != null && 
                               request.auth.uid == request.resource.data.userId;
    }
  }
}
```

### 📝 Explicación de las Reglas

**`users` y `businesses`:**
- Cualquiera puede leer perfiles (necesario para mostrar información)
- Solo el dueño puede modificar su información

**`offers`:**
- Todas las ofertas son públicas para usuarios autenticados
- Solo la empresa creadora puede editar o eliminar

**`follows`:**
- Los seguimientos son públicos
- Solo puedes gestionar tus propios seguimientos

---

## 📦 Firebase Storage Rules

Ve a: **Firebase Console → Storage → Reglas**

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // ======================
    // LOGOS DE EMPRESAS
    // ======================
    // Ruta: /business_logos/{userId}/{fileName}
    match /business_logos/{userId}/{fileName} {
      // Cualquiera puede leer (ver) los logos
      allow read: if request.auth != null;
      
      // Solo la empresa propietaria puede subir/actualizar su logo
      allow write: if request.auth != null && 
                      request.auth.uid == userId &&
                      request.resource.size < 2 * 1024 * 1024 && // Máximo 2MB
                      request.resource.contentType.matches('image/.*'); // Solo imágenes
    }
    
    // ======================
    // DOCUMENTOS EMPRESARIALES
    // ======================
    // Ruta: /business_documents/{userId}/{fileName}
    // Ejemplo: Registro Mercantil
    match /business_documents/{userId}/{fileName} {
      // Solo la empresa puede leer sus documentos
      allow read: if request.auth != null && request.auth.uid == userId;
      
      // Solo la empresa puede subir sus documentos
      allow write: if request.auth != null && 
                      request.auth.uid == userId &&
                      request.resource.size < 5 * 1024 * 1024; // Máximo 5MB
    }
    
    // ======================
    // IMÁGENES DE OFERTAS
    // ======================
    // Ruta: /offer_images/{userId}/{fileName}
    match /offer_images/{userId}/{fileName} {
      // Cualquiera puede ver las imágenes de ofertas
      allow read: if request.auth != null;
      
      // Solo la empresa puede subir imágenes de ofertas
      allow write: if request.auth != null && 
                      request.auth.uid == userId &&
                      request.resource.size < 2 * 1024 * 1024 && // Máximo 2MB
                      request.resource.contentType.matches('image/.*'); // Solo imágenes
    }
  }
}
```

### 📝 Explicación de las Reglas de Storage

**Límites de Tamaño:**
- Logos y ofertas: 2 MB
- Documentos empresariales: 5 MB

**Tipos de Archivo:**
- Imágenes: Solo formatos de imagen (PNG, JPG, etc.)
- Documentos: Cualquier tipo (PDF, etc.)

**Acceso:**
- Logos y ofertas: Públicos para usuarios autenticados
- Documentos: Solo la empresa propietaria

---

## 🔐 Firebase Authentication

Ve a: **Firebase Console → Authentication → Métodos de inicio de sesión**

### Habilitar Proveedores

1. **Correo electrónico/contraseña** ✅
   - Estado: Habilitado
   - Este es el método principal usado en la app

2. **Google** (Opcional)
   - Estado: Deshabilitado en el código actual
   - Para habilitar:
     - Activa en Firebase Console
     - Agrega SHA-1 y SHA-256 de tu app
     - Descomenta código en `lib/services/auth_service.dart`

---

## 📋 Checklist de Configuración

Marca cada paso completado:

### Firestore
- [ ] Crear base de datos en modo **Producción**
- [ ] Copiar y aplicar las reglas de Firestore
- [ ] Publicar las reglas
- [ ] Verificar que no hay errores en la consola

### Storage (Opcional)
- [ ] Crear bucket de Storage
- [ ] Copiar y aplicar las reglas de Storage
- [ ] Publicar las reglas
- [ ] Verificar estructura de carpetas

### Authentication
- [ ] Habilitar Email/Password
- [ ] (Opcional) Configurar Google Sign-In
- [ ] Agregar dominio autorizado si es necesario

---

## 🧪 Probar las Reglas

### Desde Firebase Console

1. Ve a **Firestore Database → Reglas**
2. Haz clic en **Simulador de reglas**
3. Prueba operaciones:
   ```
   Tipo: get
   Ruta: /offers/testOfferId
   Autenticado: ✅
   UID del solicitante: test123
   ```

### Desde la App

1. Crea una cuenta de prueba
2. Intenta crear una oferta
3. Intenta editar una oferta de otro usuario (debe fallar)
4. Revisa los logs de Firestore en la consola

---

## ⚠️ Advertencias de Seguridad

### ❌ NO HAGAS ESTO:

```javascript
// NUNCA uses esto en producción:
allow read, write: if true;  // ¡Cualquiera puede hacer cualquier cosa!
```

### ✅ BUENAS PRÁCTICAS:

1. **Siempre valida autenticación:**
   ```javascript
   allow read: if request.auth != null;
   ```

2. **Verifica propiedad de recursos:**
   ```javascript
   allow write: if request.auth.uid == resource.data.userId;
   ```

3. **Limita tamaños de archivo:**
   ```javascript
   request.resource.size < 2 * 1024 * 1024
   ```

4. **Valida tipos de contenido:**
   ```javascript
   request.resource.contentType.matches('image/.*')
   ```

---

## 🔄 Actualizar Reglas

Si necesitas modificar las reglas más adelante:

1. **Firebase Console** → Tu proyecto
2. **Firestore Database** o **Storage** → **Reglas**
3. Edita las reglas
4. Haz clic en **Publicar**
5. Las reglas se aplican inmediatamente

---

## 📞 Ayuda con Reglas

Si tienes problemas:

1. **Revisa los logs:** Firebase Console → Firestore → Reglas → Registro
2. **Usa el simulador:** Prueba operaciones específicas
3. **Lee la documentación:** https://firebase.google.com/docs/firestore/security/get-started
4. **Errores comunes:** Verifica que `request.auth != null` esté presente

---

## 📚 Recursos Adicionales

- [Documentación de Reglas de Firestore](https://firebase.google.com/docs/firestore/security/rules-structure)
- [Documentación de Reglas de Storage](https://firebase.google.com/docs/storage/security/start)
- [Mejores Prácticas de Seguridad](https://firebase.google.com/docs/rules/best-practices)

---

**Última actualización:** Octubre 2025

