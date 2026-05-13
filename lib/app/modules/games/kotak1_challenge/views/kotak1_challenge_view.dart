import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/kotak1_challenge_controller.dart';

class Kotak1ChallengeView extends GetView<Kotak1ChallengeController> {
  const Kotak1ChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFFCF9F4);
    const primary = Color(0xFF361F1A);
    const secondary = Color(0xFF7D562D);

    return Scaffold(
      backgroundColor: background,

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE5E2DD),
            ),
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _BottomItem(
                icon: Icons.sports_esports,
                label: 'Hub',
              ),
              _BottomItem(
                icon: Icons.school,
                label: 'Training',
                active: true,
              ),
              _BottomItem(
                icon: Icons.visibility,
                label: 'AI Detect',
              ),
              _BottomItem(
                icon: Icons.person,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildHud(),

                    const SizedBox(height: 24),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool mobile = constraints.maxWidth < 900;

                        return mobile
                            ? Column(
                                children: [
                                  _buildQuestionCard(),

                                  const SizedBox(height: 20),

                                  _buildAnswerSection(),
                                ],
                              )
                            : Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: _buildQuestionCard(),
                                  ),

                                  const SizedBox(width: 24),

                                  Expanded(
                                    flex: 5,
                                    child: _buildAnswerSection(),
                                  ),
                                ],
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF361F1A),
            ),
          ),

          const SizedBox(width: 8),

          const Text(
            'Tebak Sandi Kotak 1',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF361F1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHud() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
                () => Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'KEMAJUAN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF827471),
                      ),
                    ),

                    const SizedBox(height: 8),

                    LinearProgressIndicator(
                      value:
                          controller.currentQuestion.value /
                              controller.totalQuestion.value,
                      minHeight: 10,
                      borderRadius:
                          BorderRadius.circular(100),
                      backgroundColor:
                          const Color(0xFFF0EDE9),
                      valueColor:
                          const AlwaysStoppedAnimation(
                        Color(0xFFFFCA98),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${controller.currentQuestion.value} / ${controller.totalQuestion.value}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF361F1A),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 16),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Obx(
                () => Row(
                  children: [
                    const Icon(
                      Icons.timer,
                      color: Color(0xFF361F1A),
                      size: 32,
                    ),

                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SISA WAKTU',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF827471),
                          ),
                        ),

                        Text(
                          '00:${controller.timeLeft.value}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF361F1A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            'Terjemahkan Simbol Ini',
            style: TextStyle(
              color: Color(0xFF827471),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Sandi Kotak 1',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF361F1A),
            ),
          ),

          const SizedBox(height: 32),

          Container(
            width: 250,
            height: 250,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F3EE),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE5E2DD),
                width: 4,
              ),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF361F1A),
                        width: 6,
                      ),
                    ),
                  ),

                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF361F1A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Hint: Perhatikan titik di tengah kotak.',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color(0xFF504442),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSection() {
    final answers = [
      'HURUF E',
      'HURUF F',
      'HURUF G',
      'HURUF H',
    ];

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: answers.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 3.5,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final option =
                String.fromCharCode(65 + index);

            return Obx(
              () {
                final selected =
                    controller.selectedAnswer.value ==
                        option;

                return GestureDetector(
                  onTap: () =>
                      controller.selectAnswer(option),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFFFCA98)
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF7D562D)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              const Color(0xFFF0EDE9),
                          child: Text(
                            option,
                            style: const TextStyle(
                              color:
                                  Color(0xFF361F1A),
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Text(
                          answers[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),

        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bantuan Pramuka',
                  style: TextStyle(
                    color: Color(0xFF361F1A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.useHint,
                      icon: const Icon(
                        Icons.lightbulb,
                      ),
                      label: const Text(
                        'Petunjuk (-50)',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFF6F3EE),
                        foregroundColor:
                            const Color(0xFF361F1A),
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          controller.useFiftyFifty,
                      icon: const Icon(
                        Icons.extension,
                      ),
                      label: const Text(
                        '50/50 (-100)',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFF6F3EE),
                        foregroundColor:
                            const Color(0xFF361F1A),
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                const Color(0xFF4E342E).withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  const Color(0xFF361F1A).withOpacity(0.1),
            ),
          ),
          child: const Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info,
                color: Color(0xFF361F1A),
              ),

              SizedBox(width: 12),

              Expanded(
                child: Text(
                  'Ingat: Sandi Kotak 1 menggunakan grid # dan X. Huruf kedua dalam setiap ruang ditandai dengan sebuah titik.',
                  style: TextStyle(
                    color: Color(0xFF504442),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _BottomItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFFFCA98)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: active
                ? const Color(0xFF7A532A)
                : const Color(0xFF504442),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: active
                  ? const Color(0xFF7A532A)
                  : const Color(0xFF504442),
            ),
          ),
        ],
      ),
    );
  }
}