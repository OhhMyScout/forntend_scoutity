import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/kotak2_challenge_controller.dart';

class Kotak2ChallengeView
    extends GetView<Kotak2ChallengeController> {
  const Kotak2ChallengeView({super.key});

  static const Color primaryColor =
      Color(0xFF361F1A);

  static const Color secondaryColor =
      Color(0xFF7D562D);

  static const Color backgroundColor =
      Color(0xFFFCF9F4);

  static const Color surfaceColor =
      Color(0xFFF6F3EE);

  static const Color textSecondary =
      Color(0xFF504442);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),

        title: const Text(
          'Tebak Sandi Kotak 2',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.leaderboard,
              color: primaryColor,
            ),
          ),
        ],
      ),

      body: Stack(
        children: [

          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              180,
            ),

            child: Column(
              children: [

                /// STATUS
                Column(
                  children: [

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        const Text(
                          'Level 12 • Hutan Pinus',
                          style: TextStyle(
                            color: textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Obx(
                          () => Text(
                            '00:${controller.timeLeft.value}',
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(100),

                      child: LinearProgressIndicator(
                        value: 0.65,
                        minHeight: 8,
                        backgroundColor: surfaceColor,
                        valueColor:
                            const AlwaysStoppedAnimation(
                          Color(0xFFFFCA98),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// MAIN CARD
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Expanded(
                      flex: 2,
                      child: buildMainCard(),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: buildHintCard(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// KEYBOARD
          Align(
            alignment: Alignment.bottomCenter,
            child: buildKeyboard(),
          ),
        ],
      ),
    );
  }

  Widget buildMainCard() {
    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        children: [

          const Icon(
            Icons.architecture,
            size: 90,
            color: Color(0x22361F1A),
          ),

          const SizedBox(height: 20),

          /// SYMBOL
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [

              Container(
                width: 100,
                height: 100,

                decoration: BoxDecoration(
                  border: Border.all(
                    color: primaryColor,
                    width: 3,
                  ),
                ),

                child: Stack(
                  children: [

                    Positioned(
                      top: 10,
                      right: 10,
                      child: dot(),
                    ),

                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: dot(),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 18),

              Container(
                width: 100,
                height: 100,

                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: primaryColor,
                      width: 3,
                    ),
                    bottom: BorderSide(
                      color: primaryColor,
                      width: 3,
                    ),
                  ),
                ),

                child: Center(
                  child: dot(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            'Terjemahkan Simbol Ini',
            style: TextStyle(
              color: textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Obx(
            () => Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: controller.answer.value
                  .split('')
                  .map(
                    (e) => buildAnswerBox(e),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHintCard() {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(24),
      ),

      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Text(
            'Petunjuk',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 12),

          Text(
            'Sandi Kotak 2 menggunakan satu kotak untuk tiga huruf. Perhatikan jumlah titik untuk menentukan posisi huruf.',
            style: TextStyle(
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildKeyboard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        12,
        18,
        12,
        30,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          buildKeyboardRow(
            controller.keyboardRows[0].split(''),
          ),

          const SizedBox(height: 10),

          buildKeyboardRow(
            controller.keyboardRows[1].split(''),
          ),

          const SizedBox(height: 10),

          Row(
            children: [

              Expanded(
                flex: 2,
                child: buildActionButton(
                  icon: Icons.backspace,
                  color: const Color(0xFFFFDAD6),
                  textColor: Colors.red,
                  onTap: controller.removeLetter,
                ),
              ),

              const SizedBox(width: 6),

              ...controller.keyboardRows[2]
                  .split('')
                  .map(
                    (e) => Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 3,
                        ),

                        child: buildKey(e),
                      ),
                    ),
                  ),

              const SizedBox(width: 6),

              Expanded(
                flex: 2,
                child: buildActionButton(
                  label: 'CEK',
                  color: primaryColor,
                  textColor: Colors.white,
                  onTap: controller.checkAnswer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildKeyboardRow(List<String> letters) {
    return Row(
      children: letters
          .map(
            (e) => Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 3,
                ),

                child: buildKey(e),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget buildKey(String letter) {
    return GestureDetector(
      onTap: () {
        controller.addLetter(letter);
      },

      child: Container(
        height: 50,

        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
        ),

        child: Center(
          child: Text(
            letter,
            style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActionButton({
    IconData? icon,
    String? label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 50,

        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),

        child: Center(
          child: icon != null
              ? Icon(
                  icon,
                  color: textColor,
                )
              : Text(
                  label ?? '',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildAnswerBox(String letter) {
    return Container(
      width: 55,
      height: 65,
      margin: const EdgeInsets.symmetric(
        horizontal: 6,
      ),

      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5BEB5),
            width: 3,
          ),
        ),
      ),

      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget dot() {
    return Container(
      width: 12,
      height: 12,

      decoration: const BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
      ),
    );
  }
}