enum Ext { js, html, css, jsx, py }

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
    case 'py':
      return Ext.py;
    default:
      return 'html';
  }
}
