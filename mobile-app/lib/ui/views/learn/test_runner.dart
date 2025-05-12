enum WorkerType { python, dom, javascript }

class Code {
  const Code({required this.contents, this.editableContents});

  final String contents;
  final String? editableContents;
}

const hideFccHeaderStyle = '''
<style class="fcc-hide-header">
  head *,
  title,
  meta,
  link,
  script {
    display: none !important;
  }
</style>
''';
