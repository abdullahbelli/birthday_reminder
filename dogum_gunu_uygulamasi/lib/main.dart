import 'package:flutter/material.dart';
import 'package:dogum_gunu_uygulamasi/routes/app_routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale(
        'tr',
        'TR',
      ), // Uygulama dilini Türkçe olarak ayarladık.
      // Lokalizasyon desteği için gerekli delegeleri eklendi.
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ], // Desteklenen dilleri Türkçe ve İngilizce yaptık.

      debugShowCheckedModeBanner: false, // Debug banner gizlendi.
      // Uygulamanın başlığı teması belirlendi.
      title: 'Doğum Günü Hatırlatıcı',

      theme: ThemeData(primarySwatch: Colors.deepPurple),

      // İlk açılışta kullanılacak olan rota.
      initialRoute: AppRoutes.login,

      // Uygulama rotaları AppRoutes tan yönlendiriliyor.
      routes: AppRoutes.routes,
    );
  }
}
