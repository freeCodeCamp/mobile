enum Ext {
  js('js'),
  html('html'),
  css('css'),
  jsx('jsx'),
  py('py');

  final String value;
  const Ext(this.value);
}

Ext parseExt(String ext) {
  switch (ext) {
    case 'js':
      return Ext.js;
    case 'html':
      return Ext.html;
    case 'css':
      return Ext.css;
    case 'jsx':
      return Ext.jsx;
    case 'py':
      return Ext.py;
    default:
      return Ext.html;
  }
}
