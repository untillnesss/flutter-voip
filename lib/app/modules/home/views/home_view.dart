import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:voip/app/modules/home/controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text('channel'),
            TextField(
              controller: controller.channelCon,
            ),
            Text('token'),
            TextField(
              controller: controller.tokenCon,
            ),
            RaisedButton(
              child: Text('JOIN'),
              onPressed: () async => await controller.joinCall(),
            ),
            RaisedButton(
              child: Text('LEAVE'),
              onPressed: controller.leaveCall,
            ),
          ],
        ),
      ),
    );
  }
}
