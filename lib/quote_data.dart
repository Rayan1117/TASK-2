import 'dart:convert';
import 'package:http/http.dart' as http;

class Quote {
  final String text;
  final String author;

  Quote(this.text, this.author);
}

Future<Quote> fetchRandomQuote() async {
  final response = await http.get(Uri.parse('https://api.quotable.io/random'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final String text = data['content'];
    final String author = data['author'];
    return Quote(text, author);
  } else {
    throw Exception('Failed to load random quote');
  }
}

final List<Quote> quotes = [];

