import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  static int counter = 0;

  final String className;

  final Map<Level, AnsiColor> levelColors = {
    Level.verbose: AnsiColor.fg(250),
    Level.debug: AnsiColor.fg(92),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(214),
    Level.error: AnsiColor.fg(196),
    Level.wtf: AnsiColor.fg(199),
  };

  SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    String message = event.message;
    AnsiColor color = levelColors[event.level];
    String className = this.className;
    SimpleLogPrinter.counter += 1;
    int sequenceNumber = SimpleLogPrinter.counter;

    return [color('$sequenceNumber. [$className]: $message')];
  }
}

Logger getLogger(String className) {
  return Logger(
    printer: SimpleLogPrinter(
      className,
    ),
  );
}
