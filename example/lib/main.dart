import 'dart:async';

import 'package:example/src/app/app_manager.dart';
import 'package:example/src/app/routing/app_router.dart';
import 'package:flutter/material.dart';

import 'src/core/themes/themes.dart';
import 'src/core/di/service_locator.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  

  runZonedGuarded(() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      Zone.current.handleUncaughtError(
        details.exception,
        details.stack ?? StackTrace.current,
      );
    };

    WidgetsFlutterBinding.ensureInitialized();
    await setupServiceLocator();
    runApp(const MyApp());

    
  }, (error, stack) {
    debugPrint('🔥 Uncaught error: $error');
    debugPrintStack(stackTrace: stack);

    // Optional: report to Crashlytics / Sentry
  });

  
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppManager().initialize();
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'App Pigeon',
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      onGenerateRoute: (settings) {
        return AppRouter.onGenerateRoute(settings);
      },
      builder: (context, child) {
        return child ?? Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      home: FakeApp()
    );
  }
}


class FakeApp extends StatelessWidget {
  const FakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}