import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider paketini ekledik
import 'presentation/screens/home_screen.dart';
import 'providers/water_provider.dart'; // Yazdığımız beyni içeri aldık

void main() {
  runApp(
    // Bütün uygulamayı MultiProvider ile sarmalıyoruz ki her ekrandan erişilebilsin
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WaterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Su Takibi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}