import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_sweet/file_util.dart';
import 'package:flutter_sweet/log_mode.dart';

LogValueNotifier notifier = LogValueNotifier();

class ConsoleUtil {
  /// 初始化打印日志
  static void initConsole() {
    debugPrint = (String? message, {int? wrapWidth}) {
      final List<String> messageLines =
          message?.split('\n') ?? <String>['null'];
      if (wrapWidth != null) {
        _debugPrintBuffer.addAll(messageLines
            .expand<String>((String line) => debugWordWrap(line, wrapWidth)));
      } else {
        _debugPrintBuffer.addAll(messageLines);
      }
      if (!_debugPrintScheduled) _debugPrintTask();
    };
  }

  static int _debugPrintedCharacters = 0;
  static const int _kDebugPrintCapacity = 12 * 1024;
  static const Duration _kDebugPrintPauseTime = Duration(seconds: 1);
  static final Queue<String> _debugPrintBuffer = Queue<String>();
  static final Stopwatch _debugPrintStopwatch = Stopwatch();
  static Completer<void>? _debugPrintCompleter;
  static bool _debugPrintScheduled = false;

  static void _debugPrintTask() {
    _debugPrintScheduled = false;
    if (_debugPrintStopwatch.elapsed > _kDebugPrintPauseTime) {
      _debugPrintStopwatch.stop();
      _debugPrintStopwatch.reset();
      _debugPrintedCharacters = 0;
    }
    while (_debugPrintedCharacters < _kDebugPrintCapacity &&
        _debugPrintBuffer.isNotEmpty) {
      final String line = _debugPrintBuffer.removeFirst();
      _debugPrintedCharacters += line.length;
      print(line);
      LogMode mode = FileUtil.getFileInfo();
      mode.logMessage = line;
      notifier.addLog(mode);
    }
    if (_debugPrintBuffer.isNotEmpty) {
      _debugPrintScheduled = true;
      _debugPrintedCharacters = 0;
      Timer(_kDebugPrintPauseTime, _debugPrintTask);
      _debugPrintCompleter ??= Completer<void>();
    } else {
      _debugPrintStopwatch.start();
      _debugPrintCompleter?.complete();
      _debugPrintCompleter = null;
    }
  }
}
