import 'package:flutter/material.dart';
import 'package:flutter_sweet/console_util.dart';
import 'package:flutter_sweet/log_mode.dart';
import 'package:flutter_sweet/overlay_widget.dart';

void main() {
  ConsoleUtil.initConsole();
  // notifier.addLog(LogMode(logLine: "100",logMessage: "nnnnnn",fileName: "nihao"));
  // notifier.addLog(LogMode(logLine: "200",logMessage: "222222",fileName: "nihao"));
  // notifier.addLog(LogMode(logLine: "300",logMessage: "33333333",fileName: "nihao"));
  // notifier.addLog(LogMode(logLine: "400",logMessage: "4444444",fileName: "nihao"));
  // notifier.addLog(LogMode(logLine: "500",logMessage: "555555",fileName: "nihao"));
  // notifier.addLog(LogMode(logLine: "600",logMessage: "555555",fileName: "nihao"));
  // notifier.addLog(LogMode(logLine: "700",logMessage: "555555",fileName: "nihao"));
  // notifier.addLog(LogMode(logLine: "800",logMessage: "555555",fileName: "nihao"));
  // notifier.addLog(LogMode(logLine: "900",logMessage: "555555",fileName: "nihao"));
  notifier.addLog(LogMode(logLine: "100", logMessage: "555555", fileName: "sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss"));
  // notifier.addLog(LogMode(logLine: "1100",logMessage: "555555",fileName: "nihao"));
  // notifier.addLog(LogMode(logLine: "1200",logMessage: "555555",fileName: "nihao"));
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

  var count = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OverlayToolWidget(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("demo"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: printLog,
            child: Icon(Icons.add),
          ),
          body: Center(
            child: MaterialButton(
              color: Colors.blue,
              onPressed: printLog,

              child: Text("点我或者下面打印",style: TextStyle(color:Colors.white),),
            ),
          ),
        ),
      ),
    );
  }

  void printLog() {
    count++;
    debugPrint("ddddddddddd   $count$count$count");
  }
}
