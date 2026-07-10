import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Model Data untuk Setiap Artikel
class ArtikelPramuka {
  final String id;
  final String kategori;
  final String judul;
  final String konten;
  final IconData icon;

  ArtikelPramuka({
    required this.id,
    required this.kategori,
    required this.judul,
    required this.konten,
    required this.icon,
  });
}

// Model Data untuk Galeri Foto Sejarah
class GaleriSejarah {
  final String imagePath;
  final String caption;

  GaleriSejarah({
    required this.imagePath,
    required this.caption,
  });
}

class SejarahPramukaController extends GetxController {
  // State untuk artikel & galeri
  final expandedArtikelId = "".obs;
  final daftarGaleri = <GaleriSejarah>[].obs;
  final isLoadingGaleri = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadGaleriDariFolder();
  }

  /// FUNGSI MEMBACA GAMBAR (MENGGUNAKAN HARDCODED LIST YANG AMAN)
  Future<void> _loadGaleriDariFolder() async {
    try {
      isLoadingGaleri.value = true;
      
      // Fallback: pakai list asset yang memang ada (hardcoded) agar galeri tidak kosong
      // dan terhindar dari isu AssetManifest di rilis Flutter terbaru.
      final List<String> imagePaths = [
        // FOLDER DUNIA
        'assets/images/sejarah/dunia/bapak_pramuka.png',
        'assets/images/sejarah/dunia/sejarah1.png',
        'assets/images/sejarah/dunia/sejarah2.png',
        'assets/images/sejarah/dunia/sejarah3.png',
        'assets/images/sejarah/dunia/scouting_for_boys_book.png',
        'assets/images/sejarah/dunia/scouting_for_boys_book2.png',
        'assets/images/sejarah/dunia/sejarah_jambore.png',

        // FOLDER INDONESIA
        'assets/images/sejarah/indonesia/logoGerakanPramuka.png',
        'assets/images/sejarah/indonesia/sejarah1.png',
        'assets/images/sejarah/indonesia/sejarah2.png',
        'assets/images/sejarah/indonesia/sejarah3.png',
        'assets/images/sejarah/indonesia/sejarah4.png',
      ];

      // Masukkan hardcoded imagePaths langsung ke galeri.
      final List<GaleriSejarah> loadedGaleri = imagePaths.map((path) {
        // Ambil nama file tanpa folder dan tanpa format (contoh: "bapak_pramuka")
        final filename = path.split('/').last.split('.').first;
        
        // Buat nama file menjadi format Title Case yang rapi (contoh: "Bapak Pramuka")
        final caption = filename
            .replaceAll('_', ' ')
            .replaceAll(RegExp(r'(?<=[a-z])(?=[A-Z])'), ' ') // Pisah camelCase (logoGerakan -> logo Gerakan)
            .split(' ')
            .map((word) => word.isNotEmpty
                ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                : '')
            .join(' ');

        return GaleriSejarah(imagePath: path, caption: caption);
      }).toList();

      debugPrint('SejarahPramuka loadedGaleri count: ${loadedGaleri.length}');

      // Update state data
      daftarGaleri.assignAll(loadedGaleri);

    } catch (e) {
      debugPrint("Gagal memuat gambar galeri: $e");
    } finally {
      // Pastikan loading selalu berhenti meskipun ada error
      isLoadingGaleri.value = false;
    }
  }

  // Fungsi toggle buka/tutup kartu artikel
  void toggleArtikel(String id) {
    if (expandedArtikelId.value == id) {
      expandedArtikelId.value = ""; // Tutup
    } else {
      expandedArtikelId.value = id; // Buka
    }
  }

  // Database Materi Lengkap Pramuka
  final List<ArtikelPramuka> daftarMateri = [
    /// BAGIAN 1: PENGANTAR PRAMUKA
    ArtikelPramuka(
      id: "intro_1",
      kategori: "Pengantar",
      judul: "Pengertian & Arti Praja Muda Karana",
      icon: Icons.info_outline_rounded,
      konten: '''Banyak yang sering menyamakan Pramuka, Kepramukaan, dan Gerakan Pramuka. Berikut perbedaannya:

• Pramuka: Singkatan dari Praja Muda Karana, yang berarti "Jiwa Muda yang Suka Berkarya". Ini merujuk pada anggota organisasinya (Siaga, Penggalang, Penegak, Pandega).
• Kepramukaan: Adalah proses pendidikannya. Sebuah proses pendidikan di luar lingkungan sekolah dan keluarga dalam bentuk kegiatan menarik, menyenangkan, sehat, dan terarah di alam terbuka.
• Gerakan Pramuka: Adalah nama organisasinya (wadah/badan hukum).

Tujuan Gerakan Pramuka adalah membentuk setiap anggota agar memiliki kepribadian yang beriman, bertakwa, berakhlak mulia, berjiwa patriotik, taat hukum, disiplin, dan memiliki kecakapan hidup.''',
    ),
    ArtikelPramuka(
      id: "intro_2",
      kategori: "Pengantar",
      judul: "Lambang & Motto Pramuka",
      icon: Icons.eco_rounded,
      konten: '''Motto Gerakan Pramuka adalah: "Satyaku Kudarmakan, Darmaku Kubaktikan".

Lambang Gerakan Pramuka adalah siluet Tunas Kelapa yang diciptakan oleh Soenardjo Atmodipuro. Filosofinya:
1. Buah nyiur (cikal): Pramuka adalah cikal bakal dan generasi penerus kelangsungan bangsa.
2. Bertahan lama: Pramuka itu sehat jasmani dan rohani, kuat, serta ulet.
3. Tumbuh di mana saja: Pramuka mampu beradaptasi dalam masyarakat di kondisi apa pun.
4. Tumbuh menjulang ke atas: Pramuka memiliki cita-cita yang tinggi dan lurus.
5. Akar yang kuat: Pramuka berpegang teguh pada dasar-dasar dan keyakinan yang kuat.
6. Pohon serbaguna: Pramuka berguna bagi nusa, bangsa, agama, dan sesama manusia.''',
    ),

    /// BAGIAN 2: SEJARAH DUNIA
    ArtikelPramuka(
      id: "dunia_1",
      kategori: "Sejarah Dunia",
      judul: "Bapak Pandu Dunia (Baden-Powell)",
      icon: Icons.public_rounded,
      konten: '''Nama lengkapnya adalah Robert Stephenson Smyth Baden-Powell of Gilwell. Beliau lahir pada 22 Februari 1857 di London, Inggris, dan wafat pada 8 Januari 1941 di Nyeri, Kenya.

Sebelum 1900, negara-negara Eropa mengalami revolusi industri pesat. Banyak anak muda hidup di kota besar tanpa pendidikan karakter, memicu kenakalan remaja. 

Sebagai perwira tentara yang pernah bertugas di India dan Afrika Selatan, Baden-Powell menyadari bahwa pemuda memiliki potensi luar biasa jika diberi tanggung jawab dan pendidikan karakter di alam bebas (keterampilan bertahan hidup, pengamatan, dan kepemimpinan). Hal ini awalnya ia tulis dalam buku kemiliteran "Aids to Scouting".''',
    ),
    ArtikelPramuka(
      id: "dunia_2",
      kategori: "Sejarah Dunia",
      judul: "Brownsea & Lahirnya Kepanduan",
      icon: Icons.landscape_rounded,
      konten: '''• 1 - 8 Agustus 1907: Baden-Powell mengadakan perkemahan eksperimental di Pulau Brownsea, Inggris, dengan 22 anak laki-laki dari berbagai kelas sosial. Mereka diajarkan memasak, mendirikan tenda, dan navigasi. Perkemahan ini adalah titik awal lahirnya Gerakan Kepanduan Dunia.

• 1908: Baden-Powell menerbitkan buku "Scouting for Boys". Buku ini sangat laris dan memicu berdirinya organisasi kepanduan (Boy Scout) di berbagai negara secara mandiri.

• 1910: Beliau pensiun dari militer untuk fokus membangun Gerakan Kepanduan.
• 1912: Dibentuk "Girl Guides" (Pandu Puteri) bersama adiknya, Agnes Baden-Powell.
• 1916: Dibentuk "Cub Scout" (Siaga) yang terinspirasi dari buku The Jungle Book.''',
    ),
    ArtikelPramuka(
      id: "dunia_3",
      kategori: "Sejarah Dunia",
      judul: "Jambore Dunia Pertama & WOSM",
      icon: Icons.festival_rounded,
      konten: '''Pada tahun 1920, diselenggarakan Jambore Dunia Pertama di Olympia Hall, London, Inggris. Acara ini dihadiri oleh ribuan pandu dari 34 negara.

Pada malam penutupan jambore tersebut, Baden-Powell diangkat secara aklamasi sebagai "Chief Scout of the World" (Bapak Pandu Sedunia).

Untuk menaungi seluruh organisasi kepanduan di seluruh dunia, dibentuklah WOSM (World Organization of the Scout Movement). Organisasi ini bertujuan menyatukan visi, mempererat persaudaraan internasional, dan mengembangkan kepemimpinan pemuda lintas negara.''',
    ),

    /// BAGIAN 3: SEJARAH INDONESIA
    ArtikelPramuka(
      id: "indo_1",
      kategori: "Sejarah Indonesia",
      judul: "Masa Penjajahan Belanda & Jepang",
      icon: Icons.history_edu_rounded,
      konten: '''• Masa Hindia Belanda (1912): Gerakan kepanduan masuk ke Indonesia melalui organisasi Belanda bernama NIPV. Melihat manfaatnya, tokoh nasional (seperti S.P. Mangkunegara VII) mendirikan organisasi bumiputera pertama bernama Javaansche Padvinders Organisatie (JPO). Setelah itu, menjamur organisasi lain seperti Hizbul Wathan (HW), SIAP, dan Pandu Rakyat Indonesia.

• Masa Pendudukan Jepang (1942-1945): Jepang melarang berdirinya organisasi kepanduan dan meleburnya ke dalam organisasi militer Jepang seperti Seinendan dan Keibodan. Meski begitu, para pandu Indonesia tetap menjalankan kegiatannya secara sembunyi-sembunyi demi menjaga semangat nasionalisme.''',
    ),
    ArtikelPramuka(
      id: "indo_2",
      kategori: "Sejarah Indonesia",
      judul: "Lahirnya Gerakan Pramuka (1961)",
      icon: Icons.flag_rounded,
      konten: '''Pasca kemerdekaan, muncul puluhan organisasi kepanduan yang terpecah belah berdasarkan politik dan agama. Untuk menyatukannya, Presiden Soekarno mengambil tindakan tegas:

• 9 Maret 1961: Presiden membubarkan semua organisasi kepanduan dan meleburnya menjadi satu organisasi.
• 20 Mei 1961: Diterbitkan Keppres No. 238 Tahun 1961 yang menetapkan Gerakan Pramuka sebagai satu-satunya wadah kepanduan di Indonesia.
• 14 Agustus 1961: Gerakan Pramuka diperkenalkan secara resmi kepada masyarakat luas melalui penganugerahan Panji Gerakan Pramuka. Tanggal ini diperingati sebagai Hari Pramuka Nasional.''',
    ),
    ArtikelPramuka(
      id: "indo_3",
      kategori: "Sejarah Indonesia",
      judul: "Bapak Pramuka Indonesia",
      icon: Icons.star_rounded,
      konten: '''Tokoh utama di balik kesuksesan Gerakan Pramuka Indonesia adalah Sri Sultan Hamengkubuwono IX. Beliau menjabat sebagai Ketua Kwartir Nasional pertama selama empat periode berturut-turut (1961–1974).

Atas jasa-jasanya dalam menyatukan puluhan organisasi kepanduan dan membawa nama Pramuka Indonesia harum hingga ke tingkat dunia, Sri Sultan Hamengkubuwono IX dianugerahi gelar sebagai Bapak Pramuka Indonesia. Beliau juga mempopulerkan istilah "Pramuka" yang terinspirasi dari kata "Poromuko" (pasukan terdepan dalam keraton).''',
    ),

    /// BAGIAN 4: KODE KEHORMATAN & GOLONGAN
    ArtikelPramuka(
      id: "kode_1",
      kategori: "Struktur & Aturan",
      judul: "Golongan & Tanda Kecakapan",
      icon: Icons.groups_rounded,
      konten: '''Golongan dalam Pramuka berdasarkan usia:
1. Siaga (7 - 10 tahun). Satuan terkecil: Barung.
2. Penggalang (11 - 15 tahun). Satuan terkecil: Regu.
3. Penegak (16 - 20 tahun). Satuan terkecil: Sangga.
4. Pandega (21 - 25 tahun). Satuan terkecil: Reka.

Sistem Tanda Kecakapan:
• SKU (Syarat Kecakapan Umum): Wajib dipenuhi. Jika lulus mendapat TKU (Tanda Kecakapan Umum).
• SKK (Syarat Kecakapan Khusus): Pilihan sesuai bakat (memasak, menjahit, dll). Lulus mendapat TKK.
• Pramuka Garuda: Tingkatan/penghargaan tertinggi di setiap golongan.''',
    ),
    ArtikelPramuka(
      id: "kode_2",
      kategori: "Struktur & Aturan",
      judul: "Tri Satya & Dasa Darma",
      icon: Icons.menu_book_rounded,
      konten: '''TRI SATYA (Tiga Janji):
Demi kehormatanku aku berjanji akan bersungguh-sungguh:
1. Menjalankan kewajibanku terhadap Tuhan, Negara Kesatuan Republik Indonesia dan mengamalkan Pancasila.
2. Menolong sesama hidup dan mempersiapkan diri / ikut serta membangun masyarakat.
3. Menepati Dasa Darma.

DASA DARMA PRAMUKA:
Pramuka itu:
1. Takwa kepada Tuhan Yang Maha Esa.
2. Cinta alam dan kasih sayang sesama manusia.
3. Patriot yang sopan dan kesatria.
4. Patuh dan suka bermusyawarah.
5. Rela menolong dan tabah.
6. Rajin, terampil, dan gembira.
7. Hemat, cermat, dan bersahaja.
8. Disiplin, berani, dan setia.
9. Bertanggung jawab dan dapat dipercaya.
10. Suci dalam pikiran, perkataan, dan perbuatan.''',
    ),

    /// BAGIAN 5: SCOUT SKILLS
    ArtikelPramuka(
      id: "skill_1",
      kategori: "Teknik Kepramukaan",
      judul: "Tali Temali, Pionering & Sandi",
      icon: Icons.explore_rounded,
      konten: '''• Tali-temali & Pionering: Pramuka dituntut mahir menggunakan tali. Simpul dasar seperti Simpul Mati (menyambung dua tali yang sama besar), Simpul Pangkal (mengawali ikatan), dan Simpul Jangkar sangat penting. Pionering adalah aplikasi simpul tersebut untuk membuat bangunan darurat seperti menara, jembatan, atau tiang bendera menggunakan tongkat bambu.

• Sandi & Isyarat: Komunikasi rahasia di alam bebas. Meliputi Sandi Morse (menggunakan titik & garis ciptaan Samuel Morse yang dikirim lewat peluit/cahaya), Sandi Semaphore (menggunakan sepasang bendera 45x45 cm), Sandi Kotak, dan Sandi Rumput.

• Navigasi Darat: Keterampilan menentukan arah menggunakan kompas, membaca peta topografi, menaksir lebar sungai, menaksir tinggi pohon, dan membaca tanda alam (cuaca, jejak bintang).''',
    ),
  ];
}