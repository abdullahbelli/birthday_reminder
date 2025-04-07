import 'package:dogum_gunu_uygulamasi/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için
import 'HomePage.dart';
import 'Drawer.dart';

// Doğum günü ekleme sayfası - kullanıcı adı parametre olarak alınır
class DogumGunuEkle extends StatefulWidget {
  final String username;
  DogumGunuEkle({super.key, required this.username});

  @override
  State<DogumGunuEkle> createState() => _DogumgunuekleState();
}

class _DogumgunuekleState extends State<DogumGunuEkle> {
  DateTime secilenTarih = DateTime.now(); // Varsayılan tarih bugünün tarihi
  final TextEditingController nameController =
      TextEditingController(); // İsim için controller

  // Tarih seçme fonksiyonu
  tarihSec() async {
    var secilen = await showDatePicker(
      context: context,
      initialDate: secilenTarih,
      firstDate: DateTime(1923), // En erken seçilebilir tarih
      lastDate: DateTime(2030), // En geç seçilebilir tarih
    );

    if (secilen != null) {
      setState(() {
        secilenTarih = secilen; // Seçilen tarih state'e atanır
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Seçilen tarih Türkçe formatlanır
    var formatlanmisTarih = DateFormat('dd/MM/yyyy', 'tr').format(secilenTarih);

    // Route üzerinden gelen argümanları alır
    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, String> userArgs =
        args != null && args is Map<String, String>
            ? args
            : {'username': 'Misafir'};

    // Gelen username değeri alınır, yoksa 'Misafir' atanır
    final String username = userArgs['username'] ?? 'Misafir';

    return Scaffold(
      extendBodyBehindAppBar: true, // Arka plan AppBar'ın arkasına uzar
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: const Text('Doğum Günü Ekle'),
      ),
      drawer: AppDrawer(
        username: username,
      ), // Drawer'a kullanıcı adı gönderilir
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"), // Arka plan görseli
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              // İçerik kaydırılabilir
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
                    // İsim soyisim giriş alanı
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'İsim - Soyisim',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Seçilen tarihi gösteren metin
                    Text(formatlanmisTarih),

                    // Tarih seç butonu
                    ElevatedButton(
                      onPressed: tarihSec,
                      child: const Text('Tarih Seç'),
                    ),
                    const SizedBox(height: 10),

                    // Kaydet butonu
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        if (nameController.text.isNotEmpty) {
                          // Yeni doğum günü ekleme
                          HomePage.dogumGunleri.add(
                            kisi(
                              isim: nameController.text,
                              dogumgunu: formatlanmisTarih,
                            ),
                          );

                          // Kayıt başarılı ise uyarı gösterilir
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Kayıt Başarılı'),
                                  content: Text(
                                    '${nameController.text} başarıyla kaydedildi.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Uyarı kapanır
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.home, // Ana sayfaya gider
                                          arguments: {
                                            'username': widget.username,
                                          },
                                        );
                                      },
                                      child: const Text('Tamam'),
                                    ),
                                  ],
                                ),
                          );
                        }
                      },
                      child: const Text(
                        'Kaydet',
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
