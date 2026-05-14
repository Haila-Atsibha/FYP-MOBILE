import 'dart:io';

void main() async {
  final directories = [
    r'c:\Users\Y\OneDrive\Desktop\FYP_MOBILE\mobile_app\lib\screens\provider',
    r'c:\Users\Y\OneDrive\Desktop\FYP_MOBILE\mobile_app\lib\screens\admin',
    r'c:\Users\Y\OneDrive\Desktop\FYP_MOBILE\mobile_app\lib\screens\customer',
    r'c:\Users\Y\OneDrive\Desktop\FYP_MOBILE\mobile_app\lib\screens\chat',
    r'c:\Users\Y\OneDrive\Desktop\FYP_MOBILE\mobile_app\lib\screens\complaint',
    r'c:\Users\Y\OneDrive\Desktop\FYP_MOBILE\mobile_app\lib\widgets',
  ];

  final strings = <String>{};
  final regex1 = RegExp(r"Text\(\s*'([^'\\]*(?:\\.[^'\\]*)*)'");
  final regex2 = RegExp(r'Text\(\s*"([^"\\]*(?:\\.[^"\\]*)*)"');

  for (var dirPath in directories) {
    final dir = Directory(dirPath);
    if (!await dir.exists()) continue;
    await for (var entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        // Exclude home_screen because it's already localized (it's in customer directory in my thoughts previously? No, it's in screens/home)
        // Wait, where is home_screen.dart? It's in lib/screens/home. So customer directory is just customer_profile_screen etc.
        final content = await entity.readAsString();
        for (var match in regex1.allMatches(content)) {
          final s = match.group(1);
          if (s != null && !s.contains(r'$')) strings.add(s);
        }
        for (var match in regex2.allMatches(content)) {
          final s = match.group(1);
          if (s != null && !s.contains(r'$')) strings.add(s);
        }
      }
    }
  }

  print(strings.toList().join('\n'));
}
