import 'dart:async';
import 'dart:convert';

import 'package:oauth1/oauth1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import 'models/models.dart';

/// Repository which manages [TrademeClient] authentication
class TrademeAuthRepository {
  final storedClientKey = "tradeq-client-auth";

  // Trademe oauth1 platform configuration
  final platform = new Platform(
      'https://secure.tmsandbox.co.nz/Oauth/RequestToken',
      'https://secure.tmsandbox.co.nz/Oauth/Authorize',
      'https://secure.tmsandbox.co.nz/Oauth/AccessToken',
      SignatureMethods.plaintext // signature method
      );

  // TradeQ consumer credentials
  final String consKey = '895E733D96A813E3C9FFD72C1AEA030D';
  final String consSecret = '4765B5F46C90318CD773B5D8BB583440';

  // Authorization credentials
  ClientCredentials get clientCreds => ClientCredentials(consKey, consSecret);
  Authorization get auth => new Authorization(clientCreds, platform);
  Credentials tempCreds;

  // Trademe uses the appClient for non-member api calls
  // https://developer.trademe.co.nz/api-overview/authorisation/
  Client get appClient => Client(platform.signatureMethod, clientCreds, null);

  final _controller = StreamController<TrademeClient>();

  /// Resource owner authorization URL.
  /// Users will sign in at this address to obtain an oauth verifier.
  Future<String> get authorizationUrl async {
    final response = await auth.requestTemporaryCredentials('oob');
    tempCreds = response.credentials;
    return "${auth.getResourceOwnerAuthorizationURI(tempCreds.token)}";
  }

  /// Stream of [TrademeClient] which will emit the current client.
  /// Emits [TrademeClient.empty] if the client is not authenticated
  Stream<TrademeClient> get client async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    await restoreCurrentClient();
    yield* _controller.stream;
  }

  /// Restores a logged in [TrademeClient] and adds it to the client stream.
  /// Will add [TrademeClient.empty] if no client has been saved.
  Future<void> restoreCurrentClient() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    if (store.containsKey(storedClientKey)) {
      Map<String, String> credMap = Map<String, String>.from(
        json.decode(store.getString(storedClientKey)),
      );
      Credentials creds = Credentials.fromMap(credMap);
      Client client = Client(platform.signatureMethod, clientCreds, creds);
      _controller.add(TrademeClient(appClient: appClient, memClient: client));
    } else {
      _controller.add(TrademeClient.empty);
    }
  }

  /// Creates a new [TrademeClient] with a given [verifier] and adds it
  /// to the client stream.
  Future<void> logIn({@required String verifier}) async {
    final response = await auth.requestTokenCredentials(tempCreds, verifier);
    Credentials creds = response.credentials;
    SharedPreferences store = await SharedPreferences.getInstance();
    store.setString(storedClientKey, json.encode(creds.toJSON()));
    Client client = Client(platform.signatureMethod, clientCreds, creds);
    _controller.add(TrademeClient(appClient: appClient, memClient: client));
  }

  /// Adds an empty [TrademeClient] to the client stream and removes the
  /// stored client credentials from [SharedPreferences].
  Future<void> logOut() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    store.remove(storedClientKey);
    _controller.add(TrademeClient.empty);
  }

  void dispose() => _controller.close();
}
