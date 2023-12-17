import 'dart:io';

String getFileSize(File file) {
  int bytes = file.lengthSync();
  double kb = bytes / 1024;
  double mb = kb / 1024;
  double gb = mb / 1024;
  double tb = gb / 1024;

  if (tb > 1) {
    return "${tb.toStringAsFixed(2)} TB";
  } else if (gb > 1) {
    return "${gb.toStringAsFixed(2)} GB";
  } else if (mb > 1) {
    return "${mb.toStringAsFixed(2)} MB";
  } else if (kb > 1) {
    return "${kb.toStringAsFixed(2)} KB";
  } else {
    return "${bytes.toStringAsFixed(2)} bytes";
  }
}

String getTotalSize(List<File> files) {
  int bytes = 0;
  files.forEach((file) {
    bytes += file.lengthSync();
  });
  double kb = bytes / 1024;
  double mb = kb / 1024;
  double gb = mb / 1024;
  double tb = gb / 1024;

  if (tb > 1) {
    return "${tb.toStringAsFixed(2)} TB";
  } else if (gb > 1) {
    return "${gb.toStringAsFixed(2)} GB";
  } else if (mb > 1) {
    return "${mb.toStringAsFixed(2)} MB";
  } else if (kb > 1) {
    return "${kb.toStringAsFixed(2)} KB";
  } else {
    return "${bytes.toStringAsFixed(2)} bytes";
  }
}
