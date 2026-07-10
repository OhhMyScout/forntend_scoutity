import 'package:flutter/material.dart';

/// Data multibahasa untuk panduan kompas.
///
/// File ini dipisahkan dari `kompas_view.dart` agar lebih rapi dan terstruktur.
class MultibahasaKompasData {
  // ══════════════════════════════════════════════════════════════
  // DIRECTIONS
  // ══════════════════════════════════════════════════════════════
  static const List<Map<String, dynamic>> directions = [
    {
      'deg': '0°',
      'en': 'North',
      'id': 'Utara',
      'jv': 'Lor',
      'abbr': 'N',
      'color': Color(0xFFBA1A1A),
    },
    {
      'deg': '45°',
      'en': 'Northeast',
      'id': 'Timur Laut',
      'jv': 'Wetan Lor',
      'abbr': 'NE',
      'color': Color(0xFF7D562D),
    },
    {
      'deg': '90°',
      'en': 'East',
      'id': 'Timur',
      'jv': 'Wetan',
      'abbr': 'E',
      'color': Color(0xFF361F1A),
    },
    {
      'deg': '135°',
      'en': 'Southeast',
      'id': 'Tenggara',
      'jv': 'Kidul Wetan',
      'abbr': 'SE',
      'color': Color(0xFF7D562D),
    },
    {
      'deg': '180°',
      'en': 'South',
      'id': 'Selatan',
      'jv': 'Kidul',
      'abbr': 'S',
      'color': Color(0xFF361F1A),
    },
    {
      'deg': '225°',
      'en': 'Southwest',
      'id': 'Barat Daya',
      'jv': 'Kidul Kulon',
      'abbr': 'SW',
      'color': Color(0xFF7D562D),
    },
    {
      'deg': '270°',
      'en': 'West',
      'id': 'Barat',
      'jv': 'Kulon',
      'abbr': 'W',
      'color': Color(0xFF361F1A),
    },
    {
      'deg': '315°',
      'en': 'Northwest',
      'id': 'Barat Laut',
      'jv': 'Kulon Lor',
      'abbr': 'NW',
      'color': Color(0xFF7D562D),
    },
  ];

  // ══════════════════════════════════════════════════════════════
  // STEPS
  // ══════════════════════════════════════════════════════════════
  static const List<Map<String, dynamic>> steps = [
    {
      'icon': Icons.phone_android_rounded,
      'title': {'en': 'Hold Phone Upright', 'id': 'Pegang HP Tegak', 'jv': 'Tengeri HP Nenggak'},
      'desc': {
        'en':
            'Hold your phone vertically with the screen facing you. The compass works best when the phone is flat relative to the ground.',
        'id':
            'Pegang ponsel secara tegak dengan layar menghadap ke arah Anda. Kompas bekerja paling akurat saat posisi ponsel sejajar dengan permukaan datar.',
        'jv':
            'Tengeri hp nenggak mburi, layar ngadhepi sira. Kompas bakal luwih pas yen posisine rata karo lemah.',
      },
    },
    {
      'icon': Icons.rotate_right_rounded,
      'title': {'en': 'Rotate Slowly', 'id': 'Putar Perlahan', 'jv': 'Puter Pelan-Pelan'},
      'desc': {
        'en':
            'Slowly rotate your body or the phone to find a direction. The dial rotates so that the red needle always points to magnetic North.',
        'id':
            'Putar tubuh atau ponsel secara perlahan untuk menemukan arah. Dial berputar sehingga jarum merah selalu menunjuk ke arah Utara magnetik.',
        'jv':
            'Puter awak utawa hp pelan-pelan nganti nemu arah. Dial bakal muter supaya jarum abang tansah nunjuk marang Lor.',
      },
    },
    {
      'icon': Icons.redo_rounded,
      'title': {'en': 'Read the Direction', 'id': 'Baca Arah', 'jv': 'Woco Arahé'},
      'desc': {
        'en':
            'The red triangle indicator at the top shows the direction you are currently facing. The degree and direction name are displayed below.',
        'id':
            'Segitiga merah di atas kompas menunjukkan arah yang sedang Anda hadapi. Derajat dan nama arah ditampilkan di bawah kompas.',
        'jv':
            'Segitiga abang neng dhuwur kompas nunjukake arah sing sira hadepi saiki. Derajat lan jeneng arah ana neng ngisor kompas.',
      },
    },
    {
      'icon': Icons.settings_suggest_rounded,
      'title': {'en': 'Calibrate if Needed', 'id': 'Kalibrasi Jika Perlu', 'jv': 'Kalibrasi Yen Perlu'},
      'desc': {
        'en':
            'If the reading seems inaccurate, tap "Kalibrasi" and move the phone in a figure-8 pattern to recalibrate the magnetometer.',
        'id':
            'Jika pembacaan terasa tidak akurat, tap "Kalibrasi" lalu gerakkan ponsel membentuk pola angka 8 untuk mengkalibrasi ulang sensor.',
        'jv':
            'Yen bacane krasa salah, klik "Kalibrasi" terus gerakke hp gawé pola angka 8 kanggo ngreset sensor.',
      },
    },
  ];

  // ══════════════════════════════════════════════════════════════
  // TIPS
  // ══════════════════════════════════════════════════════════════
  static const Map<String, Map<String, String>> tips = {
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
      'jv': 'Kompas nunjukake Lor magnetik, dudu Lor bener. Bédané (deklinasi magnetik) béda-béda gumantung panggonan.',
    },
  };

  // ══════════════════════════════════════════════════════════════
  // SECTION LABELS
  // ══════════════════════════════════════════════════════════════
  static const Map<String, Map<String, String>> sectionLabels = {
    'howToUse': {'en': 'How to Use', 'id': 'Cara Menggunakan', 'jv': 'Cara Nggunakake'},
    'directionTable': {'en': 'Cardinal Directions', 'id': 'Tabel Mata Angin', 'jv': 'Tabel Mata Angin'},
    'tips': {'en': 'Tips', 'id': 'Tips', 'jv': 'Tips'},
  };

  // ══════════════════════════════════════════════════════════════
  // TABLE HEADERS
  // ══════════════════════════════════════════════════════════════
  static const Map<String, List<String>> tableHeaders = {
    'en': ['Degree', 'Abbr.', 'Direction'],
    'id': ['Derajat', 'Singk.', 'Nama Arah'],
    'jv': ['Derajat', 'Singk.', 'Jeneng Arah'],
  };
}

