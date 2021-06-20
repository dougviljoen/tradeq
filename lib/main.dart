import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:trademe_repository/trademe_repository.dart';
import 'package:tradeq/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = kDebugMode;
  runApp(App(authRepository: TrademeAuthRepository()));
}
