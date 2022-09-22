import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MailChimpService {
  Future<http.Response> addContact(
      String emailAddress, String firstName, String lastName) async {
    try {
      const myToken = "cde4bc1ba3697c3c20f8e7d439bfb657-us14";
      String listID = "fb8f5b32ae";
      String baseToken = myToken.split('-')[0];
      String datacenter = myToken.split('-')[1];

      String basePath = "https://$datacenter.api.mailchimp.com/";
      String authString = "seniorstack007:$myToken"; // apikey is the username
      String encoded = base64.encode(utf8.encode(authString));

      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        "Authorization": "Basic $encoded"
      };

      Map<String, dynamic> jsonRqst = {
        "email_address": emailAddress,
        "merge_fields": {"FNAME": firstName, "LNAME": lastName},
        "status": "subscribed"
      };
      var response = await http.post(
          Uri.parse("${basePath}3.0/lists/$listID/members"),
          body: jsonEncode(jsonRqst),
          headers: headers);
      return response;
    } catch (err) {
      print(err);
      rethrow;
    }
  }
}
