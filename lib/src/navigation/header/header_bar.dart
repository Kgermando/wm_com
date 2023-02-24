import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:auto_size_text/auto_size_text.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/constants/reponsiveness.dart';
import 'package:wm_commercial/src/constants/responsive.dart';
import 'package:wm_commercial/src/constants/style.dart';
import 'package:wm_commercial/src/controllers/departement_notify_controller.dart';
import 'package:wm_commercial/src/models/menu_item.dart';
import 'package:wm_commercial/src/pages/auth/controller/login_controller.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/pages/update/controller/update_controller.dart';
import 'package:wm_commercial/src/routes/routes.dart';
import 'package:wm_commercial/src/utils/info_system.dart';
import 'package:wm_commercial/src/utils/menu_items.dart';
import 'package:wm_commercial/src/utils/menu_options.dart';
import 'package:wm_commercial/src/widgets/bread_crumb_widget.dart';
import 'package:wm_commercial/src/widgets/loading.dart';

AppBar headerBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
    String title, String subTitle) {
  final ProfilController profilController = Get.put(ProfilController());
  final UpdateController updateController = Get.put(UpdateController());
  final DepartementNotifyCOntroller departementNotifyCOntroller =
      Get.put(DepartementNotifyCOntroller());

  final bodyLarge = Theme.of(context).textTheme.bodyLarge;

  return AppBar(
    leadingWidth: 100,
    leading: !ResponsiveWidget.isSmallScreen(context)
        ? Image.asset(
            InfoSystem().logoIcon(),
            width: 20,
            height: 20,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
                  }),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back))
            ],
          ),
    title: Responsive.isMobile(context)
        ? Container()
        : InkWell(
            onTap: () {
              Get.back();
            },
            child: Row(
              children: [
                const Icon(Icons.arrow_back),
                BreadCrumb(
                  overflow: ScrollableOverflow(
                      keepLastDivider: false,
                      reverse: false,
                      direction: Axis.horizontal),
                  items: <BreadCrumbItem>[
                    BreadCrumbItem(content: BreadCrumbWidget(title: title)),
                    (Responsive.isMobile(context))
                        ? BreadCrumbItem(content: Container())
                        : BreadCrumbItem(
                            content: BreadCrumbWidget(title: subTitle)),
                  ],
                  divider: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
    actions: [
      if (Platform.isWindows &&
          updateController.updateVersionList.isNotEmpty &&
          updateController.sumVersionCloud > updateController.sumLocalVersion)
        Obx(() => IconButton(
            iconSize: 40,
            tooltip: 'Téléchargement',
            onPressed: () {
              // updateController.downloadNetworkSoftware(
              //     url: updateController.updateVersionList.last.urlUpdate);
              Get.toNamed(UpdateRoutes.updatePage);
            },
            icon: (updateController.isDownloading)
                ? (updateController.progressString == "100%")
                    ? const Icon(Icons.check)
                    : Obx(() => AutoSizeText(updateController.progressString,
                        maxLines: 1, style: const TextStyle(fontSize: 12.0)))
                : Icon(Icons.download, color: Colors.red.shade700))),
      profilController.obx(onLoading: loadingMini(), (state) {
        final String firstLettter = state!.prenom[0];
        final String firstLettter2 = state.nom[0];
        return Row(
          children: [
              IconButton(
                  tooltip: 'Panier',
                  onPressed: () {
                    Get.toNamed(ComRoutes.comCart);
                  },
                  icon: Obx(() => badges.Badge(
                        showBadge:
                            (departementNotifyCOntroller.cartItemCount >= 1)
                                ? true
                                : false,
                        badgeContent: Text(
                            departementNotifyCOntroller.cartItemCount
                                .toString(),
                            style: const TextStyle(color: Colors.white)),
                        child: const Icon(Icons.shopping_cart_outlined),
                      ))),
            IconButton(
                tooltip: 'Agenda',
                onPressed: () {
                  Get.toNamed(MarketingRoutes.marketingAgenda);
                },
                icon: Obx(() => badges.Badge(
                      showBadge:
                          (departementNotifyCOntroller.agendaItemCount >= 1)
                              ? true
                              : false,
                      badgeContent: Text(
                          departementNotifyCOntroller.agendaItemCount
                              .toString(),
                          style: const TextStyle(color: Colors.white)),
                      child: Icon(Icons.note_alt_outlined,
                          size: (Responsive.isDesktop(context) ? 25 : 20)),
                    ))),
            IconButton(
                tooltip: 'Mailling',
                onPressed: () {
                  Get.toNamed(MailRoutes.mails);
                },
                icon: Obx(() => badges.Badge(
                      showBadge:
                          (departementNotifyCOntroller.mailsItemCount >= 1)
                              ? true
                              : false,
                      badgeContent: Text(
                          departementNotifyCOntroller.mailsItemCount.toString(),
                          style: const TextStyle(color: Colors.white)),
                      child: Icon(Icons.mail_outline_outlined,
                          size: (Responsive.isDesktop(context) ? 25 : 20)),
                    ))),
            if (!Responsive.isMobile(context))
              const SizedBox(
                width: p10,
              ),
            Container(
              width: 1,
              height: 22,
              color: lightGrey,
            ),
            if (!Responsive.isMobile(context))
              const SizedBox(
                width: p20,
              ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.all(2),
                child: CircleAvatar(
                  child: AutoSizeText(
                    '$firstLettter$firstLettter2'.toUpperCase(),
                    maxLines: 1,
                  ),
                )),
            const SizedBox(width: p8),
            if (Responsive.isDesktop(context))
              InkWell(
                onTap: () {
                  Get.toNamed(UserRoutes.profil);
                },
                child: AutoSizeText(
                  "${profilController.user.prenom} ${profilController.user.nom}",
                  maxLines: 1,
                  style: bodyLarge,
                ),
              ),
          ],
        );
      }),
      Obx(() => Get.find<LoginController>().loadingLogOut
          ? Row(
              children: [
                const SizedBox(width: p10),
                loadingMini(),
                const SizedBox(width: p10),
              ],
            )
          : PopupMenuButton<MenuItemModel>(
              onSelected: (item) => MenuOptions().onSelected(context, item),
              itemBuilder: (context) => [
                ...MenuItems.itemsFirst.map(MenuOptions().buildItem).toList(),
                const PopupMenuDivider(),
                ...MenuItems.itemsSecond.map(MenuOptions().buildItem).toList(),
              ],
            ))
    ],
    iconTheme: IconThemeData(color: dark),
    elevation: 0,
    // backgroundColor: Colors.transparent,
  );
}
