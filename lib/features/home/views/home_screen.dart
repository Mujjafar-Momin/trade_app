import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            index: controller.currentIndex,
            children: const [
              MarketScreen(),
              WatchListScreen(),
              HoldingsScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex,
            onTap: controller.changeTab,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.show_chart_rounded), label: 'Market'),
              BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Watchlist'),
              BottomNavigationBarItem(icon: Icon(Icons.pie_chart_rounded), label: 'Holdings'),
            ],
          ),
        );
      },
    );
  }
}
