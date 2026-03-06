class TranslationHelper {
  static String translateCondition(String condition) {
    switch (condition) {
      case 'new':
        return 'Nuevo';
      case 'like_new':
        return 'Como nuevo';
      case 'good':
        return 'Bueno';
      case 'acceptable':
        return 'Aceptable';
      case 'poor':
        return 'Desgastado';
      default:
        return condition;
    }
  }

  static String translateOperation(String type) {
    switch (type) {
      case 'sale':
        return 'Venta';
      case 'exchange':
        return 'Intercambio';
      case 'both':
        return 'Venta / Intercambio';
      default:
        return type;
    }
  }
}
