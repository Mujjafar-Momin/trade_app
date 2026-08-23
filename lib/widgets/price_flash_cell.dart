import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class PriceFlashCell extends StatelessWidget {
  final Rx<PriceTick> priceRx;
  final Widget Function(BuildContext context, PriceTick tick, Color dotColor) builder;

  const PriceFlashCell({super.key, required this.priceRx, required this.builder});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Obx(() {
      final tick = priceRx.value;
      final dotColor = tick.isUp ? colors.success : colors.error;
      return builder(context, tick, dotColor);
    });
  }
}
