import 'package:flclashx/application.dart';
import 'package:flclashx/common/common.dart';
import 'package:flclashx/l10n/l10n.dart';
import 'package:flclashx/pages/auth/auth_state.dart';
import 'package:flclashx/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root gate that decides between the login flow and the authenticated app.
///
/// On startup it hydrates [authTokenProvider] from [preferences]. While that is
/// in flight a minimal splash is shown. When there is no token a lightweight
/// [MaterialApp] hosting [LoginPage] is rendered; the full [Application] (with
/// its clash/window/tray managers) only mounts once authenticated, so the heavy
/// platform initialization is deferred until after login.
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
    final token = ref.watch(authTokenProvider);
    if (token == null || token.isEmpty) {
      return const _AuthApp(home: LoginPage());
    }
    return const Application();
  }
}

/// Minimal MaterialApp used only for the unauthenticated flow so the login/
/// register pages get localizations, theming and a Navigator without pulling in
/// the full [Application] manager stack.
class _AuthApp extends StatelessWidget {
  const _AuthApp({required this.home});

  final Widget home;

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.delegate.supportedLocales,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(defaultPrimaryColor),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(defaultPrimaryColor),
            brightness: Brightness.dark,
          ),
        ),
        home: home,
      );
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
