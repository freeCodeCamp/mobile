import 'package:flutter/foundation.dart' show describeEnum;

enum Ext { js, html, css, jsx }

parseExt(String ext) {
  switch (ext) {
    case 'js':
      return Ext.js;
    case 'html':
      return Ext.html;
    case 'css':
      return Ext.css;
    case 'jsx':
      return Ext.jsx;
    default:
      return 'html';
  }
}

extension ExtValue on Ext {
  String get value => describeEnum(this);
}
