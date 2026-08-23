# TradoX — Mock Trading App

A simulated stock trading app built for the Flutter assignment: real-time mock market data, watchlists, a Buy/Sell ticket, and a live portfolio view — all backed by a mock market-data feed with no real backend.

## Stack

- **Flutter** 3.35.7 (stable channel)
- **Dart** 3.9.2
- **State management / DI / navigation:** GetX (`get`)
- **Local persistence:** `get_storage`
- **Precise money math:** `decimal` (no `double` anywhere for prices/balances — avoids floating-point drift)
- **Date formatting:** `intl`

```
Flutter 3.35.7 • channel stable • https://github.com/flutter/flutter.git
Framework • revision adc9010625 (10 months ago) • 2025-10-21 14:16:03 -0400
Engine • hash 6b24e1b529bc46df7ff397667502719a2a8b6b72 (revision 035316565a) (9 months ago) • 2025-10-21 14:28:01.000Z
Tools • Dart 3.9.2 • DevTools 2.48.0
```

## Getting Started

### Prerequisites
- Flutter SDK 3.35.x (or compatible) installed and on your `PATH`
- A connected device, running emulator/simulator, or Chrome (for web)
- No API keys, backend, or environment variables needed — everything runs locally

### Setup

```bash
# 1. Clone the repo
git clone <your-repo-url>
cd trade_app

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

That's it — `flutter pub get && flutter run` is the entire setup. No `.env` file, no backend server, no API keys. The "market data API" is a local JSON asset (`assets/data/stocks.json`) loaded with a simulated network delay, and all persistence is on-device via `get_storage`.

### What happens on first launch
1. Splash screen plays a short logo animation while, in the background:
    - Local storage (`get_storage`) initializes
    - `MarketFeedService` loads the 10 stocks from `assets/data/stocks.json` and starts each stock's independent live-tick timer
    - `WalletService` hydrates the wallet balance from disk (or seeds a fresh ₹10,00,000 balance on a true first run)
2. App lands on the Home shell (bottom-nav: Market / Watchlist / Holdings)

Every subsequent launch restores watchlists, wallet balance, order history, and holdings exactly as you left them — everything is written to on-device storage immediately after each change.

## Stocks used

Fixed set of 10, seeded from `assets/data/stocks.json`:
`RELIANCE`, `TCS`, `INFY`, `HDFCBANK`, `ICICIBANK`, `SBIN`, `ITC`, `LT`, `BHARTIARTL`, `AXISBANK`

## Feature summary

| Feature | Highlights |
|---|---|
| **Watchlist** | Multiple watchlists (create/rename/delete), stock picker, drag-to-reorder, remove, live per-row prices, tap → Buy/Sell |
| **Market** | Live prices for all 10 stocks, each stock ticks on its **own independent 1–5s timer** (not a shared clock), green/red direction dot per row, debug settings to speed up ticking for stress-testing |
| **Buy/Sell** | Pre-filled from wherever you tapped in, live LTP + live order value while the form is open, margin/holding validation with inline errors, live available-balance display, confirmation screen |
| **Holdings** | Live P&L per row (₹ and %), sortable by P&L / symbol / value, live aggregate summary (invested / current value / total P&L), tap → Buy/Sell |

## Mock market data design

There is no real backend. `MarketApiRepository`/`MarketRepository` reads `assets/data/stocks.json` (with a short artificial delay) to simulate an API call, and `MarketFeedService` is the **single source of live price data for the entire app** — every screen (Market, Watchlist rows, Holdings, Buy/Sell) reads from the same `Map<String, Rx<PriceTick>>`, so a price is always identical no matter where it's displayed at any given moment.

Each of the 10 stocks runs its own independent tick timer (randomized between 1–5 seconds by default) rather than all ticking together on one shared interval — this was a deliberate choice to make the feed feel like a real, staggered market instead of an obviously synthetic "everything updates together" loop.

A debug settings sheet (gear icon on the Market tab) exposes:
- **Normal** — each stock keeps its own randomized 1–5s pace
- **Fast** — all stocks uniformly tick every 500ms
- **Stress test** — all stocks uniformly tick every 200ms (5 ticks/sec/stock = 50+ ticks/sec overall)
- **Reset Demo Data** — clears wallet balance, order history, and holdings back to a fresh state (watchlists are intentionally preserved, since they're user configuration rather than trading state)

## Architecture

Repo → Controller → UI, one-directional:

```
AppStorage (get_storage wrapper)
      ↓
Repositories (Watchlist / Wallet / Order / Holdings / MarketApi)
      ↓
Services (MarketFeedService, WalletService, OrderService — plain
          singletons, NOT GetX services, except where GetX's own
          Rx types are used internally for reactive values)
      ↓
Controllers (GetX GetxController — plain fields + update(), the
             GetBuilder convention used throughout; Obx is used only
             for values that tick independently of controller state,
             like live prices and wallet balance)
      ↓
Views (StatelessWidget, wrapped in GetBuilder<T>; no business logic)
```

Navigation is plain `Get.to()` / `Get.off()` with a `Bindings` subclass passed directly at the call site (no named routes / `GetPage` table) — e.g.:

```dart
Get.to(() => const BuySellScreen(),
  binding: BuySellBinding(symbol: symbol, initialSide: OrderSide.buy),
);
```

Money/decimals: every price, balance, and order value is a `Decimal` (never `double`), all the way from the JSON asset (parsed as strings) through to the UI.

## Folder structure

```
lib/
├── main.dart                          # GetMaterialApp setup, theme, initialBinding
├── trade_app.dart                     # Barrel file — single import point for project code
│
├── core/
│   └── theme/
│       ├── app_colors.dart            # Raw color constants
│       ├── app_color_extension.dart   # ThemeExtension — context.appColors.*
│       ├── app_text_styles.dart       # {weight}{size} text style catalog
│       └── app_theme.dart             # ThemeData.light / ThemeData.dark
│
├── data/
│   ├── models/
│   │   ├── stock.dart                 # Static instrument data (from JSON)
│   │   ├── price_tick.dart            # Live reactive price snapshot
│   │   ├── watchlist.dart
│   │   ├── order.dart
│   │   ├── order_side.dart            # Buy/Sell enum
│   │   ├── order_result.dart          # Success/failure wrapper for OrderService
│   │   ├── holding.dart
│   │   └── wallet.dart
│   │
│   ├── repositories/                  # AppStorage read/write, one per data type
│   │   ├── market_api_repository.dart # "Mock API" — loads stocks.json
│   │   ├── watch_list_repository.dart
│   │   ├── wallet_repository.dart
│   │   ├── order_repository.dart
│   │   └── holdings_repository.dart
│   │
│   └── services/                      # Business logic sitting above repositories
│       ├── market_feed_service.dart   # Single source of live prices, per-stock tickers
│       ├── wallet_service.dart        # Reactive balance + debit/credit
│       ├── order_service.dart         # Validates + executes a Buy/Sell atomically
│       └── storage_service.dart       # AppStorage — GetStorage wrapper + storage keys
│
├── features/
│   ├── splash/
│   │   ├── bindings/splash_binding.dart
│   │   ├── controllers/splash_controller.dart
│   │   └── views/splash_screen.dart   # Animated logo, storage/feed/wallet init
│   │
│   ├── home/
│   │   ├── bindings/home_binding.dart # Registers all 3 tab controllers at once
│   │   ├── controllers/home_controller.dart
│   │   └── views/home_screen.dart     # Bottom-nav shell (IndexedStack)
│   │
│   ├── watchlist/
│   │   ├── bindings/watch_list_detail_binding.dart
│   │   ├── controllers/
│   │   │   ├── watch_list_controller.dart         # List of watchlists (CRUD)
│   │   │   └── watch_list_detail_controller.dart  # One watchlist's stocks
│   │   └── views/
│   │       ├── watch_list_screen.dart
│   │       └── watch_list_detail_screen.dart       # Reorder, remove, add
│   │
│   ├── market/
│   │   ├── controllers/market_controller.dart
│   │   └── views/market_screen.dart
│   │
│   ├── holdings/
│   │   ├── controllers/holdings_controller.dart
│   │   └── views/holdings_screen.dart
│   │
│   └── buy_sell/
│       ├── bindings/buy_sell_binding.dart
│       ├── controllers/buy_sell_controller.dart
│       └── views/
│           ├── buy_sell_screen.dart
│           └── order_confirmation_screen.dart
│
└── widgets/                            # Shared, cross-feature widgets
    ├── price_flash_cell.dart           # Live price + direction dot
    ├── stock_picker_sheet.dart         # "Add stock" bottom sheet
    └── debug_setting_sheet.dart        # Tick-rate controls + reset demo data

assets/
├── data/
│   └── stocks.json                     # The 10 stocks — acts as the mock "API" payload
└── images/
    └── app_logo.png                    # Splash screen branding
```

## Known simplifications (by design, for this assignment's scope)

- **No true multi-step transaction**: `OrderService.submit()` writes the order record, then debits/credits the wallet, then updates holdings, in sequence — not wrapped in an atomic transaction. Acceptable for a local demo app with no real backend; a production system would want this reconciled or transactional.
- **"Reset Demo Data" preserves watchlists** — they're treated as user configuration, not trading state, so only wallet/orders/holdings are cleared.
- Order history is recorded and persisted (`OrderRepository`) but not currently browsable in its own screen — only used internally to validate/track state.