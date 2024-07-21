import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ecoplate/app/security_cameras/service/detection_service.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  late CameraController _controller;
  late DetectionService _detectionService;
  bool _isLiveStream = false;
  String _detectionResult = '';
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _detectionService = DetectionService();
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        print('No cameras found');
        return;
      }
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera Detection')),
      body: _isCameraInitialized
          ? Column(
              children: [
                Expanded(
                  child:
                      _isLiveStream ? Image.network(_detectionService.getVideoFeedUrl()) : CameraPreview(_controller),
                ),
                ElevatedButton(
                  onPressed: _isLiveStream ? null : _captureAndDetect,
                  child: Text('Capture and Detect'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => _isLiveStream = !_isLiveStream),
                  child: Text(_isLiveStream ? 'Switch to Camera' : 'Switch to Live Stream'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Detection Result: $_detectionResult'),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _captureAndDetect() async {
    try {
      final image = await _controller.takePicture();
      final result = await _detectionService.detectImage(File(image.path));
      setState(() {
        _detectionResult = result;
      });
    } catch (e) {
      print('Error capturing and detecting: $e');
      setState(() {
        _detectionResult = 'Error: $e';
      });
    }
  }
}
