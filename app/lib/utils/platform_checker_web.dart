import 'dart:html' as html;

bool isPlatformAndroidWeb() {
  String userAgent = html.window.navigator.userAgent.toLowerCase();
  return userAgent.contains('android');
}