import 'package:get_storage/get_storage.dart';

class SessionManager {
  SessionManager._();

  static final GetStorage _box = GetStorage();

  // ==========================================================
  // AUTH
  // ==========================================================

  static String? get token =>
      _box.read<String>('token');

  static bool get isLoggedIn =>
      _box.read<bool>('is_logged_in') ?? false;

  // ==========================================================
  // USER
  // ==========================================================

  static String get userId =>
      _box.read<String>('user_id') ?? '';

  static String get username =>
      _box.read<String>('username') ?? '';

  static String get fullname =>
      _box.read<String>('fullname') ?? '';

  static String get email =>
      _box.read<String>('email') ?? '';

  static String get role =>
      _box.read<String>('role') ?? 'user';

  static String get province =>
      _box.read<String>('province') ?? '';

  static int get points =>
      _box.read<int>('points') ?? 0;

  static String get image =>
      _box.read<String>('image') ?? '';

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
    await _box.write(
      'is_logged_in',
      true,
    );

    await _box.write(
      'token',
      token,
    );

    await _box.write(
      'user_id',
      userId,
    );

    await _box.write(
      'username',
      username,
    );

    await _box.write(
      'fullname',
      fullname,
    );

    await _box.write(
      'email',
      email,
    );

    await _box.write(
      'role',
      role,
    );

    await _box.write(
      'province',
      province,
    );

    await _box.write(
      'points',
      points,
    );

    await _box.write(
      'image',
      image,
    );
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
    if (username != null) {
      await _box.write(
        'username',
        username,
      );
    }

    if (fullname != null) {
      await _box.write(
        'fullname',
        fullname,
      );
    }

    if (email != null) {
      await _box.write(
        'email',
        email,
      );
    }

    if (province != null) {
      await _box.write(
        'province',
        province,
      );
    }

    if (image != null) {
      await _box.write(
        'image',
        image,
      );
    }
  }

  // ==========================================================
  // UPDATE POINTS
  // ==========================================================

  static Future<void> updatePoints(
    int newPoints,
  ) async {
    await _box.write(
      'points',
      newPoints,
    );
  }

  static Future<void> addPoints(
    int point,
  ) async {
    final currentPoints = points;

    await _box.write(
      'points',
      currentPoints + point,
    );
  }

  // ==========================================================
  // UPDATE TOKEN
  // ==========================================================

  static Future<void> updateToken(
    String newToken,
  ) async {
    await _box.write(
      'token',
      newToken,
    );
  }

  // ==========================================================
  // HELPERS
  // ==========================================================

  static bool hasToken() {
    return token != null &&
        token!.isNotEmpty;
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