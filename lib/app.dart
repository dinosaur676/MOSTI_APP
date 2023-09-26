//import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/config/config.dart';
import 'package:travel_hour/pages/splash.dart';
import 'package:easy_localization/easy_localization.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        //navigatorObservers: [firebaseObserver],
        theme: ThemeData(
            useMaterial3: false,
            primarySwatch: Colors.blue,
            primaryColor: Config.appThemeColor,
            iconTheme: IconThemeData(color: Colors.grey[900]),
            fontFamily: 'Manrope',
            scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: AppBarTheme(
              color: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.grey[800],
              ),
              titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Manrope',
                  color: Colors.grey[900]
                )
            ),),
        home: SplashPage());
  }
}