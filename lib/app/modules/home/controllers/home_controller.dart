import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  RtcEngine engine;
  TextEditingController channelCon = TextEditingController(text: 'jajalan');
  TextEditingController tokenCon = TextEditingController(
      text:
          '006270391cbd8554b378db4a8a4465f33deIADc7VTjhpxG4IxyBxDaxS+LehzcTay4Dwgw9cgfh+RzyF3LO7YAAAAAEAARpytrjubKYAEAAQCN5spg');

  String channelId = '9KutQAJKDp-1623752381';
  String appId = '270391cbd8554b378db4a8a4465f33de';
  String token =
      '006270391cbd8554b378db4a8a4465f33deIACD3wWb1DRLh+tTcXLIztLaCaBmcJ5jg6drg/CvGRnz0WRiI5AAAAAAIgDmAAIAPdDJYAQAAQDNjMhgAwDNjMhgAgDNjMhgBADNjMhg';
  String status = 'iddle';

  bool isJoined = false,
      openMicrophone = true,
      enableSpeakerphone = true,
      isEnd = false;

  @override
  void onInit() {
    super.onInit();
    // this._initEngine();
    this.initVOIP();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> initVOIP() async {
    // Get microphone permission
    PermissionStatus micPermissionResult =
        await Permission.microphone.request();

    if (!micPermissionResult.isGranted) {
      return Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text('Gagal !'),
            content: Text(
                'Kami membutuhkan izin untuk menggunakan mikrofon anda, mohon beri aksas dan kembali lagi !'),
            actions: [
              FlatButton(
                onPressed: () {
                  // TODO implement close page when denied
                  Get.back();
                },
                child: Text('OK'),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    }

    // Create RTC client instance
    RtcEngineConfig config = RtcEngineConfig(appId);
    engine = await RtcEngine.createWithConfig(config);

    // Define event handling logic
    engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (String channel, int uid, int elapsed) {
        print('joinChannelSuccess $channel $uid');

        update();
      },
      userJoined: (int uid, int elapsed) {
        print('userJoined $uid');
        isJoined = true;
        isEnd = false;

        update();
      },
      userOffline: (int uid, UserOfflineReason reason) {
        print('userOffline $uid');
        isJoined = false;
        isEnd = true;

        update();
      },
    ));
  }

  joinCall() async {
    this.status = '....';
    update();
    // Join channel with channel name as 123
    await engine.joinChannel(tokenCon.text, channelCon.text, null, 0);

    await engine.enableAudio();
    await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine.setClientRole(ClientRole.Broadcaster);
    await engine.enableLocalAudio(openMicrophone);
    await engine.setEnableSpeakerphone(enableSpeakerphone);
    this.status = 'connected';
    update();
  }

  leaveCall() async {
    this.status = '...';
    update();
    await engine.leaveChannel();

    this.status = 'iddle';
    update();
    print('success');
  }

  switchMicrophone() async {
    await engine.enableLocalAudio(!openMicrophone);

    openMicrophone = !openMicrophone;
    update();
  }

  switchSpeakerphone() async {
    await engine.setEnableSpeakerphone(!enableSpeakerphone);

    enableSpeakerphone = !enableSpeakerphone;
    update();
  }
}
