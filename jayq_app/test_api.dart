import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('Testing API Connection...\n');

  // Test 1: Check if backend is reachable
  try {
    final url = Uri.parse('http://10.0.2.2:8000/api/login');
    print('Testing URL: $url');

    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({'email': 'admin@jayq.com', 'password': 'password'}),
        )
        .timeout(Duration(seconds: 10));

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}\n');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('✅ Login successful!');
      print('Token: ${data['data']['token']?.substring(0, 20)}...');
      print('User: ${data['data']['user']['nama']}');
      print('Role: ${data['data']['user']['role']}');
    } else {
      print('❌ Login failed!');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('❌ Error: $e');
    print('\nPossible issues:');
    print('1. Backend not running (run: php artisan serve)');
    print(
      '2. Wrong IP address (use 10.0.2.2 for emulator, or your PC IP for device)',
    );
    print('3. Firewall blocking connection');
  }
}
