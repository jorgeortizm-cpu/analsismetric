import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String? _lastSessionId;
  String? _lastQuery;

  String? get lastSessionId => _lastSessionId;
  String? get lastQuery => _lastQuery;

  void setAnalystContext({String? sessionId, String? query}) {
    _lastSessionId = sessionId ?? _lastSessionId;
    _lastQuery = query ?? _lastQuery;
    notifyListeners();
  }
}

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'AppStateProvider no encontrado');
    return provider!.notifier!;
  }
}
