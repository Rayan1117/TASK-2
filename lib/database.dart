import "package:hive/hive.dart";
import "package:quote_of_the_day/quote_screen.dart";

class Database {
  final quote = Hive.box("Quotes");
   void update() {
    quote.put("SAVED", saved);
  }

  void load() {
    saved = quote.get("SAVED");
  }
}