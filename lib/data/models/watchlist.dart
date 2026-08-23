class Watchlist {
  final String id;
  String name;
  List<String> symbols;
  final DateTime createdAt;

  Watchlist({
    required this.id,
    required this.name,
    List<String>? symbols,
    DateTime? createdAt,
  })  : symbols = symbols ?? [],
        createdAt = createdAt ?? DateTime.now();

  factory Watchlist.fromJson(Map<String, dynamic> json) {
    return Watchlist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbols: (json['symbols'] as List<dynamic>).cast<String>(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? "") ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'symbols': symbols,
        'createdAt': createdAt.toIso8601String(),
      };

  bool get isEmpty => symbols.isEmpty;

  Watchlist copyWith({String? name, List<String>? symbols}) {
    return Watchlist(
      id: id,
      name: name ?? this.name,
      symbols: symbols ?? List<String>.from(this.symbols),
      createdAt: createdAt,
    );
  }
}
