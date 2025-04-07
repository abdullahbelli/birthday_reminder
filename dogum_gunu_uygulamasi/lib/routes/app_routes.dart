import 'package:dogum_gunu_uygulamasi/pages/DogumGunuEkle.dart';
import 'package:dogum_gunu_uygulamasi/pages/HomePage.dart';
import 'package:dogum_gunu_uygulamasi/pages/LoginPage.dart';
import 'package:flutter/widgets.dart';

class AppRoutes {
  // Rota isimleri
  static const String login = '/';
  static const String home = '/home';
  static const String ekle = '/add';

  // Rotaları bir Map olarak döndürüyoruz
  static Map<String, Widget Function(BuildContext)> get routes => {
    login: (context) => const LoginPage(), // Giriş sayfasına yönlendirme
    home: (context) => HomePage(), // Ana sayfaya yönlendirme
    ekle: (context) {
      // Rota argümanlarını alıyoruz
      final args = ModalRoute.of(context)?.settings.arguments as Map?;

      final String username = args?['username'] ?? 'Misafir';

      // Kullanıcı adıyla birlikte DoğumGünüEkle sayfasına yönlendiriyoruz
      return DogumGunuEkle(username: username);
    },
  };
}
