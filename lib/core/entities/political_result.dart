/// Modelo de datos para pasar al widget desde fuera
class PoliticalResult {
  final String userName;
  final double economicPosition; // -1.0 (izquierda) a 1.0 (derecha)
  final double economicMaxPosition;

  final double authorityPosition; // -1.0 (totalitario) a 1.0 (liberal)
  final double authorityMaxPosition;
  const PoliticalResult({
    required this.economicPosition,
    required this.authorityPosition,
    required this.economicMaxPosition,
    required this.authorityMaxPosition,
    required this.userName,
  });

  Map<String, dynamic> toJson() => {
    'economicPosition': economicPosition,
    'authorityPosition': authorityPosition,
    'economicMaxPosition': economicMaxPosition,
    'authorityMaxPosition': authorityMaxPosition,
    'userName': userName,
  };

  factory PoliticalResult.fromJson(Map<String, dynamic> json) =>
      PoliticalResult(
        userName: json['userName'] as String,
        economicPosition: json['economicPosition'] as double,
        authorityPosition: json['authorityPosition'] as double,
        economicMaxPosition: json['economicMaxPosition'] as double,
        authorityMaxPosition: json['authorityMaxPosition'] as double,
      );
}
