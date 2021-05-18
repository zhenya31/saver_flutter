import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  static String apiHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;

      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
