import 'package:dogum_gunu_uygulamasi/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'Drawer.dart';

// Ana sayfa - doğum günü listesi burada gösterilir
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // Doğum günü listesi, tüm uygulamada statik olarak tutulur
  static List<kisi> dogumGunleri = [];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String username;

  // Sayfa yüklendiğinde gelen argümanlardan kullanıcı adı alınır
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    username =
        args?['username'] ?? 'Misafir'; // Eğer username yoksa "Misafir" atanır
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Arka plan AppBar'ın arkasına geçer
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: const Text('Doğum Günü Listesi'),
      ),
      drawer: AppDrawer(
        username: username,
      ), // Drawer'a kullanıcı adı gönderilir
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/background.jpg",
            ), // assetsden arka plan resmi alır
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child:
              // Eğer doğum günü listesi boşsa uyarı kutusu
              HomePage.dogumGunleri.isEmpty
                  ? Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Görüntülenecek Bir Doğum Günü Yok.',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
                            onPressed: () {
                              // Yeni doğum günü ekleme sayfasına gider
                              Navigator.pushNamed(
                                context,
                                AppRoutes.ekle,
                                arguments: {'username': username},
                              );
                            },
                            child: const Text(
                              'Doğum Günü Ekle',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  // Doğum günlerini göster
                  : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: HomePage.dogumGunleri.length,
                    itemBuilder: (context, index) {
                      final kisiItem = HomePage.dogumGunleri[index];

                      return Card(
                        color: Colors.white.withOpacity(0.85),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(kisiItem.isim), // Kişi adı
                          subtitle: Text(
                            kisiItem.dogumgunu,
                          ), // Doğum günü tarihi
                          trailing: IconButton(
                            icon: const Icon(Icons.remove, color: Colors.red),
                            onPressed: () {
                              // Kişiyi listeden sil
                              setState(() {
                                HomePage.dogumGunleri.removeAt(index);
                              });

                              // Silme işlemi başarılıis uyarı gösterir
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text(
                                        'Silme İşlemi Başarılı',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                              context,
                                            ); // Uyarıyı kapat
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.home,
                                              arguments: {'username': username},
                                            ); // Sayfayı yeniden yükle
                                          },
                                          child: const Text('Tamam'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}

// Kişi sınıfı her bir kişi için isim ve doğum günü bilgisi tutar
class kisi {
  final String isim;
  final String dogumgunu;

  kisi({required this.isim, required this.dogumgunu});
}
