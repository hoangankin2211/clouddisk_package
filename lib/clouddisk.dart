import 'package:clouddisk/constant/root_path.dart';
import 'package:clouddisk/features/authentication/bloc/auth_bloc.dart';
import 'package:clouddisk/features/authentication/bloc/auth_event.dart';
import 'package:clouddisk/features/authentication/bloc/auth_state.dart';
import 'package:clouddisk/features/home/view/home_screen.dart';
import 'package:clouddisk/features/locale/bloc/locale_bloc.dart';
import 'package:clouddisk/features/theme/bloc.dart/theme_bloc.dart';
import 'package:clouddisk/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/theme/dark_theme.dart';
import 'features/theme/light_theme.dart';
import 'localization/app_localization.dart';

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
  late final String? hmail_key;
  late final String? session;
  late final String? languageCode;
  late final ThemeMode? themeMode;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    print("ModalRoute: ${(ModalRoute.of(context)?.settings.arguments as Map)}");
    hmail_key =
        (ModalRoute.of(context)?.settings.arguments as Map)["hmail_key"];
    session = (ModalRoute.of(context)?.settings.arguments as Map)["session"];
    languageCode =
        (ModalRoute.of(context)?.settings.arguments as Map)["languageCode"];
    themeMode =
        (ModalRoute.of(context)?.settings.arguments as Map)["themeMode"];
    RootPath.setRoot(
      hmail_key: hmail_key,
      languageCode: languageCode,
      root: widget.root,
      session: session,
      themeMode: themeMode,
    );
    SharedPreferencesUtils.initSharedPreferencesInstance();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthBloc(hmail_key: hmail_key, session: session)),
        BlocProvider(
            create: (context) =>
                ThemeBloc(mode: themeMode ?? ThemeMode.system)),
        BlocProvider(
            create: (_) => LocaleBloc(languageCode: languageCode ?? "ko")),
      ],
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
      () => context.read<AuthBloc>().add(CheckingAuthenticationCondition()),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, localeState) => BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) => MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          title: 'CloudDisk',
          themeMode: themeState.mode,
          theme: MyCustomLightTheme.lightTheme,
          darkTheme: MyCustomDarkTheme.darkTheme,
          locale: localeState.locale,
          localizationsDelegates: const [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale("vi", "VN"),
            Locale("en", "EN"),
            Locale("ko", "KO"),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          routes: {
            "/home_screen": (context) => const HomeScreen(),
            "/loaing_screen": (context) => const Material(
                child: Center(child: CircularProgressIndicator())),
            "/failure_screen": (context) =>
                FailureScreen(rootRouteName: RootPath.root ?? "/"),
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
        ),
      ),
    );
  }
}

class FailureScreen extends StatelessWidget {
  const FailureScreen({
    super.key,
    required this.rootRouteName,
  });
  final String rootRouteName;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Unauthenticated !!! Don't have data about use \nPlease login to groupware first",
                style: TextStyle(fontSize: 30, color: Colors.red),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => Navigator.of(context)
                    .popUntil((route) => route.settings.name == rootRouteName),
                icon: const Icon(Icons.exit_to_app),
                label: const Text(
                  "Exit to Hanbiro",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
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

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark;
  }

  bool get isLargeScreen {
    return MediaQuery.of(this).size.shortestSide >= 600 ? true : false;
  }
}
