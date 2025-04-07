import 'dart:convert'; // JSON verisini ayrıştırmak için gerekli paket
import 'package:dogum_gunu_uygulamasi/routes/app_routes.dart'; // Sayfalar arası geçiş için route dosyası
import 'package:flutter/material.dart'; // Flutter'ın temel widget'ları
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Güvenli veri saklama

// Login sayfası için StatefulWidget tanımı
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Kullanıcı adı ve şifre için controller'lar
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Güvenli verileri saklamak için secure storage örneği
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Şifreyi güvenli şekilde saklayan fonksiyon
  Future<void> savePassword(String password) async {
    await secureStorage.write(key: 'password', value: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka plan resminin AppBar'ın arkasına uzar
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: const Text('Login Page'),
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"), // Arka plan resmi
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              // Ekran kaydırılabilir olur
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Kullanıcı adı girişi
                    TextField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        labelText: 'Kullanıcı Adı',
                      ),
                    ),
                    // Şifre girişi
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Şifre'),
                      obscureText: true, //gizli karakter
                    ),
                    const SizedBox(height: 20),

                    // Giriş yap butonu
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () async {
                        // TextField'lardan alınan veriler
                        final username = userNameController.text.trim();
                        final password = passwordController.text;

                        // JSON formatında kullanıcı verisi
                        const jsonString = '''
                        {
                          "users": [
                            {
                              "id": 1,
                              "isim": "user",
                              "sifre": "12345"
                            }
                          ]
                        }
                        ''';

                        // JSON verisini decode ederek kullanıcı listesi elde edilir
                        final data = jsonDecode(jsonString);
                        final users = data['users'] as List;

                        // Kullanıcı adı ve şifre eşleşmesi kontrol edilir
                        final matchedUser = users.firstWhere(
                          (user) =>
                              user['isim'] == username &&
                              user['sifre'] == password,
                          orElse: () => null, // Eşleşme yoksa null döner
                        );

                        if (matchedUser != null) {
                          // Şifre güvenli şekilde saklanır
                          await savePassword(password);

                          // Ana sayfaya geçiş ve kullanıcı adı gönderimi
                          Navigator.pushNamed(
                            context,
                            AppRoutes.home,
                            arguments: {'username': username},
                          );
                        } else {
                          // Hatalı giriş durumunda uyarı penceresi
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Hatalı Giriş'),
                                  content: const Text(
                                    'Kullanıcı adı veya şifre yanlış.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Tamam'),
                                    ),
                                  ],
                                ),
                          );
                        }
                      },
                      child: const Text(
                        'Giriş Yap',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
