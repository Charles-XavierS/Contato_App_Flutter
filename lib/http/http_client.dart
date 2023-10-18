import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future get({required String url, Map<String, String>? headers});
}

class HttpClient implements IHttpClient {
  final client = http.Client();

  @override
  Future get({required String url, Map<String, String>? headers}) async {
    final Map<String, String> allHeaders = {
      'X-Parse-Application-Id': 'IYIajHqy8Bc70bk4INzBdjs4JUEbMx9laUJbj5ms',
      'X-Parse-REST-API-Key': 'VUUYNUVP7L64hrhBFuOdQ6YOCeya3us3UFKxQdiW',
      'content-type': 'application/json',
    };

    if (headers != null) {
      allHeaders.addAll(headers);
    }

    final response = await client.get(Uri.parse(url), headers: allHeaders);

    return response;
  }
}
