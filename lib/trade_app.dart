library trade_app;

/// [trade_app.dart]

export 'package:decimal/decimal.dart';

/// [Theme]
export 'package:trading_app/core/theme/app_theme.dart';
export 'package:trading_app/core/theme/app_colors.dart';
export 'package:trading_app/core/theme/app_text_styles.dart';
export 'package:trading_app/core/theme/app_color_extension.dart';

/// [repositories]
export 'package:trading_app/data/repositories/wallet_repository.dart';
export 'package:trading_app/data/repositories/holdings_repository.dart';
export 'package:trading_app/data/repositories/market_api_repository.dart';
export 'package:trading_app/data/repositories/order_repository.dart';
export 'package:trading_app/data/repositories/watch_list_repository.dart';

/// [services]
export 'package:trading_app/data/services/wallet_service.dart';
export 'package:trading_app/data/services/storage_service.dart';
export 'package:trading_app/data/services/market_feed_service.dart';
export 'data/models/order_result.dart';
export 'data/services/order_service.dart';

///[models]
export 'package:trading_app/data/models/wallet.dart';
export 'package:trading_app/data/models/holding.dart';
export 'package:trading_app/data/models/order.dart';
export 'package:trading_app/data/models/order_side.dart';
export 'package:trading_app/data/models/price_tick.dart';
export 'package:trading_app/data/models/stock.dart';
export 'package:trading_app/data/models/watchlist.dart';

/// [Splash]
export 'package:trading_app/features/splash/bindings/splash_binding.dart';
export 'package:trading_app/features/splash/controllers/splash_controller.dart';
export 'package:trading_app/features/splash/views/splash_screen.dart';

/// [Home]
export 'package:trading_app/features/home/controllers/home_controller.dart';
export 'package:trading_app/features/home/bindings/home_binding.dart';
export 'package:trading_app/features/home/views/home_screen.dart';

/// [watchlist]
export 'package:trading_app/features/watchlist/controllers/watch_list_controller.dart';
export 'package:trading_app/features/watchlist/views/watch_list_screen.dart';
export 'package:trading_app/features/watchlist/controllers/watch_list_detail_controller.dart';

/// [market]
export 'package:trading_app/features/market/controllers/market_controller.dart';
export 'package:trading_app/features/market/views/market_screen.dart';

/// [Holdings]
export 'package:trading_app/features/holdings/controllers/holdings_controller.dart';
export 'package:trading_app/features/holdings/views/holdings_screen.dart';

/// [Buy/Sell]
export 'package:trading_app/features/buy_sell/controllers/buy_sell_controller.dart';
export 'package:trading_app/features/buy_sell/bindings/buy_sell_binding.dart';
export 'package:trading_app/features/buy_sell/views/buy_sell_screen.dart';
export 'package:trading_app/features/buy_sell/views/order_confirmation_screen.dart';

export 'package:trading_app/widgets/price_flash_cell.dart';
export 'package:trading_app/widgets/stock_picker_sheet.dart';
export 'package:trading_app/widgets/debug_setting_sheet.dart';
export 'package:trading_app/features/watchlist/bindings/watch_list_detail_binding.dart';
export 'package:trading_app/features/watchlist/views/watch_list_detail_screen.dart';
