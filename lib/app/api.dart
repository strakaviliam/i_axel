import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:logger/logger.dart';

import '../app/app.dart';
import 'app_result.dart';
import 'tools/tools.dart';

enum HTTPMethod {
  get, post
}

class Api {

  static const String ERROR_TIMEOUT = 'ERROR_TIMEOUT';
  static const String ERROR_GENERAL = 'ERROR_GENERAL';

  final String endpoint;
  final HTTPMethod method;
  final int timeout;
  final Client _client;
  final String _apiEndpoint;
  final Logger _logger;

  /// optional [client] - if is not set, default [IOClient] is used
  Api(this.endpoint, {
    this.method = HTTPMethod.get,
    this.timeout = 20000,
    Client? client,
  }) :
        _client = client ?? Client(),
        _apiEndpoint = App.appConfig.endpoint,
        _logger = GetIt.I.get<Logger>();

  Map<String, String> headersCommon = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// optional [key] - unique identifier for this api call. Is part of [Result] response. If is not set, [Tools.randomString] is generated.
  ///
  /// optional [uploadData] - applicable for POST data to api. If is set, POST MultipartRequest call
  /// with **Content-Type = octet-stream** and **filename: file** is called.
  Future<Result> call({
    Map<String, dynamic> parameters = const <String, dynamic>{},
    Map<String,String> headers = const {},
    String? key,
    Uint8List? uploadData,
  }) async {
    key = key ?? Tools.randomString();

    //build url
    String url = _apiEndpoint + endpoint;
    if (endpoint.startsWith('http')) {
      url = endpoint;
    }

    //parameters
    Map<String, dynamic> paramsToAddInRequest = <String, dynamic>{};

    //replace in url {...} - dynamic parts - with parameters
    if (parameters.isNotEmpty) {
      parameters.forEach((key, dynamic val) {
        if (url.contains(key) && key.startsWith('{') && key.endsWith('}')) {
          url = url.replaceAll(key, val as String);
        } else {
          paramsToAddInRequest[key] = val;
        }
      });
      url = url.replaceAll('://', ':///');
      url = url.replaceAll('//', '/');
    }

    //prepare headers
    final Map<String, String> headersToAddInRequest = {};
    headersToAddInRequest.addAll(headersCommon);

    headers.forEach((key, val) => headersToAddInRequest[key] = val);

    //if get, create params in path
    if (method == HTTPMethod.get && paramsToAddInRequest.isNotEmpty) {
      String apiParams = '';
      paramsToAddInRequest.forEach((key, dynamic val) {
        val = Uri.encodeFull(val.toString());
        val = val.toString().replaceAll('&', '%26');
        key = Uri.encodeFull(key.toString());
        key = key.toString().replaceAll('&', '%26');
        apiParams = apiParams + '$key=$val&';
      });

      if (apiParams.endsWith('&')) {
        apiParams = apiParams.substring(0, apiParams.length - 1);
      }
      url = '$url?$apiParams';
      paramsToAddInRequest = <String, dynamic>{};
    }

    _logger.d(
      '_______________ REQUEST _________________________________________\n'
          'url:      $url\n'
          'method:   ${method.toString()}\n'
          'headers:  ${headersToAddInRequest.toString()}\n'
          'params:   ${paramsToAddInRequest.toString()}',
    );

    final RequestParams requestParams = RequestParams(
      key: key,
      headersToAddInRequest: headersToAddInRequest,
      paramsToAddInRequest: paramsToAddInRequest,
      url: url,
      client: _client,
      logger: _logger,
      method: method,
      timeout: timeout,
      uploadData: uploadData,
    );

    if (Platform.isAndroid) {
      return _executeCall(requestParams);
    } else {
      return compute(_executeCall, requestParams);
    }

  }
}

class RequestParams {
  final String url;
  final String key;
  final Map<String, dynamic> paramsToAddInRequest;
  final Map<String, String> headersToAddInRequest;
  final HTTPMethod method;
  final int timeout;
  final Logger logger;
  final Client client;
  final Uint8List? uploadData;

  RequestParams({
    required this.url,
    required this.key,
    required this.paramsToAddInRequest,
    required this.headersToAddInRequest,
    required this.method,
    required this.timeout,
    required this.logger,
    required this.client,
    this.uploadData,
  });
}

Future<Result> _executeCall(RequestParams p) async {

  final Result Function(Response) handleSuccessResponse = (response) {
    dynamic data;

    if (response.body.isEmpty) {
      data = <String, dynamic>{};
    } else {
      try {
        data = json.decode(response.body);
      } catch (ex) {
        p.logger.e('Can not decode response body');
        data = <String, dynamic>{};
      }
    }

    p.logger.d(
      '_______________ RESULT _________________________________________\n'
          'response:   $data',
    );
    return Result(
      status: Status.success,
      data: data,
      key: p.key,
    );
  };

  final Result Function(ClientException?, String?) handleFailResponse = (response, code) {

    final String error = response?.message ?? code ?? Api.ERROR_GENERAL;

    p.logger.e(
      '_______________ ERROR _________________________________________\n'
          'error:   $error',
    );

    return Result(
      status: Status.fail,
      key: p.key,
      error: error,
    );
  };

  Response response;

  try {
    switch (p.method) {
      case HTTPMethod.get: {
        response = await p.client.get(Uri.parse(p.url), headers: p.headersToAddInRequest).timeout(Duration(milliseconds: p.timeout));
      } break;
      case HTTPMethod.post: {
        if (p.uploadData != null) {
          p.headersToAddInRequest['Content-Type'] = 'octet-stream';

          final request = MultipartRequest('POST', Uri.parse(p.url));
          request.headers.addAll(p.headersToAddInRequest);
          request.files.add(MultipartFile.fromBytes('file', p.uploadData!, filename: 'file'));
          p.paramsToAddInRequest.forEach((key, dynamic value) {
            request.fields[key] = value as String;
          });
          final StreamedResponse streamedResponse = await p.client.send(request).timeout(Duration(milliseconds: p.timeout));
          response = await Response.fromStream(streamedResponse);
        } else {
          dynamic body = json.encode(p.paramsToAddInRequest);
          if (p.headersToAddInRequest.containsKey('Content-Type') && p.headersToAddInRequest['Content-Type'] == 'application/x-www-form-urlencoded') {
            body = p.paramsToAddInRequest;
          }
          response = await p.client.post(Uri.parse(p.url), headers: p.headersToAddInRequest, body: body).timeout(Duration(milliseconds: p.timeout));
        }
      } break;
    }
  } catch (error) {
    if (error is TimeoutException) {
      return handleFailResponse(ClientException(Api.ERROR_TIMEOUT, Uri.parse(p.url)), null);
    } else if (error is StateError) {
      return handleFailResponse(ClientException(error.message, Uri.parse(p.url)), null);
    } else if (error is ClientException) {
      return handleFailResponse(error, null);
    } else {
      p.logger.e(error);
      return handleFailResponse(null, null);
    }
  }

  if (response.statusCode == 200) {
    return handleSuccessResponse(response);
  } else {
    String error = Api.ERROR_GENERAL;
    final Map<String, String> errors = {};
    final dynamic data = json.decode(response.body);

    if (data['error'] is String) {
      error = data['error'] as String;
    } else {
      final errorData = data['error'] as Map<String, dynamic>? ?? <String, dynamic>{};
      errorData.forEach((key, dynamic value) {
        if (key == 'message') {
          error = value as String;
        } else {
          errors[key] = value as String;
        }
      });
    }


    p.logger.e(
      '_______________ ERROR _________________________________________\n'
          'response:  $data,\n'
          'error:     $error,\n'
          'errors:    $errors',
    );

    return Result(
      status: Status.fail,
      key: p.key,
      error: error,
      errors: errors,
    );
  }
}
