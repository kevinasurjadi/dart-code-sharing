import 'dart:async';

import 'package:http/http.dart' as http;

abstract class PokemonClient {
  final http.Client client = http.Client();
  final String baseUrl = "https://pokeapi.co/api/v2/";

  String get endpoint;

  String getURL({String path, Map<String, String> params}) {
    var apiUri = Uri.parse(baseUrl);
    String _endpoint =
        this.endpoint.endsWith("/") ? this.endpoint : this.endpoint + "/";
    var uriPath = path != null ? _endpoint + path : _endpoint;
    String _uriPath = uriPath.endsWith("/") ? uriPath : uriPath + "/";
    return Uri(
      scheme: apiUri.scheme,
      host: apiUri.host,
      path: _uriPath,
      queryParameters: params,
    ).toString();
  }

  Future<http.Response> httpGet(
      {String path,
      Map<String, String> params,
      String token}) async {
    String url = getURL(path: path, params: params);
    return client.get(url, headers: {
      'Content-type': 'application/json',
    });
  }
}
