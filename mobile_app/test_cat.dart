import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  try {
    final res = await http.get(Uri.parse('http://localhost:5000/api/categories'));
    print('Status: \${res.statusCode}');
    final List data = jsonDecode(res.body);
    for (var item in data) {
       print('ID: \${item["id"]}, Name: \${item["name"]}, IconUrl: \${item["icon_url"]}');
    }
  } catch(e) {
    print('Error: \$e');
  }
}
