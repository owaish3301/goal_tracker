import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/database_service.dart';
import 'core/services/background_schedule_service.dart';
import 'core/observers/app_lifecycle_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  await DatabaseService.initialize();

  // Initialize background schedule service (Android only)
  if (Platform.isAndroid) {
    await BackgroundScheduleService().initialize();
  }

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  AppLifecycleObserver? _lifecycleObserver;

  @override
  void initState() {
    super.initState();
    // Initialize lifecycle observer after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lifecycleObserver = ref.read(appLifecycleObserverProvider);
      WidgetsBinding.instance.addObserver(_lifecycleObserver!);
      // Record initial app launch activity
      _lifecycleObserver!.recordInitialActivity();
    });
  }

  @override
  void dispose() {
    if (_lifecycleObserver != null) {
      WidgetsBinding.instance.removeObserver(_lifecycleObserver!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);

    return GestureDetector(
      // Dismiss keyboard when tapping outside of text fields
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp.router(
        title: 'Goal Tracker',
        theme: AppTheme.darkTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
