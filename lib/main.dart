import 'dart:async';

import 'package:agri/thingspeak.dart';
import 'package:flutter/material.dart';

import 'network_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // useMaterial3: true,
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Agriculture'),
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
  Timer? timer;
  String field1 = "10";
  String field2 = "10";
  String field3 = "10";
  String field4 = "10";
  @override
  void initState() {
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getThings());
    getThings();
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    print(
      '${field4.trim()} ${((double.parse(field4.trim()).toInt().toString()).characters.last)},'
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1)),
              builder: (context, snapshot) {
                // getThings();
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 60,
                            ),
                            const Text(
                              'Values from Sensors',
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Humidity',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                Text(
                                  field1,
                                  style: Theme.of(context).textTheme.headline4,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Temperature',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                Text(
                                  field2,
                                  style: Theme.of(context).textTheme.headline4,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Moisture',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                Text(
                                  field3,
                                  style: Theme.of(context).textTheme.headline4,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'pH',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                Text(
                                  // field4,
                                  // String.fromCharCode(
                                  //     (double.parse(field4.trim()).toInt())),
                                  ((double.parse(field4.trim()).toInt().toString()).characters.last),
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ],
                            ),
                            Expanded(child: Container())
                            // Text(
                            //   '$field1\n$field2\n$field3\n$field4',
                            //   style: Theme.of(context).textTheme.headline4,
                            // ),
                          ],
                        ),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getThings();
          // setState(() {});
        },
        child: Icon(Icons.restart_alt),
      ),
    );
  }

  Future<void> getThings() async {

    setState(() {
      isLoading = true;
    });
    final json = await getData(
            "https://api.thingspeak.com/channels/1723505/feeds.json?api_key=KK8AK4V7NOFHIOEW&results=2",
            post: false) ??
        [];
    print(json);
    final things = ThingSpeak.fromJson(json);
    setState(() {
      field1 = things.feeds![1].field1.toString();
      field2 = things.feeds![1].field2.toString();
      field3 = things.feeds![1].field3.toString();
      field4 = things.feeds![1].field4.toString();
      isLoading = false;
    });
  }
}
