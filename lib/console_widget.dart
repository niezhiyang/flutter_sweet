import 'package:flutter/material.dart';
import 'package:flutter_sweet/log_mode.dart';

import 'console_util.dart';

class ConsoleWidget extends StatefulWidget {
  const ConsoleWidget({Key? key}) : super(key: key);

  @override
  _ConsoleWidgetState createState() => _ConsoleWidgetState();
}

class _ConsoleWidgetState extends State<ConsoleWidget> {
  final TextStyle _prefixStyle = const TextStyle(
      color: Colors.white54,
      fontSize: 14,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.normal);
  final TextStyle _logStyle = const TextStyle(
      color: Colors.white,
      fontSize: 15,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w400);

  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.only(top: 57),
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: ValueListenableBuilder<LogModeValue>(
        valueListenable: notifier,
        builder: (BuildContext context, LogModeValue model, Widget? child) {
          // Future.delayed(Duration(milliseconds: 200)).then((value){
          //   _controls.handleSelectAll(EditableTextState());
          // });
          return _getChild(model);
        },
      ),
    );
  }

  MaterialTextSelectionControls _controls = MaterialTextSelectionControls();
  Widget _getChild(LogModeValue model) {
    List<TextSpan> spanList = [];
    List<LogMode> modeList = model.logModeList;
    for (int i = modeList.length - 1; i >= 0; i--) {
      LogMode logMode = modeList[i];
      TextSpan span = TextSpan(
        text: "${logMode.fileName}:${logMode.logLine}",
        style: _prefixStyle,
        children: [
          TextSpan(
            text: "${logMode.logMessage}\n",
            style: _logStyle,
          ),
        ],
      );

      spanList.add(span);
    }

    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectableText.rich(
            TextSpan(
              children: spanList,
            ),
            style: _logStyle,
            selectionControls: _controls,
          ),
        ),
      ),
    );
  }
}
