import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/quote.dart';

class AuthorQuotesController {
  String author;

  AuthorQuotesController({
    required this.author,
  });

  Future<Quote> getAuthorQuoteResponse() async {
    author = author.trim().replaceAll(" ", "-");
    var url = Uri.parse("https://quotable.io/quotes?author=$author");
    final response = await http.get(url);
    Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      return Quote.fromJson(data, data['count']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
