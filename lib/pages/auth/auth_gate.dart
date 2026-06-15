import 'package:flclashx/application.dart';
import 'package:flclashx/common/common.dart';
import 'package:flclashx/pages/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root gate (ADR 0013): the app is usable as a guest, so it always mounts the
/// full [Application] once the stored token is hydrated. A minimal splash shows
/// while hydrating. Auth happens on-demand inside the app (claim a subscription)
/// — there is no separate blocking login screen.
class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _hydrated = false;

  @override
  void initState() {
    super.initState();
    _hydrate();
  }

  Future<void> _hydrate() async {
    final token = await preferences.getAuthToken();
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      ref.read(authTokenProvider.notifier).state = token;
    }
    setState(() {
      _hydrated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hydrated) {
      return const _AuthSplash();
    }
    return const Application();
  }
}

class _AuthSplash extends StatelessWidget {
  const _AuthSplash();

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
}
