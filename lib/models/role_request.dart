import 'package:cloud_firestore/cloud_firestore.dart';

class RoleRequest {
  const RoleRequest({
    required this.id,
    required this.uid,
    required this.nombreUsuario,
    required this.email,
    required this.rolActual,
    required this.rolSolicitado,
    required this.tipoSolicitud,
    required this.nombreLugar,
    required this.ubicacion,
    required this.ciudad,
    required this.descripcion,
    required this.telefonoContacto,
    required this.estado,
    this.fechaSolicitud,
    this.fechaRevision,
    this.revisadoPor,
    this.comentarioAdmin,
    this.categoria,
    this.horarios,
    this.referencias,
    this.redSocial,
    this.sitioWeb,
    this.experienciaPrevia,
    this.idiomas,
    this.disponibilidad,
    this.zonasTrabajo,
    this.tipoServicio,
    this.motivacion,
    this.lugaresIncluidos,
    this.duracionAproximada,
  });

  final String id;
  final String uid;
  final String nombreUsuario;
  final String email;
  final String rolActual;
  final String rolSolicitado;
  final String tipoSolicitud;
  final String nombreLugar;
  final String ubicacion;
  final String ciudad;
  final String descripcion;
  final String telefonoContacto;
  final String estado;
  final DateTime? fechaSolicitud;
  final DateTime? fechaRevision;
  final String? revisadoPor;
  final String? comentarioAdmin;
  final String? categoria;
  final String? horarios;
  final String? referencias;
  final String? redSocial;
  final String? sitioWeb;
  final String? experienciaPrevia;
  final String? idiomas;
  final String? disponibilidad;
  final String? zonasTrabajo;
  final String? tipoServicio;
  final String? motivacion;
  final String? lugaresIncluidos;
  final String? duracionAproximada;

  factory RoleRequest.fromMap(Map<String, dynamic>? map) {
    final data = map ?? const <String, dynamic>{};

    return RoleRequest(
      id: _readString(data['id']),
      uid: _readString(data['uid']),
      nombreUsuario: _readString(data['nombreUsuario']),
      email: _readString(data['email']),
      rolActual: _readString(data['rolActual'], fallback: 'cliente'),
      rolSolicitado: _readString(data['rolSolicitado']),
      tipoSolicitud: _readString(data['tipoSolicitud']),
      nombreLugar: _readString(data['nombreLugar']),
      ubicacion: _readString(data['ubicacion']),
      ciudad: _readString(data['ciudad']),
      descripcion: _readString(data['descripcion']),
      telefonoContacto: _readString(data['telefonoContacto']),
      estado: _readString(data['estado'], fallback: 'pendiente'),
      fechaSolicitud: _readNullableDateTime(data['fechaSolicitud']),
      fechaRevision: _readNullableDateTime(data['fechaRevision']),
      revisadoPor: _readNullableString(data['revisadoPor']),
      comentarioAdmin: _readNullableString(data['comentarioAdmin']),
      categoria: _readNullableString(data['categoria']),
      horarios: _readNullableString(data['horarios']),
      referencias: _readNullableString(data['referencias']),
      redSocial: _readNullableString(data['redSocial']),
      sitioWeb: _readNullableString(data['sitioWeb']),
      experienciaPrevia: _readNullableString(data['experienciaPrevia']),
      idiomas: _readNullableString(data['idiomas']),
      disponibilidad: _readNullableString(data['disponibilidad']),
      zonasTrabajo: _readNullableString(data['zonasTrabajo']),
      tipoServicio: _readNullableString(data['tipoServicio']),
      motivacion: _readNullableString(data['motivacion']),
      lugaresIncluidos: _readNullableString(data['lugaresIncluidos']),
      duracionAproximada: _readNullableString(data['duracionAproximada']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'nombreUsuario': nombreUsuario,
      'email': email,
      'rolActual': rolActual,
      'rolSolicitado': rolSolicitado,
      'tipoSolicitud': tipoSolicitud,
      'nombreLugar': nombreLugar,
      'ubicacion': ubicacion,
      'ciudad': ciudad,
      'descripcion': descripcion,
      'telefonoContacto': telefonoContacto,
      'estado': estado,
      'fechaSolicitud': fechaSolicitud == null
          ? null
          : Timestamp.fromDate(fechaSolicitud!),
      'fechaRevision': fechaRevision == null
          ? null
          : Timestamp.fromDate(fechaRevision!),
      'revisadoPor': revisadoPor,
      'comentarioAdmin': comentarioAdmin,
      'categoria': categoria,
      'horarios': horarios,
      'referencias': referencias,
      'redSocial': redSocial,
      'sitioWeb': sitioWeb,
      'experienciaPrevia': experienciaPrevia,
      'idiomas': idiomas,
      'disponibilidad': disponibilidad,
      'zonasTrabajo': zonasTrabajo,
      'tipoServicio': tipoServicio,
      'motivacion': motivacion,
      'lugaresIncluidos': lugaresIncluidos,
      'duracionAproximada': duracionAproximada,
    };
  }

  RoleRequest copyWith({
    String? id,
    String? uid,
    String? nombreUsuario,
    String? email,
    String? rolActual,
    String? rolSolicitado,
    String? tipoSolicitud,
    String? nombreLugar,
    String? ubicacion,
    String? ciudad,
    String? descripcion,
    String? telefonoContacto,
    String? estado,
    DateTime? fechaSolicitud,
    DateTime? fechaRevision,
    String? revisadoPor,
    String? comentarioAdmin,
    String? categoria,
    String? horarios,
    String? referencias,
    String? redSocial,
    String? sitioWeb,
    String? experienciaPrevia,
    String? idiomas,
    String? disponibilidad,
    String? zonasTrabajo,
    String? tipoServicio,
    String? motivacion,
    String? lugaresIncluidos,
    String? duracionAproximada,
  }) {
    return RoleRequest(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      email: email ?? this.email,
      rolActual: rolActual ?? this.rolActual,
      rolSolicitado: rolSolicitado ?? this.rolSolicitado,
      tipoSolicitud: tipoSolicitud ?? this.tipoSolicitud,
      nombreLugar: nombreLugar ?? this.nombreLugar,
      ubicacion: ubicacion ?? this.ubicacion,
      ciudad: ciudad ?? this.ciudad,
      descripcion: descripcion ?? this.descripcion,
      telefonoContacto: telefonoContacto ?? this.telefonoContacto,
      estado: estado ?? this.estado,
      fechaSolicitud: fechaSolicitud ?? this.fechaSolicitud,
      fechaRevision: fechaRevision ?? this.fechaRevision,
      revisadoPor: revisadoPor ?? this.revisadoPor,
      comentarioAdmin: comentarioAdmin ?? this.comentarioAdmin,
      categoria: categoria ?? this.categoria,
      horarios: horarios ?? this.horarios,
      referencias: referencias ?? this.referencias,
      redSocial: redSocial ?? this.redSocial,
      sitioWeb: sitioWeb ?? this.sitioWeb,
      experienciaPrevia: experienciaPrevia ?? this.experienciaPrevia,
      idiomas: idiomas ?? this.idiomas,
      disponibilidad: disponibilidad ?? this.disponibilidad,
      zonasTrabajo: zonasTrabajo ?? this.zonasTrabajo,
      tipoServicio: tipoServicio ?? this.tipoServicio,
      motivacion: motivacion ?? this.motivacion,
      lugaresIncluidos: lugaresIncluidos ?? this.lugaresIncluidos,
      duracionAproximada: duracionAproximada ?? this.duracionAproximada,
    );
  }
}

String _readString(Object? value, {String fallback = ''}) {
  if (value == null) {
    return fallback;
  }

  final text = value.toString().trim();
  return text.isEmpty ? fallback : text;
}

String? _readNullableString(Object? value) {
  if (value == null) {
    return null;
  }

  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

DateTime? _readNullableDateTime(Object? value) {
  if (value == null) {
    return null;
  }

  if (value is Timestamp) {
    return value.toDate();
  }

  if (value is DateTime) {
    return value;
  }

  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  if (value is String) {
    return DateTime.tryParse(value);
  }

  return null;
}
