import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/controllers/departement_notify_controller.dart';
import 'package:wm_commercial/src/navigation/drawer/drawer_widget.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/routes/routes.dart';

class MailNav extends GetView<DepartementNotifyCOntroller> {
  const MailNav({super.key});

  @override
  Widget build(BuildContext context) {
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    String? pageCurrente = ModalRoute.of(context)!.settings.name;
    final ProfilController profilController = ProfilController();
    return Drawer(
      backgroundColor: Colors.amber[50],
      // width: 150,
      child: ListView(
        children: [
          const SizedBox(height: p20),
          DrawerWidget(
              selected: pageCurrente == MailRoutes.mails,
              icon: Icons.inbox,
              sizeIcon: 20.0,
              title: 'Menu',
              style: bodySmall!,
              onTap: () {
                // var departement = jsonDecode(profilController.user.departement);
                if (profilController.user.departement == "Commercial") {
                  if (int.parse(profilController.user.role) <= 2) {
                    Get.offAndToNamed(ComRoutes.comDashboard);
                  } else {
                    Get.offAndToNamed(ComRoutes.comVente);
                  }
                }
              }),
          DrawerWidget(
              selected: pageCurrente == MailRoutes.mails,
              icon: Icons.inbox,
              sizeIcon: 20.0,
              title: 'Boite de reception',
              style: bodySmall,
              onTap: () {
                Get.toNamed(MailRoutes.mails);
              }),
          DrawerWidget(
              selected: pageCurrente == MailRoutes.mailSend,
              icon: Icons.send,
              sizeIcon: 20.0,
              title: "Boite d'envoie",
              style: bodySmall,
              onTap: () {
                Get.toNamed(MailRoutes.mailSend);
              }),
          DrawerWidget(
              selected: false,
              icon: Icons.chat,
              sizeIcon: 20.0,
              title: "Messenger",
              style: bodySmall,
              onTap: () {
                // Get.toNamed(MailRoutes.mailSend);
              }),
        ],
      ),
    );
  }
}
