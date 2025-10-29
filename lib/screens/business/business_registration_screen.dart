import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/business_model.dart';
import '../../services/business_service.dart';
import '../../providers/auth_provider.dart';

class BusinessRegistrationScreen extends StatefulWidget {
  const BusinessRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<BusinessRegistrationScreen> createState() =>
      _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState
    extends State<BusinessRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessService = BusinessService();
  final _imagePicker = ImagePicker();

  // Controllers
  final _nombreEmpresaController = TextEditingController();
  final _nitRutController = TextEditingController();
  final _numeroSucursalesController = TextEditingController();
  final _direccionController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailCorporativoController = TextEditingController();
  final _sitioWebController = TextEditingController();

  File? _logoFile;
  File? _registroMercantilFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreEmpresaController.dispose();
    _nitRutController.dispose();
    _numeroSucursalesController.dispose();
    _direccionController.dispose();
    _ciudadController.dispose();
    _telefonoController.dispose();
    _emailCorporativoController.dispose();
    _sitioWebController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _logoFile = File(image.path);
      });
    }
  }

  Future<void> _pickRegistroMercantil() async {
    // En producción, usarías file_picker para PDFs
    final XFile? file =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _registroMercantilFile = File(file.path);
      });
    }
  }

  Future<void> _saveBusinessData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = context.read<AuthProvider>();
        final uid = authProvider.user!.uid;

        // Subir archivos si existen (temporal: comentado por problema de Storage)
        String? logoUrl;
        String? registroMercantilUrl;

        // TODO: Habilitar Firebase Storage en Firebase Console
        // Por ahora guardamos sin archivos
        /*
        if (_logoFile != null) {
          logoUrl = await _businessService.uploadLogo(uid, _logoFile!);
        }

        if (_registroMercantilFile != null) {
          registroMercantilUrl = await _businessService.uploadRegistroMercantil(
              uid, _registroMercantilFile!);
        }
        */

        // Crear modelo de negocio
        final business = BusinessModel(
          uid: uid,
          nombreEmpresa: _nombreEmpresaController.text.trim(),
          nitRut: _nitRutController.text.trim(),
          numeroSucursales: _numeroSucursalesController.text.trim(),
          direccionPrincipal: _direccionController.text.trim(),
          ciudad: _ciudadController.text.trim(),
          telefono: _telefonoController.text.trim(),
          emailCorporativo: _emailCorporativoController.text.trim(),
          sitioWeb: _sitioWebController.text.trim(),
          logoUrl: logoUrl,
          registroMercantilUrl: registroMercantilUrl,
          createdAt: DateTime.now(),
        );

        // Guardar en Firestore
        await _businessService.saveBusinessData(business);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Registro empresarial completado exitosamente!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          // Navegar al home después de 1 segundo
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            // El AuthWrapper se encargará de mostrar el Home
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar datos: $e'),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Registrar empresa'),
        backgroundColor: const Color(0xFF7B4397),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nombre Empresa
              TextFormField(
                controller: _nombreEmpresaController,
                decoration: InputDecoration(
                  labelText: 'Nombre Empresa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              // NIT/RUT
              TextFormField(
                controller: _nitRutController,
                decoration: InputDecoration(
                  labelText: 'NIT/RUT',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              // Número Sucursales
              TextFormField(
                controller: _numeroSucursalesController,
                decoration: InputDecoration(
                  labelText: 'Número Sucursales',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              // Dirección Principal
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(
                  labelText: 'Dirección Principal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              // Ciudad
              TextFormField(
                controller: _ciudadController,
                decoration: InputDecoration(
                  labelText: 'Ciudad',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              // Teléfono
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              // Email Corporativo
              TextFormField(
                controller: _emailCorporativoController,
                decoration: InputDecoration(
                  labelText: 'Email Corporativo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Campo requerido';
                  if (!value!.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Sitio Web
              TextFormField(
                controller: _sitioWebController,
                decoration: InputDecoration(
                  labelText: 'Sitio Web',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Logo
              const Text(
                'Logo de la Empresa',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickLogo,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _logoFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_logoFile!, fit: BoxFit.cover),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload, size: 48),
                              SizedBox(height: 8),
                              Text('Sube tu Logo (PNG, JPG - Max 2MB)'),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Registro Mercantil
              const Text(
                'Registro Mercantil',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickRegistroMercantil,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: _registroMercantilFile != null
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Documento seleccionado'),
                            ],
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload, size: 32),
                              SizedBox(height: 8),
                              Text('Sube el Documento (PDF, JPG - Max 5MB)'),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Submit button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveBusinessData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4397),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Completar Registro',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

