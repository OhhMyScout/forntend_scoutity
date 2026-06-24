import 'package:get/get.dart';

import '../modules/auth/auth_middleware.dart';
import '../modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/forgot_password_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/otp/bindings/otp_binding.dart';
import '../modules/auth/otp/views/otp_view.dart';
import '../modules/auth/privacy_policy/bindings/privacy_policy_binding.dart';
import '../modules/auth/privacy_policy/views/privacy_policy_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/auth/reset_password/bindings/reset_password_binding.dart';
import '../modules/auth/reset_password/views/reset_password_view.dart';
import '../modules/berita/beranda_berita/bindings/beranda_berita_binding.dart';
import '../modules/berita/beranda_berita/views/beranda_berita_view.dart';
import '../modules/berita/tabel_berita_paling_populer/bindings/tabel_berita_paling_populer_binding.dart';
import '../modules/berita/tabel_berita_paling_populer/views/tabel_berita_paling_populer_view.dart';
import '../modules/berita/tabel_berita_provinsi/bindings/tabel_berita_provinsi_binding.dart';
import '../modules/berita/tabel_berita_provinsi/views/tabel_berita_provinsi_view.dart';
import '../modules/deteksi/alfabet_semaphore/bindings/alfabet_semaphore_binding.dart';
import '../modules/deteksi/alfabet_semaphore/views/alfabet_semaphore_view.dart';
import '../modules/deteksi/semaphore_detect/bindings/semaphore_detect_binding.dart';
import '../modules/deteksi/semaphore_detect/views/semaphore_detect_view.dart';
import '../modules/edukasi/alfabet_morse/bindings/alfabet_morse_binding.dart';
import '../modules/edukasi/alfabet_morse/views/alfabet_morse_view.dart';
import '../modules/edukasi/beranda_edukasi/bindings/beranda_edukasi_binding.dart';
import '../modules/edukasi/beranda_edukasi/views/beranda_edukasi_view.dart';
import '../modules/edukasi/detail_morse/bindings/detail_morse_binding.dart';
import '../modules/edukasi/detail_morse/views/detail_morse_view.dart';
import '../modules/edukasi/sejarah_pramuka/bindings/sejarah_pramuka_binding.dart';
import '../modules/edukasi/sejarah_pramuka/views/sejarah_pramuka_view.dart';
import '../modules/games/beranda_game/bindings/beranda_game_binding.dart';
import '../modules/games/beranda_game/views/beranda_game_view.dart';
import '../modules/games/kotak1_challenge/bindings/kotak1_challenge_binding.dart';
import '../modules/games/kotak1_challenge/views/kotak1_challenge_view.dart';
import '../modules/games/kotak2_challenge/bindings/kotak2_challenge_binding.dart';
import '../modules/games/kotak2_challenge/views/kotak2_challenge_view.dart';
import '../modules/games/leaderboard/bindings/leaderboard_binding.dart';
import '../modules/games/leaderboard/views/leaderboard_view.dart';
import '../modules/games/morse_challenge/bindings/morse_challenge_binding.dart';
import '../modules/games/morse_challenge/views/morse_challenge_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile/beranda_profile/bindings/beranda_profile_binding.dart';
import '../modules/profile/beranda_profile/views/beranda_profile_view.dart';
import '../modules/profile/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/profile/edit_profile/views/edit_profile_view.dart';
import '../modules/profile/feedback/bindings/feedback_binding.dart';
import '../modules/profile/feedback/views/feedback_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/survival/beranda_survival/bindings/beranda_survival_binding.dart';
import '../modules/survival/beranda_survival/views/beranda_survival_view.dart';
import '../modules/survival/bertahan_hidup/bindings/bertahan_hidup_binding.dart';
import '../modules/survival/bertahan_hidup/views/bertahan_hidup_view.dart';
import '../modules/survival/detail_tali/bindings/detail_tali_binding.dart';
import '../modules/survival/detail_tali/views/detail_tali_view.dart';
import '../modules/survival/kompas/bindings/kompas_binding.dart';
import '../modules/survival/kompas/views/kompas_view.dart';
import '../modules/survival/menu_p3k/beranda_p3k/bindings/beranda_p3k_binding.dart';
import '../modules/survival/menu_p3k/beranda_p3k/views/beranda_p3k_view.dart';
import '../modules/survival/menu_p3k/detail_p3k/bindings/detail_p3k_binding.dart';
import '../modules/survival/menu_p3k/detail_p3k/views/detail_p3k_view.dart';
import '../modules/survival/menu_p3k/p3k_checklist/bindings/p3k_checklist_binding.dart';
import '../modules/survival/menu_p3k/p3k_checklist/views/p3k_checklist_view.dart';
import '../modules/survival/panduan_tenda/bindings/panduan_tenda_binding.dart';
import '../modules/survival/panduan_tenda/views/panduan_tenda_view.dart';
import '../modules/survival/sinyal_darurat/bindings/sinyal_darurat_binding.dart';
import '../modules/survival/sinyal_darurat/views/sinyal_darurat_view.dart';
import '../modules/survival/tali_temali/bindings/tali_temali_binding.dart';
import '../modules/survival/tali_temali/views/tali_temali_view.dart';
import '../modules/uji_sku/bindings/uji_sku_binding.dart';
import '../modules/uji_sku/views/uji_sku_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
      children: [
        GetPage(
          name: _Paths.REGISTER,
          page: () => RegisterView(),
          binding: RegisterBinding(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 100),
        ),
      ],
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.BERANDA_EDUKASI,
      page: () => const BerandaEdukasiView(),
      binding: BerandaEdukasiBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.BERANDA_GAME,
      page: () => const BerandaGameView(),
      binding: BerandaGameBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.BERANDA_SURVIVAL,
      page: () => const BerandaSurvivalView(),
      binding: BerandaSurvivalBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.BERANDA_PROFILE,
      page: () => const BerandaProfileView(),
      binding: BerandaProfileBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.MORSE_CHALLENGE,
      page: () => const MorseChallengeView(),
      binding: MorseChallengeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.DETAIL_MORSE,
      page: () => const DetailMorseView(),
      binding: DetailMorseBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.ALFABET_MORSE,
      page: () => const AlfabetMorseView(),
      binding: AlfabetMorseBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
      children: [
        GetPage(
          name: _Paths.SETTINGS,
          page: () => const SettingsView(),
          binding: SettingsBinding(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 100),
        ),
      ],
    ),
    GetPage(
      name: _Paths.FEEDBACK,
      page: () => const FeedbackView(),
      binding: FeedbackBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.LEADERBOARD,
      page: () => const LeaderboardView(),
      binding: LeaderboardBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.KOTAK2_CHALLENGE,
      page: () => const Kotak2ChallengeView(),
      binding: Kotak2ChallengeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.KOTAK1_CHALLENGE,
      page: () => const Kotak1ChallengeView(),
      binding: Kotak1ChallengeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.SEMAPHORE_DETECT,
      page: () => const SemaphoreDetectView(),
      binding: SemaphoreDetectBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.ALFABET_SEMAPHORE,
      page: () => const AlfabetSemaphoreView(),
      binding: AlfabetSemaphoreBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.TALI_TEMALI,
      page: () => const TaliTemaliView(),
      binding: TaliTemaliBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.PANDUAN_TENDA,
      page: () => const PanduanTendaView(),
      binding: PanduanTendaBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.BERTAHAN_HIDUP,
      page: () => const BertahanHidupView(),
      binding: BertahanHidupBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.KOMPAS,
      page: () => const KompasView(),
      binding: KompasBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.BERANDA_P3K,
      page: () => const BerandaP3KView(),
      binding: BerandaP3KBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.DETAIL_P3K,
      page: () => const DetailP3KView(),
      binding: DetailP3KBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.SINYAL_DARURAT,
      page: () => const SinyalDaruratView(),
      binding: SinyalDaruratBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.DETAIL_TALI,
      page: () => const DetailTaliView(),
      binding: DetailTaliBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.P3K_CHECKLIST,
      page: () => const P3KChecklistView(),
      binding: P3KChecklistBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.BERANDA_BERITA,
      page: () => const BerandaBeritaView(),
      binding: BerandaBeritaBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.TABEL_BERITA_PROVINSI,
      page: () => const TabelBeritaProvinsiView(),
      binding: TabelBeritaProvinsiBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.TABEL_BERITA_PALING_POPULER,
      page: () => const TabelBeritaPalingPopulerView(),
      binding: TabelBeritaPalingPopulerBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.SEJARAH_PRAMUKA,
      page: () => const SejarahPramukaView(),
      binding: SejarahPramukaBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 100),
    ),
    GetPage(
      name: _Paths.UJI_SKU,
      page: () => const UjiSkuView(),
      binding: UjiSkuBinding(),
    ),
  ];
}
