import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

final _navigatorKey = GlobalKey<NavigatorState>();
bool haveMicrophonePermission = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final permission = await Permission.microphone.request();
  haveMicrophonePermission = permission.isGranted;

  FlutterCallkitIncoming.onEvent.listen((event) {
    if (event?.event == Event.actionCallAccept) {
      _navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (_) => const CallPage()))
          .then((_) => FlutterCallkitIncoming.endAllCalls());
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iOS Call Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: _navigatorKey,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Waiting for a call...'),
      ),
    );
  }
}

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    // final talkUrl =
    //     'wss://your-domain:443/proxy/127.0.0.1:559/sms/HCPEurl/commonvideobiz_lpKMpGvG2L3OamuHOPovnA3QYmGy%2F7Y8uqoDUfZgvw4%2B1grt%2FTIz2BAZik4lBL25FmxL3NPxlrxI2p6bab5qaGQtDm5o2DCiZTrSTSroeSqFRu0L%2BNW80sCh9reMrcbP0aO3UlHW02LZVJi4%2BMaoLHNCO%2FjyBrbEU2UvFsQOJ0%2FohuLtgr1pZ9dHydSP5esv3%2FG%2Bh5dCWMB8C%2BoTboxYxyw%3D%3D';

    final talkUrl = "put your talk url here"; // TODO: Put your talk URL here

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: !haveMicrophonePermission
                ? Text('No microphone permission :(')
                : Text('Handling call...'),
          ),
          SizedBox(
            height: 0,
            child: InAppWebView(
              initialUserScripts: UnmodifiableListView<UserScript>([]),
              initialSettings: InAppWebViewSettings(
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
              ),
              initialUrlRequest: URLRequest(
                url: WebUri.uri(
                  Uri(
                    scheme: 'https',
                    path: '/',
                    host: 'call.northwaterfront.evocontrols.com',
                    port: 443,
                    queryParameters: {'talk_url': talkUrl},
                  ),
                ),
              ),
              onPermissionRequest: (controller, request) async =>
                  PermissionResponse(
                action: PermissionResponseAction.GRANT,
                resources: request.resources,
              ),
              onConsoleMessage: (c, message) =>
                  print('Console message: ' + message.message),
              onReceivedServerTrustAuthRequest: (controller, challenge) async =>
                  ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
