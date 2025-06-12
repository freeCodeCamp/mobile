enum Ext {
  js('js'),
  html('html'),
  css('css'),
  jsx('jsx');

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
    default:
      return Ext.html;
  }
}
