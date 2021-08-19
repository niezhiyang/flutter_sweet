import 'package:flutter/material.dart';
import 'package:flutter_sweet/over_lay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OverlayToolWidget(child:  Scaffold(
        appBar: AppBar(
          title: const Text("demo"),
        ),
        body: Center(child:Text("中心")),
      ),),

    );
  }
}
