import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/constants/responsive.dart';
import 'package:wm_commercial/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_commercial/src/navigation/header/header_bar.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/pages/commercial/components/history_ravitaillement/table_history_ravitaillement.dart';
import 'package:wm_commercial/src/pages/commercial/controller/history/history_ravitaillement_controller.dart';
import 'package:wm_commercial/src/widgets/loading.dart';

class HistoryRavitaillementPage extends StatefulWidget {
  const HistoryRavitaillementPage({super.key});

  @override
  State<HistoryRavitaillementPage> createState() =>
      _HistoryRavitaillementPageState();
}

class _HistoryRavitaillementPageState extends State<HistoryRavitaillementPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  String subTitle = "Historique des Ravitaillements";

  @override
  Widget build(BuildContext context) {
    final HistoryRavitaillementController controller = Get.find();
    final ProfilController profilController = Get.find();
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenu(),
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
                    (data) => Container(
                        margin: EdgeInsets.only(
                            top: p20,
                            bottom: p8,
                            right: Responsive.isDesktop(context) ? p20 : 0,
                            left: Responsive.isDesktop(context) ? p20 : 0),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: TableHistoryRavitaillement(
                            historyRavitaillementList:
                                controller.historyRavitaillementList,
                            profilController: profilController)))),
          ],
        ));
  }
}
