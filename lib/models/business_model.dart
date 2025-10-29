class BusinessModel {
  final String uid;
  final String nombreEmpresa;
  final String nitRut;
  final String numeroSucursales;
  final String direccionPrincipal;
  final String ciudad;
  final String telefono;
  final String emailCorporativo;
  final String sitioWeb;
  final String? logoUrl; // URL del logo en Firebase Storage
  final String? registroMercantilUrl; // URL del documento en Firebase Storage
  final DateTime createdAt;

  BusinessModel({
    required this.uid,
    required this.nombreEmpresa,
    required this.nitRut,
    required this.numeroSucursales,
    required this.direccionPrincipal,
    required this.ciudad,
    required this.telefono,
    required this.emailCorporativo,
    required this.sitioWeb,
    this.logoUrl,
    this.registroMercantilUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombreEmpresa': nombreEmpresa,
      'nitRut': nitRut,
      'numeroSucursales': numeroSucursales,
      'direccionPrincipal': direccionPrincipal,
      'ciudad': ciudad,
      'telefono': telefono,
      'emailCorporativo': emailCorporativo,
      'sitioWeb': sitioWeb,
      'logoUrl': logoUrl,
      'registroMercantilUrl': registroMercantilUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      uid: map['uid'] ?? '',
      nombreEmpresa: map['nombreEmpresa'] ?? '',
      nitRut: map['nitRut'] ?? '',
      numeroSucursales: map['numeroSucursales'] ?? '',
      direccionPrincipal: map['direccionPrincipal'] ?? '',
      ciudad: map['ciudad'] ?? '',
      telefono: map['telefono'] ?? '',
      emailCorporativo: map['emailCorporativo'] ?? '',
      sitioWeb: map['sitioWeb'] ?? '',
      logoUrl: map['logoUrl'],
      registroMercantilUrl: map['registroMercantilUrl'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

