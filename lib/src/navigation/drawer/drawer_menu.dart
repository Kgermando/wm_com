import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/controllers/departement_notify_controller.dart';
import 'package:wm_commercial/src/navigation/drawer/components/commercial_nav.dart';
import 'package:wm_commercial/src/navigation/drawer/components/finance_nav.dart';
import 'package:wm_commercial/src/navigation/drawer/components/update_nav.dart';
import 'package:wm_commercial/src/navigation/drawer/drawer_widget.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/routes/routes.dart';
import 'package:wm_commercial/src/utils/info_system.dart';
import 'package:wm_commercial/src/widgets/loading.dart';

class DrawerMenu extends GetView<DepartementNotifyCOntroller> {
  const DrawerMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final ProfilController profilController = Get.find();
    return Drawer(
        child: profilController.obx(
            onLoading: loadingDrawer(),
            onError: (error) => loadingError(context, error!), (user) {
      String departementList = user!.departement;
      int userRole = int.parse(profilController.user.role);
      return ListView(
        shrinkWrap: true,
        children: [
          DrawerHeader(
              child: Image.asset(
            InfoSystem().logo(),
            width: 100,
            height: 100,
          )),
          CommercialNav(
              currentRoute: currentRoute,
              user: user,
              departementList: departementList,
              controller: controller),
           if (userRole <= 3)
          DrawerWidget(
              selected: currentRoute == ReservationRoutes.reservation,
              icon: Icons.meeting_room,
              sizeIcon: 20.0,
              title: 'Reservations',
              style: bodyMedium!,
              onTap: () {
                Get.toNamed(ReservationRoutes.reservation);
              }),
           if (userRole <= 3)
          FinanceNav(
              currentRoute: currentRoute,
              user: user,
              departementList: departementList,
              controller: controller),
          DrawerWidget(
              selected: currentRoute == MarketingRoutes.marketingAnnuaire,
              icon: Icons.contact_phone,
              sizeIcon: 20.0,
              title: 'Annuaire',
              style: bodyMedium!,
              onTap: () {
                Get.toNamed(MarketingRoutes.marketingAnnuaire);
              }),
           if (userRole <= 3)
          DrawerWidget(
              selected: currentRoute == RhRoutes.rhPersonnelsPage,
              icon: Icons.group,
              sizeIcon: 20.0,
              title: 'Personnels',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(RhRoutes.rhPersonnelsPage);
              }),
           if (userRole <= 3)
            DrawerWidget(
                selected: currentRoute == RhRoutes.rhUserActif,
                icon: Icons.group,
                sizeIcon: 20.0,
                title: 'Personnels Actifs',
                style: bodyMedium,
                onTap: () {
                  Get.toNamed(RhRoutes.rhUserActif);
                }),
          if (userRole <= 3)
          DrawerWidget(
              selected: currentRoute == ArchiveRoutes.archivesFolder,
              icon: Icons.archive,
              sizeIcon: 20.0,
              title: 'Archives',
              style: bodyMedium,
              onTap: () {
                Get.toNamed(ArchiveRoutes.archivesFolder);
                // Navigator.of(context).pop();
              }),
          if (Platform.isWindows)
            UpdateNav(
              currentRoute: currentRoute,
              user: user,
            )
        ],
      );
    }));
  }
}
