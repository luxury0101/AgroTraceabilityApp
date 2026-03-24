class ApiEndpoints {
  static const String login = '/auth/login';
  static const String lotes = '/lotes';
  static const String eventos = '/eventos';
  static const String insumos = '/insumos';
  static const String trazabilidad = '/trazabilidad';

  static String eventosByLote(String loteId) => '/eventos/lote/$loteId';
  static String trazabilidadByLote(String loteId) =>
      '/trazabilidad/lote/$loteId';
}
