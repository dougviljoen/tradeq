import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:tradeq/login/login.dart';
import 'package:trademe_repository/trademe_repository.dart';

class TrademeOauthPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => TrademeOauthPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => LoginCubit(context.read<TrademeAuthRepository>()),
          child: _TrademeOauthView(),
        ),
      ),
    );
  }
}

class _TrademeOauthView extends StatefulWidget {
  @override
  _TrademeOauthState createState() => _TrademeOauthState();
}

class _TrademeOauthState extends State<_TrademeOauthView> {
  FlutterWebviewPlugin _webview;

  @override
  void initState() {
    super.initState();
    _webview = FlutterWebviewPlugin();
    _webview.onUrlChanged.listen((url) {
      final uri = Uri.parse(url);
      if (uri.queryParameters.containsKey("oauth_verifier")) {
        context
            .read<LoginCubit>()
            .logInWithTrademe(uri.queryParameters["oauth_verifier"]);
        _webview.close();
      }
    });
    _webview.onBack.listen((event) {
      _webview.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<LoginCubit>().authorizationUrl.then(
      (url) {
        _webview.launch(url);
      },
    );
    return Scaffold();
  }

  @override
  void dispose() {
    _webview.dispose();
    super.dispose();
  }
}
