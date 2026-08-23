import 'package:decimal/decimal.dart';

class Stock {
  final String symbol;
  final String name;
  final Decimal basePrice;
  final Decimal prevClose;

  const Stock({
    required this.symbol,
    required this.name,
    required this.basePrice,
    required this.prevClose,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? "",
      basePrice: Decimal.tryParse(json['basePrice'] ?? "") ?? Decimal.zero,
      prevClose: Decimal.tryParse(json['prevClose'] ?? "") ?? Decimal.zero,
    );
  }

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'name': name,
        'basePrice': basePrice.toString(),
        'prevClose': prevClose.toString(),
      };

  @override
  String toString() => 'Stock($symbol)';

  @override
  bool operator ==(Object other) => other is Stock && other.symbol == symbol;

  @override
  int get hashCode => symbol.hashCode;
}
