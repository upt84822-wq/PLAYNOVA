import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey('coins')) await _prefs.setInt('coins', 10000);
  }

  static int get coins => _prefs.getInt('coins') ?? 10000;
  static String get username => _prefs.getString('username') ?? 'Player';
  static int get gamesPlayed => _prefs.getInt('gamesPlayed') ?? 0;
  static int get wins => _prefs.getInt('wins') ?? 0;
  static bool get sound => _prefs.getBool('sound') ?? true;

  static Future<void> setUsername(String value) => _prefs.setString('username', value);

  static Future<void> addCoins(int amount) async {
    await _prefs.setInt('coins', coins + amount);
  }

  static Future<void> recordGame({required int score, required bool win}) async {
    await _prefs.setInt('gamesPlayed', gamesPlayed + 1);
    if (win) await _prefs.setInt('wins', wins + 1);
    final best = _prefs.getInt('bestScore') ?? 0;
    if (score > best) await _prefs.setInt('bestScore', score);
    await addCoins(win ? 100 : 25);
  }

  static int get bestScore => _prefs.getInt('bestScore') ?? 0;

  static Future<void> setSound(bool value) => _prefs.setBool('sound', value);

  static String _dayKey() => DateTime.now().toIso8601String().substring(0, 10);

  static bool get dailyClaimed => _prefs.getString('dailyClaim') == _dayKey();

  static Future<bool> claimDaily() async {
    if (dailyClaimed) return false;
    await _prefs.setString('dailyClaim', _dayKey());
    await addCoins(500);
    return true;
  }
}
