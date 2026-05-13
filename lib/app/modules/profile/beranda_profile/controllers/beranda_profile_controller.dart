import 'package:get/get.dart';

class BerandaProfileController extends GetxController {
  // Data Profil Observables
  var name = "Aditya Pratama".obs;
  var email = "aditya.pratama@scoutify.id".obs;
  var province = "Jawa Barat".obs;
  var gugusDepan = "04.125".obs;
  var joinDate = "12 Maret 2023".obs;

  // // Action: Ganti Foto Profil
  void changeProfilePhoto() {
    print("Membuka galeri untuk ganti foto...");
  }

  // // Action: Edit Profil
  void editProfile() {
    print("Navigasi ke halaman edit profil");
  }

  // // Action: Pengaturan
  void openSettings() {
    print("Navigasi ke halaman pengaturan");
  }

  // // Action: Upgrade Pro
  void upgradeToPro() {
    print("Proses transaksi Scoutify Pro");
  }

  // // Action: Keluar
  void logout() {
    print("Menghapus sesi dan kembali ke login");
  }
}