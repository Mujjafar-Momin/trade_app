/// The two sides of a simulated market order.
enum OrderSide { buy, sell }

extension OrderSideX on OrderSide {
  String get label => this == OrderSide.buy ? 'Buy' : 'Sell';

  static OrderSide fromString(String value) {
    return value.toLowerCase() == 'buy' ? OrderSide.buy : OrderSide.sell;
  }
}
