import 'package:get_storage/get_storage.dart';

class SessionManager {
  SessionManager._();

  static final GetStorage _box = GetStorage();

  // ==========================================================
  // AUTH & SKU DATA
  // ==========================================================

  static String? get token => _box.read<String>('token');

  static bool get isLoggedIn => _box.read<bool>('is_logged_in') ?? false;

  // SKU LEVEL (Menyimpan ID level SKU yang sedang dikerjakan user)
  static String get currentSkuLevelId =>
      _box.read('current_sku_level_id')?.toString() ?? '';

  // ==========================================================
  // USER DATA
  // ==========================================================

  static String get userId => _box.read('user_id')?.toString() ?? '';

  static String get username => _box.read('username')?.toString() ?? '';

  static String get fullname => _box.read('fullname')?.toString() ?? '';

  static String get email => _box.read('email')?.toString() ?? '';

  static String get role => _box.read('role')?.toString() ?? 'user';

  static String get province => _box.read('province')?.toString() ?? '';

  static String get image => _box.read('image')?.toString() ?? '';

  static String get gudep => _box.read('gudep')?.toString() ?? '';

  // Getter points yang aman untuk tipe data int maupun String
  static int get points {
    final val = _box.read('points');
    if (val == null) return 0;
    if (val is int) return val;
    return int.tryParse(val.toString()) ?? 0;
  }

  // Helper untuk cek apakah user adalah Admin
  static bool get isAdmin => role.toLowerCase() == 'admin';

  // ==========================================================
  // SAVE SESSION (Saat Login / Register)
  // ==========================================================

  static Future<void> saveSession({
    required String token,
    required String userId,
    required String username,
    required String fullname,
    required String email,
    required String role,
    String province = '',
    String gudep = '',
    int points = 0,
    String image = '',
    String currentSkuLevelId = '', // Disiapkan untuk progres data SKU
  }) async {
    await _box.write('is_logged_in', true);
    await _box.write('token', token);
    await _box.write('user_id', userId);
    await _box.write('username', username);
    await _box.write('fullname', fullname);
    await _box.write('email', email);
    await _box.write('role', role);
    await _box.write('province', province);
    await _box.write('gudep', gudep);
    await _box.write('points', points);
    await _box.write('image', image);
    await _box.write('current_sku_level_id', currentSkuLevelId);
  }

  // ==========================================================
  // UPDATE DATA (Saat User Edit Profil / Lulus Pelantikan SKU)
  // ==========================================================

  static Future<void> updateProfile({
    String? username,
    String? fullname,
    String? email,
    String? province,
    String? gudep,
    String? image,
    String? currentSkuLevelId, // Tambahan untuk update level SKU
  }) async {
    if (username != null) await _box.write('username', username);
    if (fullname != null) await _box.write('fullname', fullname);
    if (email != null) await _box.write('email', email);
    if (province != null) await _box.write('province', province);
    if (gudep != null) await _box.write('gudep', gudep);
    if (image != null) await _box.write('image', image);
    if (currentSkuLevelId != null)
      await _box.write('current_sku_level_id', currentSkuLevelId);
  }

  static Future<void> updatePoints(int newPoints) async {
    await _box.write('points', newPoints);
  }

  static Future<void> addPoints(int point) async {
    final currentPoints = points;
    await _box.write('points', currentPoints + point);
  }

  static Future<void> updateToken(String newToken) async {
    await _box.write('token', newToken);
  }

  // ==========================================================
  // HELPERS (Fungsi Bantuan)
  // ==========================================================

  static bool hasToken() {
    return token != null && token!.isNotEmpty;
  }

  static String getToken() {
    return token ?? '';
  }

  // Helper untuk Header API (Cegah 401 Unauthorized secara otomatis)
  // Cara pakai: http.get(url, headers: SessionManager.apiHeader)
  static Map<String, String> get apiHeader {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${getToken()}',
    };
  }

  static Map<String, dynamic> get userData {
    return {
      'id': userId,
      'username': username,
      'fullname': fullname,
      'email': email,
      'role': role,
      'province': province,
      'gudep': gudep,
      'points': points,
      'image': image,
      'current_sku_level_id': currentSkuLevelId,
    };
  }

  // ==========================================================
  // LOGOUT (Pembersihan Selektif)
  // ==========================================================

  static Future<void> clear() async {
    // Hapus spesifik kunci milik user agar data settingan lokal
    // seperti 'is_intro_seen' atau 'theme_mode' tidak ikut terhapus.
    final keysToRemove = [
      'is_logged_in',
      'token',
      'user_id',
      'username',
      'fullname',
      'email',
      'role',
      'province',
      'gudep',
      'points',
      'image',
      'current_sku_level_id',
    ];

    for (var key in keysToRemove) {
      await _box.remove(key);
    }
  }
}
