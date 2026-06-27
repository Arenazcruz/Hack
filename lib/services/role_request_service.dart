import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/role_request.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class RoleRequestService {
  RoleRequestService({
    FirebaseFirestore? firestore,
    AuthService? authService,
    FirestoreService? firestoreService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _authService = authService ?? AuthService(),
       _firestoreService = firestoreService ?? FirestoreService();

  final FirebaseFirestore _firestore;
  final AuthService _authService;
  final FirestoreService _firestoreService;

  CollectionReference<Map<String, dynamic>> get _roleRequests =>
      _firestore.collection('role_requests');

  Future<void> createEntrepreneurRequest({
    required String nombreLugar,
    required String ciudad,
    required String ubicacion,
    required String categoria,
    required String descripcion,
    required String telefonoContacto,
    String? redSocial,
  }) {
    return _createRoleRequest(
      rolSolicitado: 'emprendedor',
      tipoSolicitud: 'emprendimiento',
      nombreLugar: nombreLugar,
      ciudad: ciudad,
      ubicacion: ubicacion,
      categoria: categoria,
      descripcion: descripcion,
      telefonoContacto: telefonoContacto,
      redSocial: redSocial,
      referencias: redSocial,
    );
  }

  Future<void> createGastronomicRequest({
    required String nombreLugar,
    required String ciudad,
    required String ubicacion,
    required String categoria,
    required String horarios,
    required String descripcion,
    required String telefonoContacto,
    String? sitioWeb,
    String? redSocial,
  }) {
    return _createRoleRequest(
      rolSolicitado: 'gastronomico',
      tipoSolicitud: 'negocio_gastronomico',
      nombreLugar: nombreLugar,
      ciudad: ciudad,
      ubicacion: ubicacion,
      categoria: categoria,
      horarios: horarios,
      descripcion: descripcion,
      telefonoContacto: telefonoContacto,
      sitioWeb: sitioWeb,
      redSocial: redSocial,
      referencias: redSocial ?? sitioWeb,
    );
  }

  Future<void> createGuideRequest({
    required String nombrePerfilGuia,
    required String ciudad,
    required String zonasTrabajo,
    required String tipoServicio,
    required String experienciaPrevia,
    required String idiomas,
    required String disponibilidad,
    required String presentacionPersonal,
    required String telefonoContacto,
    String? referencias,
    String? redSocial,
  }) {
    return _createRoleRequest(
      rolSolicitado: 'guia',
      tipoSolicitud: 'guia_turistico',
      nombreLugar: nombrePerfilGuia,
      ciudad: ciudad,
      ubicacion: zonasTrabajo,
      descripcion: presentacionPersonal,
      telefonoContacto: telefonoContacto,
      experienciaPrevia: experienciaPrevia,
      idiomas: idiomas,
      disponibilidad: disponibilidad,
      zonasTrabajo: zonasTrabajo,
      tipoServicio: tipoServicio,
      referencias: referencias ?? redSocial,
      redSocial: redSocial,
    );
  }

  Future<void> _createRoleRequest({
    required String rolSolicitado,
    required String tipoSolicitud,
    required String nombreLugar,
    required String ubicacion,
    required String ciudad,
    required String descripcion,
    required String telefonoContacto,
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
  }) async {
    final user = _authService.currentUser;

    if (user == null) {
      throw const RoleRequestException('Debes iniciar sesión.');
    }

    final profile = await _firestoreService.getUserProfile(user.uid);

    if (profile == null) {
      throw const RoleRequestException('No se encontró tu perfil.');
    }

    final existingRequest = await _roleRequests
        .where('uid', isEqualTo: user.uid)
        .where('rolSolicitado', isEqualTo: rolSolicitado)
        .where('estado', isEqualTo: 'pendiente')
        .limit(1)
        .get();

    if (existingRequest.docs.isNotEmpty) {
      throw const RoleRequestException(
        'Ya tienes una solicitud pendiente para este tipo de perfil.',
      );
    }

    final doc = _roleRequests.doc();
    final request = RoleRequest(
      id: doc.id,
      uid: user.uid,
      nombreUsuario: profile.name,
      email: profile.email,
      rolActual: profile.role,
      rolSolicitado: rolSolicitado,
      tipoSolicitud: tipoSolicitud,
      nombreLugar: nombreLugar.trim(),
      ubicacion: ubicacion.trim(),
      ciudad: ciudad.trim(),
      descripcion: descripcion.trim(),
      telefonoContacto: telefonoContacto.trim(),
      estado: 'pendiente',
      fechaSolicitud: DateTime.now(),
      categoria: _cleanOptional(categoria),
      horarios: _cleanOptional(horarios),
      referencias: _cleanOptional(referencias),
      redSocial: _cleanOptional(redSocial),
      sitioWeb: _cleanOptional(sitioWeb),
      experienciaPrevia: _cleanOptional(experienciaPrevia),
      idiomas: _cleanOptional(idiomas),
      disponibilidad: _cleanOptional(disponibilidad),
      zonasTrabajo: _cleanOptional(zonasTrabajo),
      tipoServicio: _cleanOptional(tipoServicio),
      motivacion: _cleanOptional(motivacion),
      lugaresIncluidos: _cleanOptional(lugaresIncluidos),
      duracionAproximada: _cleanOptional(duracionAproximada),
    );

    await doc.set(request.toMap());
  }

  Stream<List<RoleRequest>> getMyRoleRequests() {
    final user = _authService.currentUser;

    if (user == null) {
      throw const RoleRequestException('Debes iniciar sesión.');
    }

    return _roleRequests.where('uid', isEqualTo: user.uid).snapshots().map((
      snapshot,
    ) {
      final requests = snapshot.docs
          .map((doc) => RoleRequest.fromMap(doc.data()))
          .toList();
      requests.sort(_compareNewestFirst);
      return requests;
    });
  }

  Stream<List<RoleRequest>> getPendingRoleRequestsForAdmin() {
    return _roleRequests
        .where('estado', isEqualTo: 'pendiente')
        .snapshots()
        .map((snapshot) {
          final requests = snapshot.docs
              .map((doc) => RoleRequest.fromMap(doc.data()))
              .toList();
          requests.sort(_compareNewestFirst);
          return requests;
        });
  }

  Future<void> approveRoleRequest(
    RoleRequest request, {
    String? comentarioAdmin,
  }) async {
    final admin = _authService.currentUser;

    if (admin == null) {
      throw const RoleRequestException(
        'Debes iniciar sesión como administrador.',
      );
    }

    final batch = _firestore.batch();
    final requestRef = _roleRequests.doc(request.id);
    final userRef = _firestore.collection('users').doc(request.uid);

    batch.update(requestRef, {
      'estado': 'aprobado',
      'fechaRevision': Timestamp.now(),
      'revisadoPor': admin.uid,
      'comentarioAdmin':
          _cleanOptional(comentarioAdmin) ?? 'Solicitud aprobada.',
    });
    batch.update(userRef, {'role': request.rolSolicitado});

    await batch.commit();
  }

  Future<void> rejectRoleRequest(
    RoleRequest request,
    String comentarioAdmin,
  ) async {
    final admin = _authService.currentUser;

    if (admin == null) {
      throw const RoleRequestException(
        'Debes iniciar sesión como administrador.',
      );
    }

    await _roleRequests.doc(request.id).update({
      'estado': 'rechazado',
      'fechaRevision': Timestamp.now(),
      'revisadoPor': admin.uid,
      'comentarioAdmin': comentarioAdmin.trim().isEmpty
          ? 'Solicitud rechazada.'
          : comentarioAdmin.trim(),
    });
  }

  static int _compareNewestFirst(RoleRequest a, RoleRequest b) {
    final aDate = a.fechaSolicitud ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bDate = b.fechaSolicitud ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bDate.compareTo(aDate);
  }
}

String? _cleanOptional(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) {
    return null;
  }
  return text;
}

class RoleRequestException implements Exception {
  const RoleRequestException(this.message);

  final String message;

  @override
  String toString() => message;
}
