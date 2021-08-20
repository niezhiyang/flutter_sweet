import 'package:flutter_sweet/log_mode.dart';

class FileUtil {
  /// 拿到当前文件名字 和 行号
  static LogMode getFileInfo() {
    LogMode mode = LogMode();
    try {
      String traceString = StackTrace.current.toString().split("\n")[3];
      int indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));
      String fileInfo = traceString.substring(indexOfFileName);
      List<String> listOfInfos = fileInfo.split(":");
      String fileName = listOfInfos[0];
      String lineNumber = listOfInfos[1];
      mode.fileName = fileName;
      mode.logLine = lineNumber;
    } catch (e) {
      // NoThing
    }

    return mode;
  }
}