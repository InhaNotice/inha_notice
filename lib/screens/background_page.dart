// BackgroundPage 추가
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundPage extends StatefulWidget {
  const BackgroundPage({super.key});

  @override
  State<BackgroundPage> createState() => _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage> {
  String serviceStatus = 'Service Not Running';

  @override
  void initState() {
    super.initState();
    // 서비스 상태 확인 로직 추가
    FlutterBackgroundService().isRunning().then((isRunning) {
      setState(() {
        serviceStatus = isRunning ? 'Service Running' : 'Service Not Running';
      });
    });
  }

  void startService() {
    FlutterBackgroundService().startService();
    setState(() {
      serviceStatus = 'Service Running';
    });
  }

  void stopService() {
    FlutterBackgroundService().invoke('stopService');
    setState(() {
      serviceStatus = 'Service Not Running';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Background Service Status:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            serviceStatus,
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: startService,
            child: const Text('Start Service'),
          ),
          ElevatedButton(
            onPressed: stopService,
            child: const Text('Stop Service'),
          ),
        ],
      ),
    );
  }
}