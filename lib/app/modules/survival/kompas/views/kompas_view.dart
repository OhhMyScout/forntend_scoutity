import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kompas_controller.dart';

class KompasView extends GetView<KompasController> {
  const KompasView({super.key});

  static const _primary = Color(0xFF361F1A);
  static const _sec     = Color(0xFF7D562D);
  static const _bg      = Color(0xFFFCF9F4);
  static const _surface = Color(0xFFF6F3EE);
  static const _outline = Color(0xFFD4C3BF);
  static const _error   = Color(0xFFBA1A1A);
  static const _accent  = Color(0xFFFFCA98);
  static const _muted   = Color(0xFF827471);
  static const _divider = Color(0xFFEBE5DB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            const Spacer(flex: 2),
            _compassSection(),
            const SizedBox(height: 32),
            _headingDisplay(),
            const Spacer(flex: 3),
            _bottomPanel(),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // HEADER
  // ══════════════════════════════════════════════════════════
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
      child: Row(
        children: [
          _iconBtn(Icons.arrow_back_ios_new_rounded, () => Get.back()),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _outline),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.explore_rounded, color: _sec, size: 19),
                SizedBox(width: 8),
                Text(
                  'Kompas Digital',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: _primary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _infoButton(),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _outline),
          ),
          child: Icon(icon, color: _primary, size: 18),
        ),
      ),
    );
  }

  Widget _infoButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Get.to(
          () => const _CompassGuideScreen(),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 400),
        ),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _outline),
          ),
          child: const Center(
            child: Text(
              '!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: _error,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // COMPASS SECTION
  // ══════════════════════════════════════════════════════════
  Widget _compassSection() {
    const size = 300.0;
    return SizedBox(
      width: size + 48,
      height: size + 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow
          Obx(() {
            final locked = controller.isLocked.value;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: size + 24,
              height: size + 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _accent.withOpacity(locked ? 0.06 : 0.18),
                    _accent.withOpacity(locked ? 0.02 : 0.04),
                    Colors.transparent,
                  ],
                  radius: 0.55,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            );
          }),

          // Fixed triangle
          const Positioned(
            top: 2,
            child: CustomPaint(
              size: Size(22, 18),
              painter: _TriangleIndicatorPainter(),
            ),
          ),

          // Dial
          Obx(() {
            if (controller.hasError.value && !controller.isDemoMode.value) {
              return _errorCompass(size, controller.errorMessage.value);
            }
            return Transform.rotate(
              angle: -controller.heading.value * (math.pi / 180),
              child: const CustomPaint(
                size: Size(size, size),
                painter: _CompassDialPainter(),
              ),
            );
          }),

          // Lock overlay
          Obx(() => controller.isLocked.value
              ? _circleOverlay(size, Icons.lock_rounded, 0.45)
              : const SizedBox.shrink()),

          // Calibration overlay
          Obx(() => controller.isCalibrating.value
              ? _circleOverlay(
                  size, null, 0.5,
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      color: _sec,
                      strokeWidth: 3,
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _circleOverlay(double size, IconData? icon, double opacity,
      {Widget? child}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
      child: child ??
          Icon(icon, size: 48, color: _primary.withOpacity(0.8)),
    );
  }

  Widget _errorCompass(double size, String msg) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _surface,
        border: Border.all(color: _outline, width: 4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _outline.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
                Icons.sensors_off_rounded, size: 30, color: _muted),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Text(
              msg,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _muted, fontSize: 12.5),
            ),
          ),
          const SizedBox(height: 18),
          _smallPill('Coba Mode Demo', controller.startDemo),
        ],
      ),
    );
  }

  Widget _smallPill(String text, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: _primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _primary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // HEADING DISPLAY
  // ══════════════════════════════════════════════════════════
  Widget _headingDisplay() {
    return Obx(() {
      final h = controller.heading.value;
      final dir = controller.getDirectionName(h);
      final short = controller.getDirectionShort(h);

      return Column(
        children: [
          Text(
            '${h.toInt()}°',
            style: const TextStyle(
              fontSize: 54,
              fontWeight: FontWeight.w900,
              color: _primary,
              letterSpacing: -2,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.35),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: Text(
              dir.toUpperCase(),
              key: ValueKey(short),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 5,
                color: _muted,
              ),
            ),
          ),
        ],
      );
    });
  }

  // ══════════════════════════════════════════════════════════
  // BOTTOM PANEL
  // ══════════════════════════════════════════════════════════
  Widget _bottomPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(() => Row(
                children: [
                  _accuracyDot(controller.accuracyLevel.value),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      controller.accuracyLabel.value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _primary,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                  if (controller.isDemoMode.value)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _accent.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'DEMO',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: _sec,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                ],
              )),
          const SizedBox(height: 16),
          const Divider(height: 1, color: _divider),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Obx(() => _actionBtn(
                      icon: controller.isLocked.value
                          ? Icons.lock_rounded
                          : Icons.lock_open_rounded,
                      label: controller.isLocked.value
                          ? 'Buka Kunci'
                          : 'Kunci Arah',
                      onTap: controller.toggleLock,
                      active: controller.isLocked.value,
                    )),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _actionBtn(
                  icon: Icons.refresh_rounded,
                  label: 'Kalibrasi',
                  onTap: controller.calibrate,
                  active: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _actionBtn(
                  icon: Icons.videogame_asset_rounded,
                  label: 'Mode Demo',
                  onTap: controller.startDemo,
                  active: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _accuracyDot(int level) {
    final colors = [_muted, Colors.orange, Colors.amber.shade600, Colors.green];
    final c = colors[level.clamp(0, 3)];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c,
        boxShadow: [BoxShadow(color: c.withOpacity(0.45), blurRadius: 6)],
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool active,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? _primary : _surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: active ? _primary : _outline),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 17, color: active ? Colors.white : _primary),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                    color: active ? Colors.white : _primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// CUSTOM PAINTERS
// ══════════════════════════════════════════════════════════════

class _TriangleIndicatorPainter extends CustomPainter {
  const _TriangleIndicatorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawShadow(
        path, const Color(0xFFBA1A1A).withOpacity(0.3), 4, false);
    canvas.drawPath(path, Paint()..color = const Color(0xFFBA1A1A));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CompassDialPainter extends CustomPainter {
  const _CompassDialPainter();

  static const _pri = Color(0xFF361F1A);
  static const _mut = Color(0xFF827471);
  static const _out = Color(0xFFD4C3BF);
  static const _err = Color(0xFFBA1A1A);

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    canvas.save();
    canvas.translate(r, r);
    _paintFace(canvas, r);
    _paintOuterRing(canvas, r);
    _paintTicks(canvas, r);
    _paintDegreeNumbers(canvas, r);
    _paintCardinalLabels(canvas, r);
    _paintNeedle(canvas, r);
    _paintCenterCap(canvas, r);
    canvas.restore();
  }

  void _paintFace(Canvas canvas, double r) {
    canvas.drawCircle(
        Offset.zero, r, Paint()..color = const Color(0xFFFEFCF9));
    final rect = Rect.fromCircle(center: Offset.zero, radius: r);
    canvas.drawCircle(
        Offset.zero,
        r,
        Paint()
          ..shader = const RadialGradient(
              colors: [Color(0x40FFFFFF), Color(0x00FFFFFF)],
              radius: 0.5)
              .createShader(rect));
  }

  void _paintOuterRing(Canvas canvas, double r) {
    canvas.drawCircle(
        Offset.zero,
        r * 0.93,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.055
          ..color = _pri);
    canvas.drawCircle(
        Offset.zero,
        r * 0.885,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = _out);
    canvas.drawCircle(
        Offset.zero,
        r * 0.97,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = _out.withOpacity(0.5));
  }

  void _paintTicks(Canvas canvas, double r) {
    final outerR = r * 0.93;
    for (int deg = 0; deg < 360; deg += 5) {
      final rad = (deg - 90) * math.pi / 180;
      final is90 = deg % 90 == 0;
      final is30 = deg % 30 == 0;
      final is15 = deg % 15 == 0;
      final len = is90
          ? r * 0.11
          : is30
              ? r * 0.08
              : is15
                  ? r * 0.06
                  : r * 0.035;
      final w = is90 ? 2.5 : is30 ? 2.0 : is15 ? 1.5 : 0.8;
      final col = is90
          ? _pri
          : is30
              ? _pri.withOpacity(0.75)
              : is15
                  ? _mut
                  : _out;
      canvas.drawLine(
          Offset.fromDirection(rad, outerR - len),
          Offset.fromDirection(rad, outerR),
          Paint()
            ..color = col
            ..strokeWidth = w
            ..strokeCap = StrokeCap.round);
    }
  }

  void _paintDegreeNumbers(Canvas canvas, double r) {
    const skip = {0, 90, 180, 270};
    final numR = r * 0.77;
    final fontSize = r * 0.062;
    for (int deg = 0; deg < 360; deg += 30) {
      if (skip.contains(deg)) continue;
      final rad = (deg - 90) * math.pi / 180;
      canvas.save();
      canvas.translate(math.cos(rad) * numR, math.sin(rad) * numR);
      canvas.rotate(rad + math.pi / 2);
      _drawText(canvas, '$deg°', fontSize, _pri.withOpacity(0.55),
          FontWeight.w500);
      canvas.restore();
    }
  }

  void _paintCardinalLabels(Canvas canvas, double r) {
    const cardinals = [
      ('N', 0, _err),
      ('E', 90, _pri),
      ('S', 180, _pri),
      ('W', 270, _pri),
    ];
    const intercardinals = [
      ('NE', 45),
      ('SE', 135),
      ('SW', 225),
      ('NW', 315),
    ];
    for (final (label, deg) in intercardinals) {
      final rad = (deg - 90) * math.pi / 180;
      final cR = r * 0.74;
      canvas.save();
      canvas.translate(math.cos(rad) * cR, math.sin(rad) * cR);
      canvas.rotate(rad + math.pi / 2);
      _drawText(canvas, label, r * 0.06, _mut, FontWeight.w600);
      canvas.restore();
    }
    for (final (label, deg, color) in cardinals) {
      final rad = (deg - 90) * math.pi / 180;
      final cR = r * 0.71;
      canvas.save();
      canvas.translate(math.cos(rad) * cR, math.sin(rad) * cR);
      canvas.rotate(rad + math.pi / 2);
      _drawText(canvas, label, r * 0.11, color, FontWeight.w800);
      canvas.restore();
    }
  }

  void _paintNeedle(Canvas canvas, double r) {
    final nLen = r * 0.56;
    final sLen = r * 0.36;
    final w = r * 0.052;

    // Shadow
    canvas.save();
    canvas.translate(2, 3);
    canvas.drawPath(
        Path()
          ..moveTo(0, -nLen)
          ..lineTo(-w, 0)
          ..lineTo(0, sLen)
          ..lineTo(w, 0)
          ..close(),
        Paint()..color = Colors.black.withOpacity(0.08));
    canvas.restore();

    // North half
    final nPath = Path()
      ..moveTo(0, -nLen)
      ..lineTo(-w, 0)
      ..lineTo(w, 0)
      ..close();
    canvas.drawPath(
        nPath,
        Paint()
          ..shader = const LinearGradient(
              colors: [_err, Color(0xFFD32F2F)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)
              .createShader(
                  Rect.fromPoints(Offset(-w, -nLen), Offset(w, 0))));
    canvas.drawPath(
        nPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = _pri.withOpacity(0.15));

    // South half
    final sPath = Path()
      ..moveTo(0, sLen)
      ..lineTo(-w, 0)
      ..lineTo(w, 0)
      ..close();
    canvas.drawPath(
        sPath,
        Paint()
          ..shader = LinearGradient(
              colors: [Colors.grey.shade400, Colors.grey.shade200],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)
              .createShader(
                  Rect.fromPoints(Offset(-w, 0), Offset(w, sLen))));
    canvas.drawPath(
        sPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = _pri.withOpacity(0.15));
  }

  void _paintCenterCap(Canvas canvas, double r) {
    canvas.drawCircle(Offset.zero, r * 0.072, Paint()..color = _pri);
    canvas.drawCircle(
        Offset.zero, r * 0.048, Paint()..color = const Color(0xFFFFCA98));
    canvas.drawCircle(
        Offset(-r * 0.016, -r * 0.016),
        r * 0.016,
        Paint()..color = Colors.white.withOpacity(0.55));
  }

  void _drawText(Canvas canvas, String text, double fontSize, Color color,
      FontWeight weight) {
    final tp = TextPainter(
        text: TextSpan(
            text: text,
            style: TextStyle(
                color: color, fontSize: fontSize, fontWeight: weight)),
        textDirection: TextDirection.ltr)
      ..layout();
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) => false;
}

// ══════════════════════════════════════════════════════════════
// FULL-SCREEN GUIDE SCREEN
// ══════════════════════════════════════════════════════════════

class _CompassGuideScreen extends StatefulWidget {
  const _CompassGuideScreen();

  @override
  State<_CompassGuideScreen> createState() => _CompassGuideScreenState();
}

class _CompassGuideScreenState extends State<_CompassGuideScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // ── Data mata angin: setiap field sudah punya 3 bahasa ──
  static const _directions = [
    {'deg': '0°', 'en': 'North', 'id': 'Utara', 'jv': 'Lor', 'abbr': 'N', 'color': Color(0xFFBA1A1A)},
    {'deg': '45°', 'en': 'Northeast', 'id': 'Timur Laut', 'jv': 'Wetan Lor', 'abbr': 'NE', 'color': Color(0xFF7D562D)},
    {'deg': '90°', 'en': 'East', 'id': 'Timur', 'jv': 'Wetan', 'abbr': 'E', 'color': Color(0xFF361F1A)},
    {'deg': '135°', 'en': 'Southeast', 'id': 'Tenggara', 'jv': 'Kidul Wetan', 'abbr': 'SE', 'color': Color(0xFF7D562D)},
    {'deg': '180°', 'en': 'South', 'id': 'Selatan', 'jv': 'Kidul', 'abbr': 'S', 'color': Color(0xFF361F1A)},
    {'deg': '225°', 'en': 'Southwest', 'id': 'Barat Daya', 'jv': 'Kidul Kulon', 'abbr': 'SW', 'color': Color(0xFF7D562D)},
    {'deg': '270°', 'en': 'West', 'id': 'Barat', 'jv': 'Kulon', 'abbr': 'W', 'color': Color(0xFF361F1A)},
    {'deg': '315°', 'en': 'Northwest', 'id': 'Barat Laut', 'jv': 'Kulon Lor', 'abbr': 'NW', 'color': Color(0xFF7D562D)},
  ];

  // ── Data langkah: title & desc masing-masing punya 3 bahasa ──
  static const _steps = [
    {
      'icon': Icons.phone_android_rounded,
      'title': {'en': 'Hold Phone Upright', 'id': 'Pegang HP Tegak', 'jv': 'Tengeri HP Nenggak'},
      'desc': {
        'en': 'Hold your phone vertically with the screen facing you. The compass works best when the phone is flat relative to the ground.',
        'id': 'Pegang ponsel secara tegak dengan layar menghadap ke arah Anda. Kompas bekerja paling akurat saat posisi ponsel sejajar dengan permukaan datar.',
        'jv': 'Tengeri hp nenggak mburi, layar ngadhepi sira. Kompas bakal luwih pas yen posisine rata karo lemah.',
      },
    },
    {
      'icon': Icons.rotate_right_rounded,
      'title': {'en': 'Rotate Slowly', 'id': 'Putar Perlahan', 'jv': 'Puter Pelan-Pelan'},
      'desc': {
        'en': 'Slowly rotate your body or the phone to find a direction. The dial rotates so that the red needle always points to magnetic North.',
        'id': 'Putar tubuh atau ponsel secara perlahan untuk menemukan arah. Dial berputar sehingga jarum merah selalu menunjuk ke arah Utara magnetik.',
        'jv': 'Puter awak utawa hp pelan-pelan nganti nemu arah. Dial bakal muter supaya jarum abang tansah nunjuk marang Lor.',
      },
    },
    {
      'icon': Icons.redo_rounded,
      'title': {'en': 'Read the Direction', 'id': 'Baca Arah', 'jv': 'Woco Arahé'},
      'desc': {
        'en': 'The red triangle indicator at the top shows the direction you are currently facing. The degree and direction name are displayed below.',
        'id': 'Segitiga merah di atas kompas menunjukkan arah yang sedang Anda hadapi. Derajat dan nama arah ditampilkan di bawah kompas.',
        'jv': 'Segitiga abang neng dhuwur kompas nunjukake arah sing sira hadepi saiki. Derajat lan jeneng arah ana neng ngisor kompas.',
      },
    },
    {
      'icon': Icons.settings_suggest_rounded,
      'title': {'en': 'Calibrate if Needed', 'id': 'Kalibrasi Jika Perlu', 'jv': 'Kalibrasi Yen Perlu'},
      'desc': {
        'en': 'If the reading seems inaccurate, tap "Kalibrasi" and move the phone in a figure-8 pattern to recalibrate the magnetometer.',
        'id': 'Jika pembacaan terasa tidak akurat, tap "Kalibrasi" lalu gerakkan ponsel membentuk pola angka 8 untuk mengkalibrasi ulang sensor.',
        'jv': 'Yen bacane krasa salah, klik "Kalibrasi" terus gerakke hp gawé pola angka 8 kanggo ngreset sensor.',
      },
    },
  ];

  // ── Tips per bahasa ──
  static const _tips = {
    'tip1': {
      'en': 'Keep away from metal objects, magnets, and electronic devices that can interfere with the magnetometer sensor.',
      'id': 'Jauhkan dari benda logam, magnet, dan perangkat elektronik yang dapat mengganggu sensor magnetometer.',
      'jv': 'Adohna saka barang wesi, magnet, lan piranti elektronik sing bisa ngganggu sensor magnetometer.',
    },
    'tip2': {
      'en': 'For best results, calibrate the compass by moving your phone in a figure-8 pattern before first use.',
      'id': 'Untuk hasil terbaik, kalibrasi kompas dengan menggerakkan ponsel membentuk pola angka 8 sebelum pertama kali digunakan.',
      'jv': 'Supaya hasilne apik, kalibrasi kompas karo gerakke hp gawé pola angka 8 sadurungé dinggo kapisan.',
    },
    'tip3': {
      'en': 'The compass shows magnetic North, not true North. The difference (magnetic declination) varies by location.',
      'id': 'Kompas menunjukkan Utara magnetik, bukan Utara sejati. Perbedaannya (deklinasi magnetik) bervariasi tiap lokasi.',
      'jv': 'Kompas nunjukake Lor magnetik, dudu Lor bener. Bédané (deklinasi magnetik) béda-béda tergantung panggonan.',
    },
  };

  // ── Section labels per bahasa ──
  static const _sectionLabels = {
    'howToUse': {'en': 'How to Use', 'id': 'Cara Menggunakan', 'jv': 'Cara Nggunakake'},
    'directionTable': {'en': 'Cardinal Directions', 'id': 'Tabel Mata Angin', 'jv': 'Tabel Mata Angin'},
    'tips': {'en': 'Tips', 'id': 'Tips', 'jv': 'Tips'},
  };

  // ── Table headers per bahasa ──
  static const _tableHeaders = {
    'en': ['Degree', 'Abbr.', 'Direction'],
    'id': ['Derajat', 'Singk.', 'Nama Arah'],
    'jv': ['Derajat', 'Singk.', 'Jeneng Arah'],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F4),
      body: SafeArea(
        child: Column(
          children: [
            _guideHeader(),
            _languageTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _guideContent('en'),
                  _guideContent('id'),
                  _guideContent('jv'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Guide Header ──
  Widget _guideHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD4C3BF)),
                ),
                child: const Icon(Icons.close_rounded,
                    color: Color(0xFF361F1A), size: 20),
              ),
            ),
          ),
          const Spacer(),
          const Column(
            children: [
              Text(
                'Panduan Kompas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF361F1A),
                ),
              ),
              Text(
                'Cara membaca mata angin',
                style: TextStyle(fontSize: 12, color: Color(0xFF827471)),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD4C3BF)),
            ),
            child: const Center(
              child: Icon(Icons.explore_rounded,
                  color: Color(0xFF7D562D), size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ── Language Tabs ──
  Widget _languageTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEBE5DB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF361F1A),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF361F1A).withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF827471),
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        labelPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        tabs: const [
          Tab(text: '🇬🇧  English'),
          Tab(text: '🇮🇩  Indonesia'),
          Tab(text: '🇯🇵  Jawa'),
        ],
      ),
    );
  }

  // ── Guide Content ──
  Widget _guideContent(String lang) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section: Cara Menggunakan
          _sectionTitle(
              _sectionLabels['howToUse']![lang]!, Icons.play_circle_rounded),
          const SizedBox(height: 14),
          ...List.generate(_steps.length, (i) {
            final step = _steps[i] as Map<String, dynamic>;
            final isLast = i == _steps.length - 1;
            return _buildStepCard(
              index: i + 1,
              icon: step['icon'] as IconData,
              title: step['title']![lang]!,
              description: step['desc']![lang]!,
              isLast: isLast,
            );
          }),
          const SizedBox(height: 32),

          // Section: Tabel Mata Angin
          _sectionTitle(_sectionLabels['directionTable']![lang]!,
              Icons.explore_rounded),
          const SizedBox(height: 14),
          _dirTableHeader(lang),
          const SizedBox(height: 2),
          ...List.generate(_directions.length, (i) {
            return _dirTableRow(_directions[i], lang, i);
          }),
          const SizedBox(height: 32),

          // Section: Tips
          _sectionTitle(
              _sectionLabels['tips']![lang]!, Icons.lightbulb_rounded),
          const SizedBox(height: 14),
          _tipCard(_tips['tip1']![lang]!),
          const SizedBox(height: 10),
          _tipCard(_tips['tip2']![lang]!),
          const SizedBox(height: 10),
          _tipCard(_tips['tip3']![lang]!),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, IconData icon) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFFFCA98).withOpacity(0.35),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 19, color: const Color(0xFF7D562D)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF361F1A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard({
    required int index,
    required IconData icon,
    required String title,
    required String description,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF361F1A),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF361F1A).withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4C3BF),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon,
                          size: 17, color: const Color(0xFF7D562D)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF361F1A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF827471),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dirTableHeader(String lang) {
    final headers = _tableHeaders[lang]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _headerCell(headers[0], 1),
          _headerCell(headers[1], 2),
          _headerCell(headers[2], 3),
        ],
      ),
    );
  }

  Widget _headerCell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF7D562D),
        ),
      ),
    );
  }

  Widget _dirTableRow(Map<String, dynamic> d, String lang, int index) {
    final isCardinal = [0, 2, 4, 6].contains(index);
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isCardinal
            ? const Color(0xFFFFCA98).withOpacity(0.12)
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (d['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                d['deg'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: d['color'] as Color,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              d['abbr'] as String,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    isCardinal ? FontWeight.w800 : FontWeight.w600,
                color: isCardinal
                    ? const Color(0xFF361F1A)
                    : const Color(0xFF827471),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              d[lang] as String,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight:
                    isCardinal ? FontWeight.w700 : FontWeight.w500,
                color: isCardinal
                    ? const Color(0xFF361F1A)
                    : const Color(0xFF827471),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tipCard(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEBE5DB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.check_circle_rounded,
                color: Color(0xFF7D562D), size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF827471),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}