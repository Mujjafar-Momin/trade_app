import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class SplashController extends GetxController {
  String statusMessage = 'Starting up...';
  bool hasError = false;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    hasError = false;
    update();
    try {
      statusMessage = 'Setting up storage...';
      update();
      await AppStorage.init();

      statusMessage = 'Loading market data...';
      update();
      await MarketFeedService().init();

      statusMessage = 'Loading wallet...';
      update();
      WalletService().init();

      statusMessage = 'Ready';
      update();


    } catch (e) {
      hasError = true;
      statusMessage = 'Something went wrong while starting the app.';
      update();
    }
  }

  void retry() => _initializeApp();
}