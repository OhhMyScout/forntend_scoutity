import 'package:get/get.dart';

class AlfabetSemaphoreController extends GetxController {
  final semaphoreList = [
    {
      "letter": "A",
      "code": "0 & 1",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuAnYVJ51a3zf-Wk3ED-2eKPPQqiGpW4NgrhcVukz02RUSOXydiwGphERoqyTGm58qEqG4msV6NMkbBEJeNV510njxVgZ4XBkqpGYFAUOY57ArM2pz_SE3mHXD8eQGwduVWO-FlVBIIDQBZREdXEOdBUbKkJEL3sK9A3Muzf1gKto8jFevgbwkrQngRb8VA2w26iMsYB6lsVHjgiWBhUFam7N4EUzHeoKRQb4ois3nAoO0BleU8ERXqGd6A-RkgAf0XWSz8KyOLZAIs",
    },
    {
      "letter": "B",
      "code": "0 & 2",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuDikWOu5nIHtWV5ewZR_DlvSGCEK9VwLmWe6zXerq3lw7qAFunR2elT9pjCuwBHcY7iqI00xUvFPNBTx2oeO9YKB42fL8aWF6VuFH7jaoYooIU1tVXaD9hE7Xo9IW8AqJ12DNo7CCiwlgpkrT17mFslMpcXai_XxsAOnC9iYjE6jU1DGWBRhGlp58VokphpDJf8kiBx-RkrzbZupoXpjscmSytPFghLDFB8E07fb670ewFVd3m1M6QLdlcJgjDxCgFo2MKsg4FJrek",
    },
    {
      "letter": "C",
      "code": "0 & 3",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuAZ2IdSZXN2Gg4MwDyPlicfHjh8VBXSlIvNDO6B8c8zWh8QUeKeM32zWyPWe4Cjk4nwb5JPz4HzExs_fdGnePW-IFrWcFqc03JJl5zxBlI4XHI_tcISXlaHxSHFkMgGinVvRnj2tRyThe8me1qiQHgIJYfCyu_pXhAQjo8DuitLQTg52bXB27ZUcTxMBPrTGEwyjYubGYUa7xyayVm2xsR64TUbSjgTVXVg1IR5yNSw7M2tALm9jJOL_uUScrZwfqBjnXIQE-Uio18",
    },
    {
      "letter": "D",
      "code": "0 & 4",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuCURKY4enzTj1J11Id95C046hHMkPAGqF41L42x7fHSlWY-6Dyk_rzMXpSjgDgdclMp8UbR6x4oUwp6UoG1oRnlomLdJ5n8HFcdmB5EwKv52Rfk5wKVhuwVYoADCNaL2QrQkhaDs_tXy3UgbutIHv0GwrjCvZS_r_MhH98bsO-Cwszh7GKw1wD3JVmxa3x6ILdE__yS7SwqpGaPcI2vN_PHkSsBBFEY8jdNOGTEyL5w6MM-8zp3Bp400XEzy4ci1I-MI2FtjragkpI",
    },
    {
      "letter": "E",
      "code": "0 & 5",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuC1gr_Br90JB9Xc-4B-rZ-H7N1RraAzSAW9Sg4e378qaChSLfrOiR8G5U-ckvOwC3B2PWpGY5TnRJ02sX--hkPhUA2NMCb66jEKtDkJYnkYxEEvkfrv5eCPXwaTi3bHKCs9uGw46sAPwJjMeQbfKHrkn3zfatAgLpYNuuc48VgnrCBYg-IT_VQddgV9H_c0VFRQvO6Pr1lL9oJrSJiSEHuQJuWO3sujjSqbJtefq514RzaUcA2vc3DeOkFyug49rUXGL6eGp8uXGiU",
    },
    {
      "letter": "F",
      "code": "0 & 6",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuBocqjntmo9zlUR9uo_-Uz5Qj6VmG6PamdnQeiwB-CCSh9nGR9-iTT9U61gD-XIPU-jzX5sqNLKCpObM1gF2JFBvDIW6WybT8d5tIeAeS6fGHB66CTBQ6ZeY4dxexSdKVcz8waAdNQp_yuoL492xGNz6-mEgF1AAUHrpXBD3EWCLv6LqPa2zxxM7UCWCUrbOJuKNEG7dHO4Kvjdj1tv90v21DlrF6DrqlYi4pM-yhNj6ryFyXpCMV-Wd3THFftB9DSE6ct4bNF67mM",
    },

    // Tambahan A-Z
    {
      "letter": "G",
      "code": "0 & 7",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "H",
      "code": "0 & 8",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "I",
      "code": "0 & 9",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "J",
      "code": "1 & 2",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "K",
      "code": "1 & 3",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "L",
      "code": "1 & 4",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "M",
      "code": "1 & 5",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "N",
      "code": "1 & 6",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "O",
      "code": "1 & 7",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "P",
      "code": "1 & 8",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "Q",
      "code": "1 & 9",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "R",
      "code": "2 & 3",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "S",
      "code": "2 & 4",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "T",
      "code": "2 & 5",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "U",
      "code": "2 & 6",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "V",
      "code": "2 & 7",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "W",
      "code": "2 & 8",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "X",
      "code": "2 & 9",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "Y",
      "code": "3 & 4",
      "image": "https://via.placeholder.com/150",
    },
    {
      "letter": "Z",
      "code": "3 & 5",
      "image": "https://via.placeholder.com/150",
    },
  ].obs;
}