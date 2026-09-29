import 'package:flutter/widgets.dart';

class AppLifecycleService extends ChangeNotifier with WidgetsBindingObserver {
  static final AppLifecycleService _instance = AppLifecycleService._internal();
  static AppLifecycleService get instance => _instance;

  AppLifecycleState _state = AppLifecycleState.resumed;
  AppLifecycleState get state => _state;

  bool get isResumed => _state == AppLifecycleState.resumed;
  bool get isPaused =>
      _state == AppLifecycleState.paused || _state == AppLifecycleState.inactive;

  AppLifecycleService._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_state != state) {
      _state = state;
      debugPrint('AppLifecycleState changed to: $state');

      // Free RAM image cache when app goes to background
      if (state == AppLifecycleState.paused) {
        PaintingBinding.instance.imageCache.clearLiveImages();
      }

      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
