import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quote_of_the_day/database.dart';
import 'package:quote_of_the_day/quote_screen.dart';

class SavedQuotesPage extends StatefulWidget {
  final List<List<dynamic>>? savedQuotes;

  const SavedQuotesPage({Key? key, this.savedQuotes}) : super(key: key);

  @override
  State<SavedQuotesPage> createState() => _SavedQuotesPageState();
}

Database db = Database();

class _SavedQuotesPageState extends State<SavedQuotesPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.savedQuotes!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Saved Quotes"),
        ),
        body: const Center(
          child: Text(
            "No Saved Quotes",
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Quotes'),
      ),
      body: widget.savedQuotes!.isEmpty
          ? const Center(
              child: Text("No saved quotes."),
            )
          : ListView.builder(
              itemCount: widget.savedQuotes!.length,
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(
                            () {
                              saved!.removeAt(index);
                              db.update();
                            },
                          );
                        },
                        icon: const Icon(Icons.delete),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 8,
                          color: Colors.black.withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.savedQuotes![index][0],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '- ${widget.savedQuotes![index][1]}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
