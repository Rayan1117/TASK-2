import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:quote_of_the_day/database.dart';
import 'package:quote_of_the_day/saved.dart';
import 'package:share/share.dart';
import 'quote_data.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QuoteScreenState createState() => _QuoteScreenState();
}

List<List<dynamic>>? saved;

class _QuoteScreenState extends State<QuoteScreen> {
  late String backgroundImageUrl;
  late Future<Quote> currentQuote;

  final quo = Hive.box("Quotes");
  Database db = Database();

  @override
  void initState() {
    if (quo.get("SAVED") != null) {
      db.load();
    }
    super.initState();
    loadRandomImage();
    saved = [];
    currentQuote = fetchRandomQuote();
  }

  void loadRandomImage() {
    backgroundImageUrl =
        "https://source.unsplash.com/featured/?artificial-intelligence";
  }

  void shareQuote() {
    currentQuote.then((quote) {
      final String text = '${quote.text} - ${quote.author}';
      Share.share(text);
    });
  }

  void copyQuote() {
    currentQuote.then((quote) {
      Clipboard.setData(
        ClipboardData(text: quote.text),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quote copied to clipboard'),
        ),
      );
    });
  }

  void refreshQuotes() {
    setState(() {
      currentQuote = fetchRandomQuote();
    });
  }

  void saveQuote() {
    currentQuote.then((quote) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quote saved'),
        ),
      );
      setState(
        () {
          saved!.add([quote.text, quote.author]);
          db.update();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote of the day'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedQuotesPage(savedQuotes: saved),
                ),
              );
            },
            icon: const Icon(Icons.bookmark),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: backgroundImageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                color: Colors.black.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<Quote>(
                    future: currentQuote,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error loading quote');
                      } else {
                        final quote = snapshot.data!;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              quote.text,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '- ${quote.author}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: refreshQuotes,
            tooltip: "Refresh",
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: shareQuote,
            tooltip: 'Share',
            child: const Icon(Icons.share),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: copyQuote,
            tooltip: 'Copy',
            child: const Icon(Icons.copy),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: saveQuote,
            tooltip: 'Save',
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
