import 'package:flutter/material.dart';
import '../../services/offer_service.dart';
import '../../models/offer_model.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({Key? key}) : super(key: key);

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final _offerService = OfferService();
  final _searchController = TextEditingController();
  
  final List<String> _categories = [
    'TODAS',
    'FRESCOS',
    'DESPENSA',
    'BEBIDAS',
    'CUIDADO PERSONAL',
    'PRODUCTOS DEL HOGAR',
    'TECNOLOGÍA',
    'ROPA Y CALZADO',
    'JUGUETES',
  ];

  String _selectedCategory = 'TODAS';
  bool _includeExpired = false;
  List<OfferModel> _searchResults = [];
  bool _isLoading = false;
  bool _showFilters = true;

  @override
  void initState() {
    super.initState();
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _offerService.searchOffers(
        category: _selectedCategory == 'TODAS' ? null : _selectedCategory,
        includeExpired: _includeExpired,
        searchQuery: _searchController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _searchResults = results;
        });
      }
    } catch (e) {
      print('Error en búsqueda: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de búsqueda
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      // No hacer nada, ya estamos en el bottom nav
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _performSearch(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _performSearch,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Botón para mostrar/ocultar filtros
              TextButton.icon(
                icon: Icon(
                  _showFilters ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                ),
                label: const Text('Filtros'),
                onPressed: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
              ),
            ],
          ),
        ),

        // Panel de filtros (desplegable)
        if (_showFilters)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                // Categorías
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                        _performSearch();
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: const Color(0xFF7B4397).withOpacity(0.3),
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFF7B4397) : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // Checkbox incluir vencidas
                CheckboxListTile(
                  title: const Text('Incluir ofertas vencidas'),
                  value: _includeExpired,
                  onChanged: (value) {
                    setState(() {
                      _includeExpired = value ?? false;
                    });
                    _performSearch();
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: const Color(0xFF7B4397),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

        // Resultados
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF7B4397),
                  ),
                )
              : _searchResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No se encontraron resultados',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final offer = _searchResults[index];
                        final isExpired = offer.expirationDate.isBefore(DateTime.now());

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Negocio y categoría
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        offer.businessName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF7B4397),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF7B4397).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        offer.category,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF7B4397),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Título
                                Text(
                                  offer.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Descripción
                                Text(
                                  offer.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                // Fecha
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: isExpired ? Colors.red : Colors.green,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isExpired
                                          ? 'Vencida el ${offer.expirationDate.day}/${offer.expirationDate.month}/${offer.expirationDate.year}'
                                          : 'Válida hasta ${offer.expirationDate.day}/${offer.expirationDate.month}/${offer.expirationDate.year}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isExpired ? Colors.red : Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

