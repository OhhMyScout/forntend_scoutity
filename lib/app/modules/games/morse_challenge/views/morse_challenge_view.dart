// lib/app/modules/games/morse_challenge/views/morse_challenge_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/theme.dart';
import '../controllers/morse_challenge_controller.dart';

class MorseChallengeView
    extends GetView<MorseChallengeController> {
  const MorseChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F4),

      body: SafeArea(
        child: Obx(
          () {
            return Column(
              children: [
                _buildAppBar(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      12,
                      24,
                      40,
                    ),
                    child: Column(
                      children: [
                        _buildProgress(),

                        const SizedBox(height: 28),

                        _buildChallengeCard(),

                        const SizedBox(height: 40),

                        _buildControlButtons(),

                        const SizedBox(height: 24),

                        _buildInputButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // APP BAR
  // =========================================================

  Widget _buildAppBar() {
    return Container(
      height: 70,
      padding:
          const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.onBack,
            child: const Icon(
              Icons.arrow_back,
              color: AppTheme.primary,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Text(
              "Sandi Morse",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),

          // =====================================================
          // MINI MODE
          // =====================================================

          _buildMiniModeBadge(),

          // =====================================================
          // MINI TIMER
          // =====================================================

          if (controller.gameMode.value == "hard")
            ...[
              const SizedBox(width: 8),
              _buildMiniTimer(),
            ],
        ],
      ),
    );
  }

  // =========================================================
  // MINI MODE BADGE
  // =========================================================

  Widget _buildMiniModeBadge() {
    String mode = "Easy";
    Color color = Colors.green;

    if (controller.gameMode.value == "normal") {
      mode = "Normal";
      color = Colors.orange;
    }

    if (controller.gameMode.value == "hard") {
      mode = "Hard";
      color = Colors.red;
    }

    return GestureDetector(
      onTap: controller.showModeDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius:
              BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flash_on_rounded,
              size: 15,
              color: color,
            ),

            const SizedBox(width: 4),

            Text(
              mode,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // MINI TIMER
  // =========================================================

  Widget _buildMiniTimer() {
    final value = controller.timer.value;

    Color timerColor = Colors.green;

    if (value <= 20) {
      timerColor = Colors.orange;
    }

    if (value <= 10) {
      timerColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: timerColor.withValues(
          alpha: 0.12,
        ),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: timerColor.withValues(
            alpha: 0.25,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 15,
            color: timerColor,
          ),

          const SizedBox(width: 4),

          Text(
            "${controller.timer.value}s",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: timerColor,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PROGRESS
  // =========================================================

  Widget _buildProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Soal ${controller.currentQuestion.value} / ${controller.totalQuestion.value}",
              style: const TextStyle(
                color: Color(0xFF827471),
                fontWeight: FontWeight.w600,
              ),
            ),

            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary
                        .withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Text(
                    "+${controller.pointPerQuestion}",
                    style: const TextStyle(
                      color: AppTheme.secondary,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  "Score ${controller.score.value}",
                  style: const TextStyle(
                    color: AppTheme.secondary,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius:
              BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: controller.progress,
            minHeight: 8,
            backgroundColor:
                const Color(0xFFEBE8E3),
            valueColor:
                const AlwaysStoppedAnimation(
              AppTheme.secondary,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // CHALLENGE CARD
  // =========================================================

  Widget _buildChallengeCard() {
    final word = controller.currentWord.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(28),
        border: Border.all(
          color: const Color(
            0xFFD4C3BF,
          ).withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF4E342E,
            ).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'TERJEMAHKAN KATA',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 4,
              fontWeight: FontWeight.w700,
              color: Color(0xFF827471),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            word,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
              color: AppTheme.primary,
            ),
          ),

          const SizedBox(height: 40),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: List.generate(
              word.length,
              (index) {
                final letter = word[index];

                final morse =
                    controller.morseMap[letter] ??
                        '';

                final isActive =
                    index ==
                    controller
                        .currentLetterIndex
                        .value;

                final isDone =
                    index <
                    controller
                        .currentLetterIndex
                        .value;

                return _buildLetter(
                  letter: letter,
                  morse: morse,
                  active: isActive,
                  done: isDone,
                );
              },
            ),
          ),

          const SizedBox(height: 30),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(
              vertical: 18,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: Text(
              controller.currentInput.value.isEmpty
                  ? ""
                  : controller.currentInput.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // LETTER
  // =========================================================

  Widget _buildLetter({
    required String letter,
    required String morse,
    required bool active,
    required bool done,
  }) {
    return Column(
      children: [
        controller.showHint.value
            ? Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: List.generate(
                  morse.length,
                  (index) {
                    final symbol = morse[index];

                    Color color;

                    if (done) {
                      color = Colors.green;
                    } else if (active) {
                      final typed =
                          controller
                              .currentInput
                              .value;

                      if (index <
                          typed.length) {
                        if (typed[index] ==
                            symbol) {
                          color = Colors.green;
                        } else {
                          color = Colors.red;
                        }
                      } else {
                        color =
                            AppTheme.secondary;
                      }
                    } else {
                      color = const Color(
                        0xFFE5E2DD,
                      );
                    }

                    if (symbol == '.') {
                      return Container(
                        width: 10,
                        height: 10,
                        margin:
                            const EdgeInsets.only(
                          right: 4,
                        ),
                        decoration:
                            BoxDecoration(
                          color: color,
                          shape:
                              BoxShape.circle,
                        ),
                      );
                    }

                    return Container(
                      width: 22,
                      height: 8,
                      margin:
                          const EdgeInsets.only(
                        right: 4,
                      ),
                      decoration:
                          BoxDecoration(
                        color: color,
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container(
                width: 70,
                height: 12,
                decoration: BoxDecoration(
                  color: done
                      ? Colors.green
                      : active
                          ? AppTheme.secondary
                          : const Color(
                              0xFFE5E2DD,
                            ),
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
              ),

        const SizedBox(height: 14),

        Container(
          padding: active
              ? const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                )
              : EdgeInsets.zero,
          decoration: active
              ? BoxDecoration(
                  color: AppTheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(8),
                )
              : null,
          child: Text(
            letter,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: done
                  ? Colors.green
                  : active
                      ? AppTheme.secondary
                      : const Color(
                          0xFF827471,
                        ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // CONTROL BUTTONS
  // =========================================================

  Widget _buildControlButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: controller.openMorseTable,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F3EE),
                borderRadius:
                    BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(
                    0xFFD4C3BF,
                  ).withValues(alpha: 0.5),
                ),
              ),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book_outlined),

                  SizedBox(width: 8),

                  Text(
                    'Tabel Morse',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: GestureDetector(
            onTap: controller.deleteInput,
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F3EE),
                borderRadius:
                    BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(
                    0xFFD4C3BF,
                  ).withValues(alpha: 0.5),
                ),
              ),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.backspace_outlined,
                    color: Colors.red,
                  ),

                  SizedBox(width: 8),

                  Text(
                    'Hapus',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // INPUT BUTTONS
  // =========================================================

  Widget _buildInputButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: controller.inputDot,
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius:
                    BorderRadius.circular(30),
              ),
              child: const Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor:
                        Colors.white,
                  ),

                  SizedBox(height: 14),

                  Text(
                    'DOT',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 24),

        Expanded(
          child: GestureDetector(
            onTap: controller.inputDash,
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius:
                    BorderRadius.circular(30),
              ),
              child: const Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 56,
                    height: 14,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 14),

                  Text(
                    'DASH',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}