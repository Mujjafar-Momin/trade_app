import 'package:get/get.dart';

class HomeController extends GetxController {
  int currentIndex = 0;

  void changeTab(int index) {
    if (currentIndex == index) return;
    currentIndex = index;
    update();
  }
}
