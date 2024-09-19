import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;

class Place {
  final String placeName;

  Place({required this.placeName});
}

class AppInfo extends GetxController {
  var dropoffLocation = Rx<Place?>(null);
  var pickupAddress = Rx<Place?>(null);
}

class PushNotificationService {
  static const String serviceAccountJson = '''{
    "type": "service_account",
    "project_id": "your-project-id",
    "private_key_id": "your-private-key-id",
    "private_key": "-----BEGIN PRIVATE KEY-----\\nYOUR_PRIVATE_KEY\\n-----END PRIVATE KEY-----\\n",
    "client_email": "your-client-email",
    "client_id": "your-client-id",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/your-client-email"
  }''';

  static Future<String> getAccessToken() async {
    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];
    final client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredintialViaService(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> sendNotificationToSelectedDrive(
      String deviceToken, String tripID) async {
    final appInfo = Get.find<AppInfo>();
    String dropOffDestinationAddress =
        appInfo.dropoffLocation.value?.placeName ?? "Unknown location";
    String pickupAddress =
        appInfo.pickupAddress.value?.placeName ?? "Unknown location";
    String userName = "YourUserName";

    final String serviceAccessTokenKey = await getAccessToken();
    String endpointFirebaseCloudMessaging =
        "https://fcm.googleapis.com/v1/projects/fir-tutorials-355df/messages:send";

    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': 'NET TRIP REQUEST from $userName',
          'body':
              'PickUp Location: $pickupAddress \n Drop Off Location: $dropOffDestinationAddress',
        },
        'data': {
          'TripID': tripID,
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serviceAccessTokenKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('FCM message sent successfully');
    } else {
      print('Failed to send FCM message: ${response.statusCode}');
    }
  }
}
