import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/auth_service.dart';
import '../../services/offer_service.dart';
import '../../services/business_service.dart';
import '../../models/offer_model.dart';

class CreateOfferScreen extends StatefulWidget {
  final OfferModel? offer; // Oferta a editar (null si es nueva)
  
  const CreateOfferScreen({Key? key, this.offer}) : super(key: key);

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customCategoryController = TextEditingController();
  final _offerService = OfferService();
  final _businessService = BusinessService();
  final _imagePicker = ImagePicker();
  
  final List<String> _categories = [
    'FRESCOS',
    'DESPENSA',
    'BEBIDAS',
    'CUIDADO PERSONAL',
    'PRODUCTOS DEL HOGAR',
    'TECNOLOGÍA',
    'ROPA Y CALZADO',
    'JUGUETES',
    'OTROS',
  ];

  String _selectedCategory = 'FRESCOS';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Si estamos editando, cargar los datos de la oferta
    if (widget.offer != null) {
      _titleController.text = widget.offer!.title;
      _descriptionController.text = widget.offer!.description;
      _selectedCategory = widget.offer!.category;
      _selectedDate = widget.offer!.expirationDate;
      
      // Si la categoría no está en la lista, es personalizada
      if (!_categories.contains(_selectedCategory)) {
        _customCategoryController.text = _selectedCategory;
        _selectedCategory = 'OTROS';
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE53935),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _createOffer() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authService = AuthService();
        final uid = authService.currentUser!.uid;

        // Obtener nombre del negocio
        final business = await _businessService.getBusinessData(uid);
        final businessName = business?.nombreEmpresa ?? 'Supermercado';

        // Determinar la categoría final
        final finalCategory = _selectedCategory == 'OTROS'
            ? _customCategoryController.text.trim().toUpperCase()
            : _selectedCategory;

        // TODO: Subir imagen cuando Storage esté habilitado
        String? imageUrl = widget.offer?.imageUrl; // Mantener URL existente si estamos editando
        // if (_imageFile != null) {
        //   imageUrl = await _businessService.uploadOfferImage(uid, _imageFile!);
        // }

        final offer = OfferModel(
          id: widget.offer?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          businessId: uid,
          businessName: businessName,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: finalCategory,
          imageUrl: imageUrl,
          expirationDate: _selectedDate,
          createdAt: widget.offer?.createdAt ?? DateTime.now(),
        );

        // Si estamos editando, actualizar; si no, crear nueva
        if (widget.offer != null) {
          await _offerService.updateOffer(offer);
        } else {
          await _offerService.createOffer(offer);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.offer != null 
                ? '¡Anuncio actualizado exitosamente!' 
                : '¡Anuncio publicado exitosamente!'),
              backgroundColor: Colors.green,
            ),
          );

          // Si estamos editando, volver atrás; si no, limpiar formulario
          if (widget.offer != null) {
            Navigator.pop(context);
          } else {
            // Limpiar formulario
            _titleController.clear();
            _descriptionController.clear();
            _customCategoryController.clear();
            setState(() {
              _selectedCategory = 'FRESCOS';
              _selectedDate = DateTime.now().add(const Duration(days: 7));
              _imageFile = null;
            });
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.offer != null ? 'Editar Anuncio' : 'Crear Anuncio'),
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: widget.offer != null, // Mostrar botón de volver solo al editar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Image.asset(
                'assets/images/logo.png',
                height: 120,
              ),
              const SizedBox(height: 32),

              // Nombre de la promoción
              const Text(
                'Nombre de la promoción',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
                maxLength: 50,
              ),
              const SizedBox(height: 16),

              // Categoría
              const Text(
                'Categoría',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[400]!, width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory,
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                  ),
                ),
              ),

              // Campo personalizado si selecciona OTROS
              if (_selectedCategory == 'OTROS') ...[
                const SizedBox(height: 16),
                const Text(
                  'Especifica la categoría',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _customCategoryController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Ej: MASCOTAS, DEPORTES, etc.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (_selectedCategory == 'OTROS') {
                      return value?.isEmpty ?? true ? 'Campo requerido' : null;
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 16),

              // Descripción
              const Text(
                'Descripción',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
                  ),
                ),
                maxLines: 5,
                maxLength: 200,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),

              // Imagen del anuncio
              const Text(
                'Imagen del anuncio de la promoción',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_imageFile!, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Sube una imagen promocional (PNG, JPG - Max 2MB)',
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Fecha límite
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                leading: const Icon(Icons.calendar_today, color: Color(0xFFE53935)),
                title: const Text('Fecha Límite'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 32),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              _titleController.clear();
                              _descriptionController.clear();
                              _customCategoryController.clear();
                              setState(() {
                                _selectedCategory = 'FRESCOS';
                                _imageFile = null;
                              });
                            },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createOffer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(widget.offer != null ? 'Actualizar' : 'Publicar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
