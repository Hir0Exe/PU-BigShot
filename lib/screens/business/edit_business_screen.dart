import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/business_model.dart';
import '../../services/business_service.dart';
import '../../services/auth_service.dart';

class EditBusinessScreen extends StatefulWidget {
  final BusinessModel? currentBusiness;
  
  const EditBusinessScreen({
    Key? key,
    this.currentBusiness,
  }) : super(key: key);

  @override
  State<EditBusinessScreen> createState() => _EditBusinessScreenState();
}

class _EditBusinessScreenState extends State<EditBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessService = BusinessService();
  final _imagePicker = ImagePicker();

  // Controllers
  late final TextEditingController _nombreEmpresaController;
  late final TextEditingController _nitRutController;
  late final TextEditingController _numeroSucursalesController;
  late final TextEditingController _direccionController;
  late final TextEditingController _ciudadController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _emailCorporativoController;
  late final TextEditingController _sitioWebController;

  File? _logoFile;
  File? _registroMercantilFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Inicializar controllers con datos existentes o vacíos
    _nombreEmpresaController = TextEditingController(
      text: widget.currentBusiness?.nombreEmpresa ?? '',
    );
    _nitRutController = TextEditingController(
      text: widget.currentBusiness?.nitRut ?? '',
    );
    _numeroSucursalesController = TextEditingController(
      text: widget.currentBusiness?.numeroSucursales ?? '',
    );
    _direccionController = TextEditingController(
      text: widget.currentBusiness?.direccionPrincipal ?? '',
    );
    _ciudadController = TextEditingController(
      text: widget.currentBusiness?.ciudad ?? '',
    );
    _telefonoController = TextEditingController(
      text: widget.currentBusiness?.telefono ?? '',
    );
    _emailCorporativoController = TextEditingController(
      text: widget.currentBusiness?.emailCorporativo ?? '',
    );
    _sitioWebController = TextEditingController(
      text: widget.currentBusiness?.sitioWeb ?? '',
    );
  }

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
        final authService = AuthService();
        final uid = authService.currentUser!.uid;

        // Mantener URLs existentes si no se subieron nuevos archivos
        String? logoUrl = widget.currentBusiness?.logoUrl;
        String? registroMercantilUrl = widget.currentBusiness?.registroMercantilUrl;

        // TODO: Habilitar Firebase Storage en Firebase Console
        // Por ahora guardamos sin actualizar archivos
        /*
        if (_logoFile != null) {
          logoUrl = await _businessService.uploadLogo(uid, _logoFile!);
        }

        if (_registroMercantilFile != null) {
          registroMercantilUrl = await _businessService.uploadRegistroMercantil(
              uid, _registroMercantilFile!);
        }
        */

        // Crear modelo de negocio actualizado
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
          createdAt: widget.currentBusiness?.createdAt ?? DateTime.now(),
        );

        // Guardar en Firestore
        await _businessService.saveBusinessData(business);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Datos actualizados exitosamente!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          // Volver a la pantalla anterior
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar datos: $e'),
              backgroundColor: Colors.red,
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
    final isNewBusiness = widget.currentBusiness == null;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isNewBusiness ? 'Completar Datos' : 'Editar Empresa'),
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isNewBusiness) ...[
                const Text(
                  'Completa los datos de tu empresa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE53935),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Esta información será visible para los usuarios',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
              ],
              
              // Nombre Empresa
              TextFormField(
                controller: _nombreEmpresaController,
                decoration: InputDecoration(
                  labelText: 'Nombre Empresa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE53935)),
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE53935)),
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE53935)),
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE53935)),
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE53935)),
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE53935)),
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE53935)),
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
                  labelText: 'Sitio Web (opcional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE53935)),
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
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _logoFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_logoFile!, fit: BoxFit.cover),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_upload, size: 48, color: Color(0xFFE53935)),
                              const SizedBox(height: 8),
                              Text(
                                widget.currentBusiness?.logoUrl != null
                                    ? 'Cambiar Logo (PNG, JPG - Max 2MB)'
                                    : 'Sube tu Logo (PNG, JPG - Max 2MB)',
                                style: const TextStyle(color: Colors.grey),
                              ),
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
                    border: Border.all(color: Colors.grey[300]!),
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
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_upload, size: 32, color: Color(0xFFE53935)),
                              const SizedBox(height: 8),
                              Text(
                                widget.currentBusiness?.registroMercantilUrl != null
                                    ? 'Cambiar Documento (PDF, JPG - Max 5MB)'
                                    : 'Sube el Documento (PDF, JPG - Max 5MB)',
                                style: const TextStyle(color: Colors.grey),
                              ),
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
                  backgroundColor: const Color(0xFFE53935),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        isNewBusiness ? 'Completar Registro' : 'Guardar Cambios',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

