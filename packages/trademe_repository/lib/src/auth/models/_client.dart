import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:oauth1/oauth1.dart';

import 'package:trademe_repository/trademe_repository.dart';

/// Authenticated Trademe dual client object
/// Handles Trademe api calls to both application & member clients.
class TrademeClient extends Equatable {
  const TrademeClient({
    @required this.appClient,
    @required this.memClient,
  });

  final Client appClient;
  final Client memClient;

  TrademeApiRepository get api {
    return TrademeApiRepository(client: this);
  }

  /// Returns a [http.Response] from the application client.
  /// This deals with generic (non-member) calls to Trademe.
  Future<http.Response> appGet(url) async {
    http.Response response = await appClient.get(url);
    if (response.statusCode == 200) {
      return response;
    } else {
      String msg = "appClient: error fetching url: $url\n\t$response.body";
      throw Exception(msg);
    }
  }

  /// Returns a [http.Response] from the member client.
  /// This deals member related api calls to Trademe.
  Future<http.Response> memGet(url) async {
    http.Response response = await memClient.get(url);
    if (response.statusCode == 200) {
      return response;
    } else {
      String msg = "memClient: error fetching url: $url\n\t$response.body";
      throw Exception(msg);
    }
  }

  /// Empty client which represents an unauthenticated client.
  static const empty = TrademeClient(appClient: null, memClient: null);

  @override
  List<Object> get props => [appClient, memClient];
}
