import 'package:get/get.dart';

class LeaderboardController extends GetxController {

  final myPoint = 1250.obs;
  final myRank = 12.obs;

  final topThree = [
    {
      'name': 'Adit Pratama',
      'point': '2.140',
      'rank': 2,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDlrlo4Ao3IwQpvqPYlPT0UG_ZmWf9mxFUYsShllwzTrCqOpAXfeJGhRJuzshAIhq56nd0XAYPpasmm51YNYPPdOTwoPA6P-3O02oUBApoNnaqoueIy8o9w-qxr8OqN6t8ng5S4kZyR4FBjGY1fzuAsAJ29XYKOy_6QwKa3YIXwqCAKU2cYDMOMUAVKsW0gS9qbaIKousuNT0inSa02DtQ6-DGDPkce4zjayijUkwbFYXV7mK_Bjnv3ZDhjUhKWf1M22QdAQs36lfY',
    },
    {
      'name': 'Siti Rahma',
      'point': '2.850',
      'rank': 1,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBiUBWJ3CQwI1247bYa6HGIkQBuKkA4auL-lsiKNjU_qQEuijjbySKUI9c2S7bxfoBjpjmi7LTMLxSf1xPwo4mgbRwb97siSI_I14sy4zYlsq4VPlPvTwrfIigrH8Gefx160b9aEtlYKGWF-axzyJyoS159-ayhDLFoTd6DRgI5X7zOrK4_2xXwjP5daoRUqHbIGwBHZnwwKtyvHQbX1zn7D3KfnwCXzmfxNjJyzeIVG5BRwd6qQfiNaSiAnBB0pnh0o2NUMrz9FDE',
    },
    {
      'name': 'Budi Santoso',
      'point': '1.980',
      'rank': 3,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDHVWIZ3YooTvUO5WOrAEQ2qWoEDSqQQ0BHRwZNibZfClO9JlmvjURJQQXyRxgHk6W1xx1kQu6WsXG0tIQzP5ibdtIP0BXMNX7HYxQwvCo3XUim2mBr6roMoF2L58chBaJomcCD89iN24q28PkrWO0RzufKEpqIfwcnjcyUkrsRBtT-vEkWVShRg46AdHWmayNZ1EXWEWxVWvIZWXLXzZCejGkhc5OqN1LLHccHYXea1irTF7j4itNNrXpS32iODIW0R3sjs7Fp-Xw',
    },
  ];

  final leaderboard = [
    {
      'rank': 4,
      'name': 'Eka Putri',
      'province': 'Jawa Barat',
      'point': '1.820',
    },
    {
      'rank': 5,
      'name': 'Fajar S.',
      'province': 'Bali',
      'point': '1.750',
    },
    {
      'rank': 6,
      'name': 'Gita Amalia',
      'province': 'Sumut',
      'point': '1.680',
    },
    {
      'rank': 7,
      'name': 'Hadi Winata',
      'province': 'Jatim',
      'point': '1.540',
    },
  ];
}