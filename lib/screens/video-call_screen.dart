import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallScreen extends StatefulWidget {
  final int appID;
  final String appSign;
  final String userID;
  final String userName;
  final String otherUserID;
  final String otherUserName;

  const VideoCallScreen({
    super.key,
    required this.appID,
    required this.appSign,
    required this.userID,
    required this.userName,
    required this.otherUserID,
    required this.otherUserName,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _permissionsGranted = false;
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    setState(() => _isRequesting = true);

    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && micStatus.isGranted) {
      setState(() {
        _permissionsGranted = true;
        _isRequesting = false;
      });
    } else {
      setState(() => _isRequesting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera and microphone permissions are required')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final callID = [widget.userID, widget.otherUserID]..sort();

    return Scaffold(
      body: Center(
        child: _isRequesting
            ? const CircularProgressIndicator()
            : _permissionsGranted
            ? ZegoUIKitPrebuiltCall(
          appID: widget.appID,
          appSign: widget.appSign,
          userID: widget.userID,
          userName: widget.userName,
          callID: callID.join("_"),
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            ..bottomMenuBar = ZegoCallBottomMenuBarConfig(
              buttons: [
                ZegoCallMenuBarButtonName.toggleMicrophoneButton,
                ZegoCallMenuBarButtonName.toggleCameraButton,
                ZegoCallMenuBarButtonName.switchCameraButton,
                ZegoCallMenuBarButtonName.hangUpButton,
              ],
            ),


        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Permissions required to start the call.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestPermissions,
              child: const Text('Grant Permissions'),
            ),
          ],
        ),
      ),
    );
  }
}