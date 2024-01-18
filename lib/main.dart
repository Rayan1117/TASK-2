import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'quote_screen.dart';

void main() async {
  await Hive.initFlutter();

  // ignore: unused_local_variable
  var data = await Hive.openBox("Quotes");
  runApp(const QuoteApp());
}

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quotes of the Day',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QuoteScreen(),
    );
  }
}
