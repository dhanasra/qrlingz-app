// ignore_for_file: avoid_print

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrlingz_app/constants/admob_const.dart';
import 'package:qrlingz_app/constants/app_const.dart';
import 'package:qrlingz_app/network/local_db.dart';
import 'package:qrlingz_app/utils/notifications.dart';

import 'app/app.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: const FirebaseOptions( 
      apiKey: "AIzaSyAJMazs8SsnxvS8xgJIaHOqDVj2of7h88c", 
      appId: "1:1054371633362:android:ecb77d7a1920f3731bb50b", 
      messagingSenderId: "1054371633362", 
      projectId: "qrlingz",
      storageBucket: "qrlingz.appspot.com"
    )
  );

  await AppNotification().init();

  try{

    await FirebaseMessaging.instance.getToken();

    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    remoteConfig.getString('data');
  }catch(error){
    print(error);
  }

  await LocalDB.init();
  var currentLocale =  await LocalDB().getLangcode();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  loadAds();

  runApp(EasyLocalization(
    supportedLocales: AppConst.locales,
    path: 'res/translations',
    fallbackLocale: currentLocale,
    child: const App()));
}

AppOpenAd? _appOpenAd;

loadAds(){
  AppOpenAd.load(
    adUnitId: AdmobConst.appOpenAd1, 
    request: const AdRequest(), 
    adLoadCallback: AppOpenAdLoadCallback(
      onAdLoaded: (ad){
        _appOpenAd = ad;
        _appOpenAd?.show();
      }, 
      onAdFailedToLoad: (error){
        print(error);
      },
    )
  );
}