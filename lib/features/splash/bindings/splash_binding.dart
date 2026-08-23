import 'package:get/get.dart';
import 'package:trading_app/features/splash/controllers/splash_controller.dart';

/// [SplashBinding]
/// Registers SplashController for the splash route only. GetX disposes
/// it automatically once we navigate away (default lazyPut behavior),
/// since splash is a one-time screen — no reason to keep it alive.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}