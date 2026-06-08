import 'package:get_storage/get_storage.dart';

class SessionManager {
  SessionManager._();

  static final GetStorage _box = GetStorage();

  // ==========================================================
  // AUTH
  // ==========================================================

  static String? get token => _box.read<String>('token');

  static bool get isLoggedIn => _box.read<bool>('is_logged_in') ?? false;

  // ==========================================================
  // USER
  // ==========================================================

  static String get userId => _box.read('user_id')?.toString() ?? '';

  static String get username => _box.read('username')?.toString() ?? '';

  static String get fullname => _box.read('fullname')?.toString() ?? '';

  static String get email => _box.read('email')?.toString() ?? '';

  static String get role => _box.read('role')?.toString() ?? 'user';

  static String get province => _box.read('province')?.toString() ?? '';

  static String get image => _box.read('image')?.toString() ?? '';

  // PERBAIKAN: Getter points yang aman untuk tipe data int maupun String
  static int get points {
    final val = _box.read('points');
    if (val == null) return 0;
    if (val is int) return val;
    // Jika tersimpan sebagai String, parsing secara aman
    return int.tryParse(val.toString()) ?? 0;
  }

  // ==========================================================
  // SAVE SESSION
  // ==========================================================

  static Future<void> saveSession({
    required String token,
    required String userId,
    required String username,
    required String fullname,
    required String email,
    required String role,
    String province = '',
    int points = 0,
    String image = '',
  }) async {
    await _box.write('is_logged_in', true);
    await _box.write('token', token);
    await _box.write('user_id', userId);
    await _box.write('username', username);
    await _box.write('fullname', fullname);
    await _box.write('email', email);
    await _box.write('role', role);
    await _box.write('province', province);
    await _box.write('points', points);
    await _box.write('image', image);
  }

  // ==========================================================
  // UPDATE PROFILE
  // ==========================================================

  static Future<void> updateProfile({
    String? username,
    String? fullname,
    String? email,
    String? province,
    String? image,
  }) async {
    if (username != null) await _box.write('username', username);
    if (fullname != null) await _box.write('fullname', fullname);
    if (email != null) await _box.write('email', email);
    if (province != null) await _box.write('province', province);
    if (image != null) await _box.write('image', image);
  }

  // ==========================================================
  // UPDATE POINTS
  // ==========================================================

  static Future<void> updatePoints(int newPoints) async {
    await _box.write('points', newPoints);
  }

  static Future<void> addPoints(int point) async {
    final currentPoints = points;
    await _box.write('points', currentPoints + point);
  }

  // ==========================================================
  // UPDATE TOKEN
  // ==========================================================

  static Future<void> updateToken(String newToken) async {
    await _box.write('token', newToken);
  }

  // ==========================================================
  // HELPERS
  // ==========================================================

  static bool hasToken() {
    return token != null && token!.isNotEmpty;
  }

  static String getToken() {
    return token ?? '';
  }

  static Map<String, dynamic> get userData {
    return {
      'id': userId,
      'username': username,
      'fullname': fullname,
      'email': email,
      'role': role,
      'province': province,
      'points': points,
      'image': image,
    };
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================

  static Future<void> clear() async {
    await _box.erase();
  }
}