/// Return a well formated platform name from a key
/// (e.g. web -> Web).
String getPlatformName(String platformKey) {
  switch (platformKey) {
    case 'android':
      return 'Android';
    case 'androidtv':
      return 'Android TV';
    case 'ios':
      return 'iOS';
    case 'ipados':
      return 'iPad OS';
    case 'linux':
      return 'Linux';
    case 'macos':
      return 'macOS';
    case 'web':
      return 'Web';
    case 'windows':
      return 'Windows';
    default:
      return '${platformKey.substring(0,1).toUpperCase()}${platformKey.substring(1)}';
  }
}
