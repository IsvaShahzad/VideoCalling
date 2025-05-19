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
    setState(() {
      _isRequesting = true;
    });

    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && micStatus.isGranted) {
      setState(() {
        _permissionsGranted = true;
        _isRequesting = false;
      });
    } else if (cameraStatus.isPermanentlyDenied || micStatus.isPermanentlyDenied) {
      setState(() {
        _isRequesting = false;
      });

      // Ask user to open app settings
      bool opened = await openAppSettings();
      if (!opened) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable permissions from app settings')),
          );
        }
      }
      // Optionally, you can pop or do something else here if permissions are not granted
    } else {
      setState(() {
        _isRequesting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera and microphone permissions are required to start the call.')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create a unique call ID by sorting user IDs
    final callID = [widget.userID, widget.otherUserID]..sort();

    return Scaffold(
      appBar: AppBar(title: Text('Video Call with ${widget.otherUserName}')),
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
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Permissions are required to start the video call.'),
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
