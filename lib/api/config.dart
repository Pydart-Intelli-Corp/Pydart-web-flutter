import 'dart:convert';
import 'package:http/http.dart' as http;

String apiUrl = "https://lactosure.azurewebsites.net/api";
String domainurl = "https:pydart.in";

bool isLoading = false;
String userKey = "";
bool isPasswordReset = false;

Future<String?> postRequest(String url, Map<String, dynamic> body) async {
  isLoading = true; // Set isLoading to true before making the request
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return response.body.trim();
  } catch (e) {
    return null;
  } finally {
    isLoading =
        false; // Ensure isLoading is set to false after the request completes
  }
}

  // Helper function to parse the response.
  Map<String, String> parseResponse(Map<String, dynamic> response) {
    String message = response['message']?.toString() ?? "";
    String userKey = response['userKey']?.toString() ?? "";
    return {
      'message': message,
      'userKey': userKey,
    };
  }