import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

typedef BeginFunc = Int64 Function();
typedef Beginf = int Function();

typedef IsReadyFunc = Int64 Function(Int64 trId);
typedef IsReadyf = int Function(int trId);

typedef CommitFunc = Int64 Function(Int64 trId);
typedef Commitf = int Function(int trId);

typedef InFunc = Int64 Function(Int64 trId, Int64 data);
typedef Inf = int Function(int trId, int data);

typedef OutFunc = Int64 Function(Int64 trId);
typedef Outf = int Function(int trId);

Future<String> call(String param) async {
  final dll = DynamicLibrary.open('mylib.dll');
  final Beginf begin =
      dll.lookup<NativeFunction<BeginFunc>>('Begin').asFunction();
  final IsReadyf isReady =
      dll.lookup<NativeFunction<IsReadyFunc>>('IsReady').asFunction();
  final Commitf commit =
      dll.lookup<NativeFunction<CommitFunc>>('Commit').asFunction();
  final Inf input = dll.lookup<NativeFunction<InFunc>>('In').asFunction();
  final Outf output = dll.lookup<NativeFunction<OutFunc>>('Out').asFunction();

  int trId = begin();
  print("FL: BEGIN: $trId");

  List<int> bytesToSend = utf8.encode(param);
  for (var b in bytesToSend) {
    input(trId, b);
  }
  input(trId, 0xFFFFFFFF);
  while (true) {
    var r = isReady(trId);
    if (r != 0) {
      break;
    }
    await Future.delayed(const Duration(milliseconds: 100));
  }

  List<int> resultBytes = [];

  while (true) {
    var b = output(trId);
    if (b == 0xFFFFFFFF) {
      break;
    }
    resultBytes.add(b);
  }

  return utf8.decode(resultBytes);
}

void main() {
  //print(call('{"f":"calc", "a": 42, "b" : 123123}'));
  //print(call('{"f":"calc", "a": 42, "b" : 123123}'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _result = "";

  void _incrementCounter() {
    call('{"f":"calc", "a": 1000000, "b" : $_counter}').then(
      (value) {
        setState(() {
          _result = value;
        });
      },
    );
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter = $_result',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
