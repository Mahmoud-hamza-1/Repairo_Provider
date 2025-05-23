import 'dart:convert';
import 'package:http/http.dart' as http;

class ItemsWebservices {
  Future<List<dynamic>> getItems() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    final data = jsonDecode(response.body);

    //final List products = data['products'];
    if (response.statusCode == 200) {
      return data;
    } else {
      throw ('error happened');
    }
  }
}
