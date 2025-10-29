import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import '../../services/business_service.dart';
import '../../models/business_model.dart';
import '../auth/login_screen.dart';

class BusinessSettingsScreen extends StatelessWidget {
  const BusinessSettingsScreen({Key? key}) : super(key: key);

  Future<void> _handleDeleteAccount(BuildContext context) async {
    // Mostrar diálogo de confirmación
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar tu cuenta empresarial?\n\n'
          'Esta acción es IRREVERSIBLE y se eliminarán:\n'
          '• Información de tu empresa\n'
          '• Todos tus anuncios publicados\n'
          '• Tus seguidores\n'
          '• Todo tu historial\n\n'
          '¿Deseas continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              backgroundColor: Colors.red.withOpacity(0.1),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Mostrar loading
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF7B4397),
            ),
          ),
        );
      }

      try {
        final authService = AuthService();
        await authService.deleteAccount();

        if (context.mounted) {
          Navigator.of(context).pop(); // Cerrar loading
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cuenta eliminada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Cerrar loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar cuenta: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final uid = authProvider.user?.uid ?? '';
    final businessService = BusinessService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: const Color(0xFF7B4397),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<BusinessModel?>(
        future: businessService.getBusinessData(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final business = snapshot.data;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Información de la empresa
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información de la Empresa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7B4397),
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      _InfoRow(
                        icon: Icons.business,
                        label: 'Nombre',
                        value: business?.nombreEmpresa ?? 'No disponible',
                      ),
                      _InfoRow(
                        icon: Icons.badge,
                        label: 'NIT/RUT',
                        value: business?.nitRut ?? 'No disponible',
                      ),
                      _InfoRow(
                        icon: Icons.store,
                        label: 'Sucursales',
                        value: business?.numeroSucursales ?? 'No disponible',
                      ),
                      _InfoRow(
                        icon: Icons.location_on,
                        label: 'Dirección',
                        value: business?.direccionPrincipal ?? 'No disponible',
                      ),
                      _InfoRow(
                        icon: Icons.location_city,
                        label: 'Ciudad',
                        value: business?.ciudad ?? 'No disponible',
                      ),
                      _InfoRow(
                        icon: Icons.phone,
                        label: 'Teléfono',
                        value: business?.telefono ?? 'No disponible',
                      ),
                      _InfoRow(
                        icon: Icons.email,
                        label: 'Email',
                        value: business?.emailCorporativo ?? 'No disponible',
                      ),
                      _InfoRow(
                        icon: Icons.language,
                        label: 'Sitio Web',
                        value: business?.sitioWeb ?? 'No disponible',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Cuenta
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.account_circle,
                        color: Color(0xFF7B4397),
                      ),
                      title: const Text('Cuenta'),
                      subtitle: Text(authProvider.user?.email ?? ''),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Cerrar Sesión'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Cerrar Sesión'),
                            content: const Text(
                              '¿Estás seguro de que deseas cerrar sesión?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  authProvider.signOut();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Cerrar Sesión',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.delete_forever, color: Colors.red[900]),
                      title: Text(
                        'Eliminar Cuenta',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900],
                        ),
                      ),
                      onTap: () => _handleDeleteAccount(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Información de la app
              const Center(
                child: Text(
                  'BigShot v1.0.0',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

