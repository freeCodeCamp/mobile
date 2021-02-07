import 'package:logger/logger.dart';

import '../logger.dart';

class BaseService {
  Logger log;
  BaseService({String title}) {
    log = getLogger(title ?? this.runtimeType.toString());
  }
}
