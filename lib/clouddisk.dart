import 'package:clouddisk/constant/root_path.dart';
import 'package:clouddisk/features/authentication/bloc/auth_bloc.dart';
import 'package:clouddisk/features/authentication/bloc/auth_event.dart';
import 'package:clouddisk/features/authentication/bloc/auth_state.dart';
import 'package:clouddisk/features/home/view/home_screen.dart';
import 'package:clouddisk/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCloudDiskApp extends StatefulWidget {
  const MyCloudDiskApp({
    super.key,
    required this.root,
  });
  final String root;

  @override
  State<MyCloudDiskApp> createState() => _MyCloudDiskAppState();
}

class _MyCloudDiskAppState extends State<MyCloudDiskApp> {
  late final String hmail_key;
  late final String session;

  @override
  void initState() {
    RootPath.setRoot(widget.root);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    hmail_key =
        (ModalRoute.of(context)!.settings.arguments as Map)["hmail_key"];
    session = (ModalRoute.of(context)!.settings.arguments as Map)["session"];
    SharedPreferencesUtils.initSharedPreferencesInstance();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(hmail_key: hmail_key, session: session),
      child: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        context.read<AuthBloc>().add(CheckingAuthenticationCondition());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      title: 'CloudDisk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          displaySmall: TextStyle(
            color: Colors.black,
            fontSize: 13,
          ),
        ),
      ),
      routes: {
        "/home_screen": (context) => const HomeScreen(),
        "/loaing_screen": (context) =>
            const Material(child: Center(child: CircularProgressIndicator())),
        "/failure_screen": (context) => const Material(
              type: MaterialType.card,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Text(
                    "Unauthenticated !!! Don't have data about use \nPlease login to groupware first",
                    style: TextStyle(fontSize: 30, color: Colors.red),
                  ),
                ),
              ),
            ),
        "/splash_screen": (context) => const SplashScreen()
      },
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              _navigator.pushReplacementNamed("/home_screen");
            } else if (state.status == AuthStatus.unknown) {
              _navigator.pushReplacementNamed("/loading_screen");
            } else {
              _navigator.pushReplacementNamed("/failure_screen");
            }
          },
          child: child,
        );
      },
      initialRoute: "/splash_screen",
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(child: Center(child: CircularProgressIndicator()));
  }
}
