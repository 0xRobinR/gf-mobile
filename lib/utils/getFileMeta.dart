String getFileType(String fileName) {
  var extension = fileName.split('.').last;

  const mimeTypes = {
    'json': 'application/json',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'bmp': 'image/bmp',
    'txt': 'text/plain',
    'html': 'text/html',
    'pdf': 'application/pdf',
    'doc': 'application/msword',
    'docx':
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ppt': 'application/vnd.ms-powerpoint',
    'pptx':
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'wav': 'audio/wav',
    'mp3': 'audio/mpeg',
    'mp4': 'video/mp4',
    'avi': 'video/x-msvideo',
    'mkv': 'video/x-matroska',
    'gz': 'application/gzip',
    'tar': 'application/x-tar',
    'zip': 'application/zip',
    '7z': 'application/x-7z-compressed',
    'rar': 'application/x-rar-compressed',
    'iso': 'application/x-iso9660-image',
    'img': 'application/x-iso9660-image',
    'exe': 'application/x-msdownload',
    'apk': 'application/vnd.android.package-archive',
    'deb': 'application/vnd.debian.binary-package',
    'rpm': 'application/x-rpm',
  };

  return mimeTypes[extension.toLowerCase()] ?? 'application/octet-stream';
}
