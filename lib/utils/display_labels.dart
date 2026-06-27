String roleLabel(String role) {
  switch (role.trim().toLowerCase()) {
    case 'cliente':
    case 'client':
      return 'Cliente';
    case 'emprendedor':
    case 'entrepreneur':
      return 'Emprendedor';
    case 'gastronomico':
    case 'gastronomic':
      return 'Gastronómico';
    case 'guia':
    case 'guide':
      return 'Guía turístico';
    case 'turista':
    case 'tourist':
      return 'Turista';
    case 'administrador':
    case 'admin':
      return 'Administrador';
    default:
      return role;
  }
}

String requestTypeLabel(String type) {
  switch (type.trim().toLowerCase()) {
    case 'emprendimiento':
      return 'Emprendimiento';
    case 'negocio_gastronomico':
      return 'Negocio gastronómico';
    case 'guia_turistico':
      return 'Guía turístico';
    case 'ruta_turistica':
      return 'Ruta turística';
    case 'turista':
      return 'Turista';
    default:
      return type;
  }
}

String requestStatusLabel(String status) {
  switch (status.trim().toLowerCase()) {
    case 'pendiente':
      return 'Pendiente';
    case 'aprobado':
      return 'Aprobado';
    case 'rechazado':
      return 'Rechazado';
    default:
      return status;
  }
}
