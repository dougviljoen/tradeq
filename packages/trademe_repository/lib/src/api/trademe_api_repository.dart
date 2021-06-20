import 'package:http/http.dart' as http;
import 'package:trademe_repository/trademe_repository.dart';

class TrademeApiRepository {
  TrademeApiRepository({
    TrademeClient client,
  })  : assert(client != null),
        _client = client;
  final TrademeClient _client;
  final String favUrl =
      "https://api.tmsandbox.co.nz/v1/Favourites/Searches/All.json";
  final String motUrl =
      "https://api.tmsandbox.co.nz/v1/Search/Motors/Used.json";

  Future<http.Response> getFeed() async {
    http.Response response = await _client.memClient.get(favUrl);
    if (response.statusCode == 200) {
      return response;
    } else {
      String msg = "appClient: error fetching url: $favUrl\n\t$response.body";
      throw Exception(msg);
    }
  }
}
