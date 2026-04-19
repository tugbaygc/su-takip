import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThermosWidget extends StatelessWidget {
  final int currentWater;
  final int dailyGoal;

  const ThermosWidget({
    super.key,
    required this.currentWater,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    // Suyun doluluk oranını hesapla (0.0 ile 1.0 arasında tutuyoruz)
    double fillPercentage = currentWater / dailyGoal;
    if (fillPercentage > 1.0) fillPercentage = 1.0;
    if (fillPercentage < 0.0) fillPercentage = 0.0;

    // Termosun ekrandaki boyutu
    const double thermosHeight = 300.0;
    const double thermosWidth = 130.0;

    // Yazı ve ikonların rengi (Su seviyesine göre beyaz veya koyu gri olacak)
    // Su %40'ı geçtiğinde yazıları beyaz yaparak okunabilirliği koruyoruz
    Color contentColor = fillPercentage > 0.4 ? Colors.white : Colors.black38;

    return Column(
      children: [
        // 1. İLERLEME METNİ (Görseldeki gibi termosun üstüne aldık)
        Text(
          '${(currentWater / 1000).toStringAsFixed(1)}L / ${(dailyGoal / 1000).toStringAsFixed(1)}L',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 25),

        // 2. GRİ KAPAK
        Container(
          height: 20,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),

        // 3. TERMOSUN KENDİSİ
        Container(
          height: thermosHeight,
          width: thermosWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300, width: 5),
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 15,
                spreadRadius: 5,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(color: Colors.transparent),
                // Su Animasyonu Kutusu
                AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  height: thermosHeight * fillPercentage,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.cyan.shade300,
                        Colors.cyan.shade600,
                      ],
                    ),
                  ),
                ),
                // TERMOSUN İÇİNDEKİ GRUP (İkon + Yazı + Yüzde)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Sadece içindekiler kadar yer kaplar
                    children: [
                      Icon(
                        Icons.water_drop,
                        color: contentColor,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Su Takibi',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: contentColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '%${(fillPercentage * 100).toInt()}',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: contentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40), // Alt kısımla olan mesafeyi korumak için
      ],
    );
  }
}