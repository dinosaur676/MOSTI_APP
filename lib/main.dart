import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:travel_hour/pages/image_loading_page.dart';
import 'package:travel_hour/pages/sign_in.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'get_it_set.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark
  ));

  FlutterTrustWalletCore.init();

  await getItSetter();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('es'), Locale('ar'), Locale('ko')],
      path: 'assets/translations',
      fallbackLocale: Locale('ko'),
      startLocale: Locale('ko'),
      useOnlyLangCode: true,
      child: const MyApp(),
    )
  );
}

