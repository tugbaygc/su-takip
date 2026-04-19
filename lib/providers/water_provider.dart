import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importu unutma!

class WaterProvider with ChangeNotifier {
  int _currentWater = 0;
  int _dailyGoal = 2500;
  final List<int> _history = [];
  bool _goalReached = false;
  bool _shouldCelebrate = false;

  // Constructor: Uygulama ilk açıldığında hafızadaki verileri çek
  WaterProvider() {
    _loadFromPrefs();
  }

  // GETTER'LAR
  int get currentWater => _currentWater;
  int get dailyGoal => _dailyGoal;
  bool get shouldCelebrate => _shouldCelebrate;

  String get motivationalMessage {
    if (_currentWater == 0) return "Merhaba, güne su içerek başla!";
    double percentage = _currentWater / _dailyGoal;
    if (percentage < 0.3) return "Harika başlangıç! Hadi biraz daha...";
    if (percentage < 0.6) return "İyi gidiyorsun, yarıladık sayılır!";
    if (percentage < 0.9) return "Çok az kaldı! Vücudun sana minnettar.";
    if (percentage < 1.0) return "Son yudumlar... Hedefe ulaşıyorsun!";
    return "Tebrikler! Günlük hedefini tamamladın 🎉";
  }

  // --- HAFIZA İŞLEMLERİ ---

  // 1. Verileri Kaydet (Her su eklendiğinde çağırılacak)
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentWater', _currentWater);
    await prefs.setInt('dailyGoal', _dailyGoal);
    // Not: Liste (history) kaydetmek için JSON dönüştürme gerekir,
    // şimdilik ana değerlere odaklanalım.
  }

  // 2. Verileri Yükle (Uygulama açılışında çalışır)
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _currentWater = prefs.getInt('currentWater') ?? 0;
    _dailyGoal = prefs.getInt('dailyGoal') ?? 2500;

    // Eğer zaten hedefe ulaşılmışsa tekrar konfeti patlamasın diye kontrol
    if (_currentWater >= _dailyGoal) {
      _goalReached = true;
    }
    notifyListeners();
  }

  // --- AKSİYONLAR (Her birinde _saveToPrefs() ekledik) ---

  void addWater(int amount) {
    _currentWater += amount;
    _history.add(amount);

    if (_currentWater >= _dailyGoal && !_goalReached) {
      _goalReached = true;
      _shouldCelebrate = true;
    }

    _saveToPrefs(); // Veriyi kaydet
    notifyListeners();
  }

  void undo() {
    if (_history.isNotEmpty) {
      int lastAmount = _history.removeLast();
      _currentWater -= lastAmount;
      if (_currentWater < 0) _currentWater = 0;

      // Hedefin altına düşerse bayrağı sıfırla
      if (_currentWater < _dailyGoal) _goalReached = false;

      _saveToPrefs(); // Veriyi kaydet
      notifyListeners();
    }
  }

  void updateDailyGoal(int newGoal) {
    if (newGoal > 0) {
      _dailyGoal = newGoal;
      _saveToPrefs(); // Veriyi kaydet
      notifyListeners();
    }
  }

  void resetWater() {
    _currentWater = 0;
    _history.clear();
    _goalReached = false;
    _shouldCelebrate = false;
    _saveToPrefs(); // Veriyi kaydet
    notifyListeners();
  }

  void celebrationDone() {
    _shouldCelebrate = false;
    notifyListeners();
  }
}