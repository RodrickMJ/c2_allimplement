import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';

/// Mixin para manejar el timeout de sesión en cualquier pantalla
mixin SessionTimeoutMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<SessionTimeoutState>? _sessionSubscription;

  @override
  void initState() {
    super.initState();
    _initSessionTimeout();
  }

  void _initSessionTimeout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sessionConfig = Provider.of<SessionConfig>(context, listen: false);

      _sessionSubscription = sessionConfig.stream.listen((state) {
        if (state == SessionTimeoutState.userInactivityTimeout ||
            state == SessionTimeoutState.appFocusTimeout) {
          _handleSessionTimeout();
        }
      });
    });
  }

  void _handleSessionTimeout() {
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
    }
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    super.dispose();
  }
}