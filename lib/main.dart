import 'package:budgify/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/paths.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Hive Database
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  await _loadFonts();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Color.fromRGBO(37, 146, 166, 1),
  ));

  runApp(
    ProviderScope(child: const MyApp()),
  );
}

Future<void> _loadFonts() async {
  // Load Poppins font
  final fontLoaderPoppins = FontLoader('Poppins')
    ..addFont(rootBundle.load('assets/fonts/Poppins-Regular.ttf'));

  // Load Montserrat font
  final fontLoaderMontserrat = FontLoader('Montserrat')
    ..addFont(rootBundle.load('assets/fonts/Montserrat-Regular.ttf'));

  // Load both fonts
  await Future.wait([
    fontLoaderPoppins.load(),
    fontLoaderMontserrat.load(),
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(
      context,
      "Noto Music",
      "Noto Sans Display",
    );
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: Constants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: Paths.initial,
    );
  }
}
