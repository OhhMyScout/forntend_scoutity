import 'package:get/get.dart';

import '../modules/deteksi/alfabet_semaphore/bindings/alfabet_semaphore_binding.dart';
import '../modules/deteksi/alfabet_semaphore/views/alfabet_semaphore_view.dart';
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
import '../modules/deteksi/semaphore_detect/bindings/semaphore_detect_binding.dart';
import '../modules/deteksi/semaphore_detect/views/semaphore_detect_view.dart';
import '../modules/edukasi/alfabet_morse/bindings/alfabet_morse_binding.dart';
import '../modules/edukasi/alfabet_morse/views/alfabet_morse_view.dart';
import '../modules/edukasi/beranda_edukasi/bindings/beranda_edukasi_binding.dart';
import '../modules/edukasi/beranda_edukasi/views/beranda_edukasi_view.dart';
import '../modules/edukasi/detail_morse/bindings/detail_morse_binding.dart';
import '../modules/edukasi/detail_morse/views/detail_morse_view.dart';
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
import '../modules/survival/kompas/bindings/kompas_binding.dart';
import '../modules/survival/kompas/views/kompas_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      children: [
        GetPage(
          name: _Paths.REGISTER,
          page: () => const RegisterView(),
          binding: RegisterBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.BERANDA_EDUKASI,
      page: () => const BerandaEdukasiView(),
      binding: BerandaEdukasiBinding(),
    ),
    GetPage(
      name: _Paths.BERANDA_GAME,
      page: () => const BerandaGameView(),
      binding: BerandaGameBinding(),
    ),
    GetPage(
      name: _Paths.BERANDA_SURVIVAL,
      page: () => const BerandaSurvivalView(),
      binding: BerandaSurvivalBinding(),
    ),
    GetPage(
      name: _Paths.BERANDA_PROFILE,
      page: () => const BerandaProfileView(),
      binding: BerandaProfileBinding(),
    ),
    GetPage(
      name: _Paths.MORSE_CHALLENGE,
      page: () => const MorseChallengeView(),
      binding: MorseChallengeBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_MORSE,
      page: () => const DetailMorseView(),
      binding: DetailMorseBinding(),
    ),
    GetPage(
      name: _Paths.ALFABET_MORSE,
      page: () => const AlfabetMorseView(),
      binding: AlfabetMorseBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      children: [
        GetPage(
          name: _Paths.SETTINGS,
          page: () => const SettingsView(),
          binding: SettingsBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.FEEDBACK,
      page: () => const FeedbackView(),
      binding: FeedbackBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: _Paths.KOMPAS,
      page: () => const KompasView(),
      binding: KompasBinding(),
    ),
    GetPage(
      name: _Paths.LEADERBOARD,
      page: () => const LeaderboardView(),
      binding: LeaderboardBinding(),
    ),
    GetPage(
      name: _Paths.KOTAK2_CHALLENGE,
      page: () => const Kotak2ChallengeView(),
      binding: Kotak2ChallengeBinding(),
    ),
    GetPage(
      name: _Paths.KOTAK1_CHALLENGE,
      page: () => const Kotak1ChallengeView(),
      binding: Kotak1ChallengeBinding(),
    ),
    GetPage(
      name: _Paths.SEMAPHORE_DETECT,
      page: () => const SemaphoreDetectView(),
      binding: SemaphoreDetectBinding(),
    ),
    GetPage(
      name: _Paths.ALFABET_SEMAPHORE,
      page: () => const AlfabetSemaphoreView(),
      binding: AlfabetSemaphoreBinding(),
    ),
  ];
}
