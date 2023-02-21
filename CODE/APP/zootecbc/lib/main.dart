import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:zootecbc/constants/colors.dart';
import 'package:zootecbc/pages/splash.dart';
import 'package:zootecbc/providers/app.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AppProvider appChangeProvider = new AppProvider();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light));

    return ChangeNotifierProvider.value(
        value: appChangeProvider,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ZootecBC',
          theme: ThemeData(
              appBarTheme: Theme.of(context)
                  .appBarTheme
                  .copyWith(brightness: Brightness.dark),
              textTheme: TextTheme(),
              brightness: Brightness.light,
              primaryColor: CustomColors.primary,
              primarySwatch: CustomColors.primary),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'), // English
            const Locale('es'), // Spanish
            const Locale('fr'), // French
            const Locale('zh'), // Chinese
          ],
          home: Splash(),
        ));
  }
}
