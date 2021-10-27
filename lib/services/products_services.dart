import 'dart:convert';

import 'package:batch_one/services/api.dart';
import 'package:http/http.dart' as http;

class ProductService {
  getProducts(data) async {
    final response = await http.post(Uri.parse(productsApi),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    return response;
  }
}
