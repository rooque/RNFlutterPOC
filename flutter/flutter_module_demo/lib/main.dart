import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  int _counter = 0;
  String _content = null;
  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    setState(() {
      _notification = state;
    });
    if (state == AppLifecycleState.resumed)
      readSharedState();
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.parent.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/files/test.json');
  }

  Future readSharedState() async {
    try {
      final file = await _localFile;
      print(file);
      // Read the file.
      String contents = await file.readAsString();
      print(contents);
      setState(() {
        _content = contents;
      });
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: BackButton(onPressed: () => SystemNavigator.pop()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _content ?? '.',
            ),
            FlatButton(
                onPressed: () => readSharedState(), child: Text('Read State'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Test()),
        ),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('teste')),
      body: Container(child: Text('teste')),
    );
  }
}
