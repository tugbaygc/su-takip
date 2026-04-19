import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart'; // Konfeti paketini ekledik
import '../widgets/thermos_widget.dart';
import '../widgets/add_water_button.dart';
import '../../providers/water_provider.dart';

// HomeScreen'i StatefulWidget'a çevirdik
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. Konfeti Kontrolcüsünü Tanımla
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // 2. Kontrolcüyü 3 saniye sürecek şekilde başlat
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    // 3. Kontrolcüyü dispose etmeyi UNUTMA (hafıza sızıntısını önler)
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ABONELİK İŞLEMİ: Provider'daki güncel verileri dinliyoruz
    final waterProvider = Provider.of<WaterProvider>(context);

    // 4. KONFETİ PATLATMA EMRİNİ DİNLE 👇
    if (waterProvider.shouldCelebrate) {
      _confettiController.play();
      // Kontrolcüye play dedikten HEMEN SONRA Provider'a 'tamam, kutlama bitti' de
      // Future.delayed kullanıyoruz ki build metodu tamamlansın, çakışma olmasın
      Future.delayed(Duration.zero, () {
        waterProvider.celebrationDone();
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Su Takibi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.cyan.shade800,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.cyan.shade800),
            onSelected: (value) {
              if (value == 'hedef') {
                _showGoalDialog(context, waterProvider);
              } else if (value == 'sifirla') {
                waterProvider.resetWater();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'hedef',
                  child: Row(
                    children: [
                      Icon(Icons.flag, color: Colors.cyan.shade700, size: 20),
                      const SizedBox(width: 10),
                      const Text('Hedef Belirle'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'sifirla',
                  child: Row(
                    children: [
                      Icon(Icons.refresh, color: Colors.red.shade400, size: 20),
                      const SizedBox(width: 10),
                      Text('Suyu Sıfırla', style: TextStyle(color: Colors.red.shade400)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
        backgroundColor: Colors.cyan.shade50,
        elevation: 0,
        centerTitle: true,
      ),
      // 5. BODY'Yİ STACK İLE SARMALADIK (Konfetiler her şeyin üstüne çıksın diye)
      body: Stack(
        children: [
          // Sayfanın asıl içeriği
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // MOTİVASYON KUTUSU
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.cyan.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                            Icons.water_drop,
                            color: Colors.cyan.shade700,
                            size: 20
                        ),
                        const SizedBox(width: 8),
                        Text(
                          waterProvider.motivationalMessage,
                          style: GoogleFonts.poppins(
                            color: Colors.cyan.shade900,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // TERMOS
                  ThermosWidget(
                    currentWater: waterProvider.currentWater,
                    dailyGoal: waterProvider.dailyGoal,
                  ),

                  const SizedBox(height: 50),

                  // BUTONLAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AddWaterButton(
                        amount: 200,
                        icon: Icons.local_drink,
                        label: 'Bardak',
                        onTap: () {
                          waterProvider.addWater(200);
                        },
                      ),
                      AddWaterButton(
                        amount: 500,
                        icon: Icons.water_drop,
                        label: 'Yarım Litre',
                        onTap: () {
                          waterProvider.addWater(500);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // GERİ AL BUTONU
                  TextButton.icon(
                    onPressed: () {
                      waterProvider.undo();
                    },
                    icon: const Icon(Icons.undo),
                    label: Text(
                      'Geri Al',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // 6. KONFETİ WIDGET'I (En üstte durur)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.cyan,
                Colors.blue,
                Colors.yellow,
                Colors.green,
                Colors.pink,
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showGoalDialog(BuildContext context, WaterProvider provider) {
    final controller = TextEditingController(text: provider.dailyGoal.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Günlük Hedef Belirle (ml)'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Örn: 3000"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              int? newGoal = int.tryParse(controller.text);
              if (newGoal != null) {
                provider.updateDailyGoal(newGoal);
              }
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}