String translateCondition(String? condition) {
  switch (condition?.toLowerCase()) {
    case 'new':
      return 'Nuevo';
    case 'like_new':
      return 'Como nuevo';
    case 'good':
      return 'Buen estado';
    case 'acceptable':
      return 'Aceptable';
    case 'poor':
      return 'Deteriorado';
    default:
      return 'Desconocido';
  }
}

String translateOperationType(String? operationType) {
  switch (operationType?.toLowerCase()) {
    case 'sale':
      return 'Venta';
    case 'exchange':
      return 'Intercambio';
    case 'both':
      return 'Venta o Intercambio';
    default:
      return 'Desconocido';
  }
}

String translateStatus(String? status) {
  switch (status?.toLowerCase()) {
    case 'pending':
      return 'Pendiente';
    case 'completed':
      return 'Completado';
    case 'confirmed':
      return 'Confirmado';
    case 'cancelled':
      return 'Cancelado';
    case 'joined':
      return 'Inscrito';
    case 'waitlist':
      return 'Lista de espera';
    default:
      return 'Desconocido';
  }
}

extension BackendTranslations on String? {
  String toEsCondition() => translateCondition(this);

  String toEsOperationType() => translateOperationType(this);

  String toEsStatus() => translateStatus(this);
}
