import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/pages/rh/components/table_personnels.dart';
import 'package:wm_commercial/src/pages/rh/controller/personnels_controller.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/constants/responsive.dart';
import 'package:wm_commercial/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_commercial/src/navigation/header/header_bar.dart';
import 'package:wm_commercial/src/routes/routes.dart';
import 'package:wm_commercial/src/widgets/loading.dart';

class PersonnelPage extends GetView<PersonnelsController> {
  const PersonnelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    String title = "Ressources Humaines";
    String subTitle = "Personnels";

    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenu(),
        floatingActionButton: Responsive.isMobile(context)
            ? FloatingActionButton(
                tooltip: "Nouveau profil",
                child: const Icon(Icons.person_add),
                onPressed: () {
                  Get.toNamed(RhRoutes.rhPersonnelsAdd,
                      arguments: controller.personnelsList);
                },
              )
            : FloatingActionButton.extended(
                label: const Text("Nouveau profil"),
                tooltip: "Nouveau profil",
                icon: const Icon(Icons.person_add),
                onPressed: () {
                  Get.toNamed(RhRoutes.rhPersonnelsAdd,
                      arguments: controller.personnelsList);
                },
              ),
        body: Row(
          children: [
            Visibility(
                visible: !Responsive.isMobile(context),
                child: const Expanded(flex: 1, child: DrawerMenu())),
            Expanded(
                flex: 5,
                child: controller.obx(
                    onLoading: loadingPage(context),
                    onEmpty: const Text('Aucune donnée'),
                    onError: (error) => loadingError(context, error!),
                    (state) => Container(
                        margin: EdgeInsets.only(
                            top: p20,
                            bottom: p8,
                            right: Responsive.isDesktop(context) ? p20 : 0,
                            left: Responsive.isDesktop(context) ? p20 : 0),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: TablePersonnels(
                            personnelList: state!, controller: controller))))
          ],
        ));
  }
}
