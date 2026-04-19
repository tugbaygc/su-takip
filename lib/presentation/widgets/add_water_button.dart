import 'package:flutter/material.dart';

class AddWaterButton extends StatelessWidget {
  final int amount;         // Eklenecek su miktarı (Örn: 200)
  final IconData icon;      // Ortada duracak ikon
  final String label;       // İkonun altındaki yazı (Örn: Küçük Bardak)
  final VoidCallback onTap; // Butona tıklandığında ne olacağı

  const AddWaterButton({
    super.key,
    required this.amount,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Tıklanma olayını buraya bağlıyoruz
      child: Column(
        children: [
          // Yuvarlak Buton Tasarımı
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyan.shade200, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child:
            Icon(
              icon,
              size: 40,
              color: Colors.cyan.shade700,
            ),
          ),
          const SizedBox(height: 12),

          // Butonun Altındaki Başlık
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          // Miktar Yazısı (Örn: 200ml)
          Text(
            '${amount}ml',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}