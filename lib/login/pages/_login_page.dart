import 'package:flutter/material.dart';
import 'package:tradeq/login/login.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(padding: const EdgeInsets.all(8.0), child: LoginView()),
    );
  }
}

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Spacer(
              flex: 2,
            ),
            Flexible(
              flex: 10,
              child: Center(
                child: Image.asset(
                  'assets/tradeq_logo.png',
                  height: 110,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: TrademeLoginButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class TrademeLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: Key('loginForm_googleLogin_raisedButton'),
      label: Text(
        '   SIGN IN WITH TRADEME',
        style: TextStyle(color: Colors.white),
      ),
      icon: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
        ),
        child: Image.asset(
          "assets/trademe_logo_square.png",
          scale: 12.0,
        ),
      ),
      onPressed: () async {
        await Navigator.push(
          context,
          TrademeOauthPage.route(),
        );
      },
    );
  }
}
