import 'package:flutter/material.dart';
import '../controller/sharedpref_controller.dart';
import '../models/quote.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'quote_update_view.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  SharedPrefController sharedPrefController = SharedPrefController();
  List<Quote> quotes = [];

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String key in prefs.getKeys()) {
      if (prefs.get(key) == true) {
        var quoteKey = key.substring(4);
        var data = await sharedPrefController.read(quoteKey);
        setState(() {
          Quote quote = Quote.fromJson(data, null);
          // quote.id = data['id'];
          quotes.add(quote);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return quotes.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("No quotes saved"),
            ],
          )
        : Stack(
            children: [
              ListView.builder(
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return QuoteEditView(
                              quote: quotes[index],
                            );
                          },
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                    child: Card(
                      elevation: 2.0,
                      child: ListTile(
                        leading: Text(
                          '${quotes[index].author!} - ',
                        ),
                        title: Text(
                          quotes[index].content!,
                          textAlign: TextAlign.end,
                        ),
                        contentPadding: const EdgeInsets.all(8),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 30,
                right: 30,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                  ),
                  child: const Text(
                    'Delete All',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    setState(() {
                      quotes = [];
                    });
                  },
                ),
              ),
            ],
          );
  }
}
