import 'dart:async';

class RefreshLock {
  Completer<void>? _completer;

  Future<void> lock() async {
    if (_completer == null) {
      _completer = Completer<void>();
      return;
    }
    return _completer!.future;
  }

  void unlock() {
    _completer?.complete();
    _completer = null;
  }
}
