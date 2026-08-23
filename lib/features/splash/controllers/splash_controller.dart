import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await AppStorage.init();
      await MarketFeedService().init();
      WalletService().init();
      await Future.delayed(
        const Duration(seconds: 1),
        () {
          Get.off(() => const HomeScreen(), binding: HomeBinding());
        },
      );
    } catch (_) {}
  }
}
