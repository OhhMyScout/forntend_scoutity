import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

class KompasController extends GetxController {
  // ── Reactive State ──────────────────────────────────────
  final heading       = 0.0.obs;
  final isLocked      = false.obs;
  final isCalibrating = false.obs;
  final accuracyLevel = 0.obs;          // 0=unknown 1=low 2=med 3=high
  final accuracyLabel = 'Mengaktifkan sensor...'.obs;
  final hasError      = false.obs;
  final errorMessage  = ''.obs;
  final isDemoMode    = false.obs;

  // ── Internal ────────────────────────────────────────────
  double _filtered      = 0.0;
  double _smoothFactor  = 0.08;
  String _lastDirShort  = '';
  StreamSubscription<MagnetometerEvent>? _sub;
  Timer? _demoTimer;

  @override
  void onInit() {
    super.onInit();
    _initSensors();
  }

  @override
  void onClose() {
    _sub?.cancel();
    _demoTimer?.cancel();
    super.onClose();
  }

  // ══════════════════════════════════════════════════════════
  // SENSOR INIT
  // ══════════════════════════════════════════════════════════
  Future<void> _initSensors() async {
    try {
      _sub = magnetometerEventStream(
        samplingPeriod: SensorInterval.gameInterval, // ~20 ms
      ).listen(
        _onMagEvent,
        onError: (e) {
          hasError.value    = true;
          errorMessage.value = 'Sensor error: $e';
          accuracyLabel.value = 'Sensor error';
        },
        cancelOnError: false,
      );

      // Jika 3 detik belum ada data → tampilkan pesan
      Future.delayed(const Duration(seconds: 3), () {
        if (heading.value == 0.0 && !hasError.value) {
          accuracyLabel.value = 'Mencoba mendeteksi sensor…';
        }
      });
    } on PlatformException catch (e) {
      hasError.value = true;
      errorMessage.value = e.message?.contains('not available') == true ||
              e.message?.contains('not supported') == true
          ? 'Perangkat ini tidak memiliki sensor magnetometer'
          : 'Gagal mengakses sensor: ${e.message}';
      accuracyLabel.value = 'Tidak tersedia';
    } catch (e) {
      hasError.value     = true;
      errorMessage.value = 'Error: $e';
    }
  }

  // ══════════════════════════════════════════════════════════
  // MAGNETOMETER EVENT HANDLER
  // ══════════════════════════════════════════════════════════
  void _onMagEvent(MagnetometerEvent e) {
    if (isLocked.value || isCalibrating.value) return;

    // Skip zero readings (sensor tidak benar-benar aktif)
    if (e.x == 0 && e.y == 0 && e.z == 0) return;

    // ── Hitung heading mentah ──
    // Untuk HP tegak portrait, screen menghadap user:
    //   X → kanan, Y → atas, Z → menuju user
    double raw = math.atan2(-e.x, e.y) * (180 / math.pi);
    if (raw < 0) raw += 360;

    // ── Low-pass filter (smooth + handle wraparound) ──
    double diff = raw - _filtered;
    if (diff > 180)  diff -= 360;
    if (diff < -180) diff += 360;
    _filtered += diff * _smoothFactor;
    if (_filtered < 0)   _filtered += 360;
    if (_filtered >= 360) _filtered -= 360;

    heading.value = _filtered;

    // ── Haptic saat ganti arah kardinal ──
    final short = getDirectionShort(_filtered);
    if (short != _lastDirShort && _lastDirShort.isNotEmpty) {
      HapticFeedback.selectionClick();
    }
    _lastDirShort = short;

    // ── Akurasi berdasarkan kekuatan medan magnet ──
    final mag = math.sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
    if (mag >= 25) {
      accuracyLevel.value = 3;
      accuracyLabel.value = 'Akurasi Tinggi';
    } else if (mag >= 15) {
      accuracyLevel.value = 2;
      accuracyLabel.value = 'Akurasi Sedang';
    } else if (mag > 0) {
      accuracyLevel.value = 1;
      accuracyLabel.value = 'Sinyal Lemah – gerakkan HP membentuk angka 8';
    }
  }

  // ══════════════════════════════════════════════════════════
  // DIRECTION HELPERS
  // ══════════════════════════════════════════════════════════
  String getDirectionName(double h) {
    const names = [
      'Utara', 'Timur Laut', 'Timur', 'Tenggara',
      'Selatan', 'Barat Daya', 'Barat', 'Barat Laut',
    ];
    return names[((h + 22.5) ~/ 45) % 8];
  }

  String getDirectionShort(double h) {
    const s = ['U', 'TL', 'T', 'TG', 'S', 'BD', 'B', 'BL'];
    return s[((h + 22.5) ~/ 45) % 8];
  }

  // ══════════════════════════════════════════════════════════
  // ACTIONS
  // ══════════════════════════════════════════════════════════
  void toggleLock() {
    isLocked.toggle();
    HapticFeedback.mediumImpact();
  }

  void calibrate() {
    isCalibrating.value = true;
    _filtered  = 0;
    heading.value = 0;
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 1500), () {
      isCalibrating.value = false;
    });
  }

  /// Mode demo untuk emulator / device tanpa magnetometer
  void startDemo() {
    _sub?.cancel();
    _demoTimer?.cancel();
    hasError.value   = false;
    isDemoMode.value = true;
    accuracyLabel.value = 'Mode Demo';
    accuracyLevel.value = 3;

    double a = 0;
    _demoTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (isLocked.value || isCalibrating.value) return;
      // Simulasi gerakan natural dengan sine wave
      a = (a + 0.3 + math.sin(a * 0.02) * 0.5) % 360;
      heading.value = a;
      _filtered    = a;
    });
  }
}