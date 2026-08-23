import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class BuySellController extends GetxController {
  final String symbol;

  BuySellController({required this.symbol, OrderSide initialSide = OrderSide.buy}) : side = initialSide;

  OrderSide side;
  final TextEditingController quantityController = TextEditingController();

  String? errorMessage;
  bool isSubmitting = false;

  void setSide(OrderSide newSide) {
    if (side == newSide) return;
    side = newSide;
    errorMessage = null;
    update();
  }

  void onQuantityChanged(String _) {
    if (errorMessage != null) errorMessage = null;
    update();
  }

  Future<void> submit() async {
    errorMessage = null;
    FocusManager.instance.primaryFocus?.unfocus();
    final qty = int.tryParse(quantityController.text.trim());
    if (qty == null || qty <= 0) {
      errorMessage = 'Enter a valid quantity greater than zero.';
      update();
      return;
    }

    isSubmitting = true;
    update();

    final result = await OrderService().submit(symbol: symbol, side: side, quantity: qty);

    isSubmitting = false;

    if (!result.success) {
      errorMessage = result.errorMessage;
      update();
      return;
    }

    if (Get.isRegistered<HoldingsController>()) {
      Get.find<HoldingsController>().refreshData();
    }

    await Future.delayed(const Duration(milliseconds: 100));
    Get.off(() => OrderConfirmationScreen(order: result.order!), transition: Transition.downToUp);
  }

  @override
  void onClose() {
    quantityController.dispose();
    super.onClose();
  }
}
