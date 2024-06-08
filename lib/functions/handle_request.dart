import 'package:http/http.dart' as http;
import 'package:foto_app/functions/handle_storage.dart' as handle_storage;

Future<http.Response> postData(Uri url, dynamic body) async {
  var token = await handle_storage.getDataStorage('token');

  final response = await http
      .post(url, body: body, headers: {'authorization': 'Bearer $token'});
  return response;
}

Future<http.Response> getData(Uri url) async {
  var token = await handle_storage.getDataStorage('token');

  Map<String, String> headers = {
    "authorization": "Bearer $token",
  };

  final response = await http.get(url, headers: headers);

  return response;
}
