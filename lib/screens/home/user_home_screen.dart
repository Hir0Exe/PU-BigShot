import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/offer_service.dart';
import '../../services/follow_service.dart';
import '../../models/offer_model.dart';
import 'user_search_screen.dart';
import 'user_following_screen.dart';
import 'user_settings_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _offerService = OfferService();
  final _followService = FollowService();
  
  int _currentIndex = 0;
  List<OfferModel> _offers = [];
  List<String> _followedBusinessIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final uid = authProvider.user!.uid;

      // Cargar IDs de empresas seguidas
      _followedBusinessIds = await _followService.getFollowedBusinessIds(uid);

      // Cargar ofertas con prioridad
      _offers = await _offerService.getOffersWithPriority(_followedBusinessIds);
    } catch (e) {
      print('Error cargando datos: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleFollow(OfferModel offer) async {
    try {
      final authProvider = context.read<AuthProvider>();
      final uid = authProvider.user!.uid;

      final isFollowing = _followedBusinessIds.contains(offer.businessId);

      if (isFollowing) {
        await _followService.unfollowBusiness(uid, offer.businessId);
        setState(() {
          _followedBusinessIds.remove(offer.businessId);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dejaste de seguir'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        await _followService.followBusiness(uid, offer.businessId, offer.businessName);
        setState(() {
          _followedBusinessIds.add(offer.businessId);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Ahora sigues este supermercado!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }

      // Recargar ofertas con nueva prioridad
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildHomeView() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF7B4397),
        ),
      );
    }

    if (_offers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay ofertas disponibles',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF7B4397),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _offers.length,
        itemBuilder: (context, index) {
          final offer = _offers[index];
          final isFollowing = _followedBusinessIds.contains(offer.businessId);
          final isExpiringSoon = offer.expirationDate.difference(DateTime.now()).inDays <= 2;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header del negocio
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B4397).withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Icono del supermercado
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7B4397),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.store,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Nombre del negocio
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              offer.businessName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7B4397),
                              ),
                            ),
                            if (isFollowing)
                              const Text(
                                'Siguiendo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Botón seguir/dejar de seguir
                      IconButton(
                        icon: Icon(
                          isFollowing ? Icons.person_remove : Icons.person_add,
                          color: isFollowing ? Colors.orange : const Color(0xFF7B4397),
                        ),
                        onPressed: () => _toggleFollow(offer),
                      ),
                    ],
                  ),
                ),

                // Contenido de la oferta
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7B4397),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Categoría
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7B4397).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          offer.category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7B4397),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        offer.description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Fecha de expiración
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isExpiringSoon 
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isExpiringSoon ? Colors.orange : Colors.green,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: isExpiringSoon ? Colors.orange : Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Válida hasta: ${offer.expirationDate.day}/${offer.expirationDate.month}/${offer.expirationDate.year}',
                              style: TextStyle(
                                fontSize: 13,
                                color: isExpiringSoon ? Colors.orange : Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildHomeView(),
      const UserSearchScreen(),
      const UserFollowingScreen(),
      const UserSettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE8D5F2),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/icon-48.png',
              height: 24,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.local_offer, size: 24);
              },
            ),
            const SizedBox(width: 8),
            const Text('BIGSHOT'),
          ],
        ),
        backgroundColor: const Color(0xFF7B4397),
        foregroundColor: Colors.white,
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // TODO: Implementar notificaciones
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notificaciones próximamente'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            _loadData(); // Recargar al volver a inicio
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF7B4397),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Siguiendo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
