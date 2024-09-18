import 'package:firebasepraktis/Notification_Service.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  NotificationService notificatonService = NotificationService();
  @override
  void initState() {
    super.initState();
    notificatonService.requestNotificationPermission();
    notificatonService.firebaseInit();
    notificatonService.isTokenRefresh();
    notificatonService.getDeviceToken().then((value) {
      print('Device token');
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
