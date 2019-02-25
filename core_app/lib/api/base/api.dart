/**
 * This files contains 2 main class: HttpRequest and HttpGetWithCache
 */

import 'dart:async';
import 'dart:convert';

import 'package:async_resource/async_resource.dart';
import 'package:core_app/api/base/local_resource.dart';
import 'package:core_app/service_locator.dart';
import 'package:http/http.dart';

/// HTTP Request method as enum for integrity
enum HttpMethod {
  get,
  post,
  delete,
  put,
}

/// interpret everything below this as success response
const int minimumNonSuccessCode = 400;

/// Base class for http request with helper
abstract class BaseHttpRequest {
  static int _requestId = 0;
  var client = Client();

  String get baseUrl;

  int get requestId => _requestId++;

  /// set default header here
  Map<String, String> get baseHeaders => {
        'Content-Type': 'application/json',
        'Accept-Language': 'en',
      };

  Uri generateUri(
    String url,
    String path,
    Map<String, String> params,
  ) {
    var apiUri = Uri.parse("$url$path");
    return Uri(
      scheme: apiUri.scheme,
      host: apiUri.host,
      path: apiUri.path,
      queryParameters: params,
    );
  }

  void preRequestLog(int requestId, Stopwatch timer, String logMessage,
      {dynamic body}) {
    assert(() {
      timer.start();
      print(logMessage);
      return true;
    }());
  }

  void postResponseLog(int requestId, Stopwatch timer, String logMessage) {
    assert(() {
      timer.stop();
      var elapsedMiliseconds = timer.elapsedMilliseconds;
      print(logMessage);
      print("[$requestId] < Took ${elapsedMiliseconds}ms");
      return true;
    }());
  }

  void nonSuccessHandler(Response response) {
    if (response.statusCode >= minimumNonSuccessCode) {
      Map res = json.decode(utf8.decode(response.bodyBytes));
      var errorObj = NonSuccessResponseException(
        response.statusCode,
        res['status'],
        res['detail'],
      );
      throw errorObj;
    }
  }
}

/// Generic, multipurpose http request
abstract class HttpRequest extends BaseHttpRequest {
  Future<String> sendRequest(HttpMethod requestMethod, String relativePath,
      {dynamic body,
      Map<String, dynamic> params,
      Map<String, String> headers,
      bool isUrlEncoded = false,
      Duration timeout = const Duration(seconds: 20)}) async {
    assert(requestMethod != HttpMethod.post ||
        (requestMethod == HttpMethod.post &&
            body != null &&
            (body is String || body is List || body is Map)));

    var httpMethod = requestMethod.toString().split(".")[1].toUpperCase();

    var uri = generateUri(baseUrl, relativePath, params);

    var request = Request(httpMethod, uri);

    if (headers != null) {
      baseHeaders.addAll(headers);
    }
    baseHeaders.forEach((key, value) => request.headers[key] = value);

    if (body != null) {
      if (!isUrlEncoded) {
        body = json.encoder.convert(body);
      }

      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = List.castFrom(body);
      } else if (body is Map) {
        /// headers 'Content-Type' will be overriden
        /// see https://github.com/dart-lang/http/blob/ffe786a872c0d443cc4fa6baa923d69059b66399/lib/src/client.dart#L60-L62
        request.bodyFields = Map.castFrom(body);
      } else {
        throw ArgumentError('Invalid request body type "${body.toString()}".');
      }
    }

    var timer = Stopwatch();
    var currentRequestId = requestId;
    preRequestLog(currentRequestId, timer,
        "[$currentRequestId] > $httpMethod ${uri.toString()}");
    if (request.body != null) {
      preRequestLog(currentRequestId, timer,
          "[$currentRequestId] > ${request.body.toString()}");
    }

    var req = await client.send(request).timeout(timeout, onTimeout: () {
      postResponseLog(
          requestId, timer, "[$requestId] < Timeout after ${timeout}s!");
      return;
    });

    var response = await Response.fromStream(req);

    postResponseLog(currentRequestId, timer,
        "[$currentRequestId] < ${response.statusCode} ${response.body}");

    nonSuccessHandler(response);

    return utf8.decode(response.bodyBytes);
  }
}

/// Http GET request with cache function
abstract class HttpGetWithCache extends BaseHttpRequest {
  Future<String> getRequest(
    String relativePath, {
    Map<String, dynamic> params,
    Map<String, dynamic> headers,
    Duration timeout = const Duration(seconds: 20),
    bool isCacheFirst = true,
    bool forceReload = false,
    Duration maxCacheAge = const Duration(minutes: 1),
  }) async {
    var uri = generateUri(baseUrl, relativePath, params);

    var combinedHeaders = baseHeaders;
    if (headers != null) {
      combinedHeaders.addAll(headers);
    }

    CustomLocalResource localResource =
        CoreServiceLocator.instance<CustomLocalResource>();
    var myDataResource = CustomHttpNetworkResource<String>(
      url: uri.toString(),
      headers: combinedHeaders,
      client: client,
      parser: (content) => content.toString(),
      cache: localResource
          .getResourceInstance('${uri.toString().replaceAll("/", "|")}'),
      maxAge: maxCacheAge,
      strategy:
          isCacheFirst ? CacheStrategy.cacheFirst : CacheStrategy.networkFirst,
      responseHandler: nonSuccessHandler,
    );

    var timer = Stopwatch();
    var currentRequestId = requestId;
    preRequestLog(currentRequestId, timer,
        "[$currentRequestId] > GET with cache ${uri.toString()}");

    var response = await myDataResource
        .get(forceReload: forceReload)
        .timeout(timeout, onTimeout: () {
      postResponseLog(
          requestId, timer, "[$requestId] < Timeout after ${timeout}s!");
      return;
    });

    postResponseLog(
        currentRequestId, timer, "[$currentRequestId] < ${response}");
    return response;
  }
}

class BaseHttpException implements Exception {
  final String message;

  BaseHttpException({this.message});

  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}

/// Standardized non-success response object from Santika backend
class NonSuccessResponseException extends BaseHttpException {
  NonSuccessResponseException(
    this.code,
    this.status,
    this.detail, {
    String message,
  }) : super(message: message);

  int code;
  String status;
  String detail;
}
