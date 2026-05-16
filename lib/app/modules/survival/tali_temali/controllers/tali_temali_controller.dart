// controllers/tali_temali_controller.dart

import 'package:get/get.dart';

class TaliItem {
  final String title;
  final String level;
  final String description;
  final String image;

  TaliItem({
    required this.title,
    required this.level,
    required this.description,
    required this.image,
  });
}

class TaliTemaliController extends GetxController {
  final items = <TaliItem>[
    TaliItem(
      title: "Simpul Mati",
      level: "Dasar",
      description:
          "Berguna untuk menyambung dua utas tali yang sama besarnya dan dalam keadaan kering.",
      image:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuArecqG3wrwE6LAtktUDpJ6VKpzpvPwU2v4oxhRM-_M570Cf79EgCSklPnQI14R8ne2urLsP7lvRpgbZdUSU9Gcljg--4eBy0bo762M_nG2cnU3M2VvcMgNh9L5X1t__R1X20-7swLnHgpvsV09agA3YYtIco4dFRL7MQpxIPNz3uBkmof8bxp2fxYZY-7OJHU_e1G--uyi5KAOU2jxzYiIWGXx6sBY8md8IpSUj-iBMTfmZWZkm4Rxm0TZGSm-zKO18i8fnzmouQI",
    ),
    TaliItem(
      title: "Simpul Pangkal",
      level: "Dasar",
      description:
          "Simpul awal untuk memulai ikatan pada tiang atau kayu.",
      image:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuCLbkSbbooR2OGwnPXRAHMbuPdunwof2tjQhasgw5gBk0bch2W5w2SsZTJ-IH29EIHMISWNq2RdYHXgT_J5qHY7QeHNwzfDrnTNiMG4oE9b68-iDTSZSVMcreXY9jvNzIvUV9-l-U4gpsjGEQah92DZjaANYBu8q2pR9OyYOhgbBE1wAswWAPp4OEjRXp6a5A59H0VYknkwL1PfxgADaCad8v8Z0OP1SzyUh4LYHj9huReqs52z-7tmm7iuO3Gz4hphW4-pE9DPUCc",
    ),
    TaliItem(
      title: "Simpul Jangkar",
      level: "Dasar",
      description:
          "Digunakan untuk membuat tandu darurat atau mengikat ember/tali timba.",
      image:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuDmq4cfWSccqV6ZGPKzojNdcnNfZJ4DXhUF5qugddy-gT69isj5H07yW1JF-1RgKU9EqNhwheaJebWqX1ZjGwZqOkfgpoj45n-RHRe3O1d8sjI71WHMQedeQrsHXWts9qDDLqKw6ePGQLa8FEqJI1mQpvMrZbsyTZ0qMhEUVRH1dsr_TEfEtfyUCDuozRzgJfgcx2YQ4iUHLR5MaCP_ZiHUwq0rLXyfh4RAa2v78Mxc9ozu8ruT5LZ4rZHkxG2Z8xK7yXtxPr_RkcY",
    ),
  ].obs;
}