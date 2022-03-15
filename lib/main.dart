import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I am so booooooored...',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Are you bored?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future _queryApi() async {
    var response =
        await get(Uri.parse("https://www.boredapi.com/api/activity"));
    if (response.statusCode != 200) {
      throw Exception("API error");
    }

    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () async {
                await launch("https://www.buymeacoffee.com/xeladu");
              },
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder(
                future: _queryApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          Container(height: 10),
                          const Text(
                              "Query failed, check connection and retry!",
                              style: TextStyle(fontSize: 18)),
                          Container(height: 30),
                          _addReloadButton()
                        ]);
                  }

                  return _showSuggestion(snapshot.data);
                })));
  }

  Widget _showSuggestion(Object? data) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Center(
          child: Card(
              color: Colors.blue.shade50,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                      (data as Map<String, dynamic>)["activity"].toString(),
                      style: const TextStyle(fontSize: 18))))),
      Container(height: 30),
      _addReloadButton()
    ]);
  }

  Widget _addReloadButton() {
    return ActionChip(
        padding: const EdgeInsets.all(10),
        label: const Text("Try again", style: TextStyle(fontSize: 18)),
        onPressed: () => {setState(() {})});
  }
}
