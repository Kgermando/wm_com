import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/constants/responsive.dart';
import 'package:wm_commercial/src/models/commercial/ardoise_model.dart';
import 'package:wm_commercial/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_commercial/src/navigation/header/header_bar.dart';
import 'package:wm_commercial/src/pages/commercial/controller/ardoise/ardoise_controller.dart';
import 'package:wm_commercial/src/routes/routes.dart'; 
import 'package:wm_commercial/src/widgets/loading.dart';
import 'package:wm_commercial/src/widgets/title_widget.dart';

class ArdoisePage extends StatefulWidget {
  const ArdoisePage({super.key});

  @override
  State<ArdoisePage> createState() => _ArdoisePageState();
}

class _ArdoisePageState extends State<ArdoisePage> {
  final ArdoiseController controller = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  String subTitle = "Ardoises";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: headerBar(context, scaffoldKey, title, subTitle),
        drawer: const DrawerMenu(),
        floatingActionButton: Responsive.isMobile(context)
            ? FloatingActionButton(
                tooltip: "Ajouter une table",
                child: const Icon(Icons.add),
                onPressed: () => ardoiseDialog())
            : FloatingActionButton.extended(
                label: const Text("Ajouter une table"),
                tooltip: "Ajouter une table",
                icon: const Icon(Icons.add),
                onPressed: () => ardoiseDialog()),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    (state) => SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const TitleWidget(title: 'Table clients'),
                              IconButton(
                                  onPressed: () {
                                    controller.getList();
                                    Navigator.pushNamed(context,
                                        ComRoutes.comArdoise);
                                  },
                                  icon: const Icon(Icons.refresh,
                                      color: Colors.green))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: p20),
                            child: Wrap(
                              spacing: p20,
                              runSpacing: p20, 
                              children:
                                  List.generate(state!.length, (index) {
                                final ardoise = state[index];
                                return tableWidget(ardoise);
                              }),
                            ),
                          ),
                        ],
                      ),
                    )))
          ],
        ));
  }

  // Green la table est ouverte pour les nouveaux clients
  // Rouge la table est fermée donc les clients occupent
  Widget tableWidget(ArdoiseModel ardoise) {
    Color? color;
    bool isBusy = false;
    if (ardoise.statut == 'true') {
      color = Colors.red; // Occuper
      isBusy = true;
    } else if (ardoise.statut == 'false') {
      color = Colors.green; // Ouvert pour les nouveaux clients
      isBusy = false;
    }
    return InkWell(
      onTap: () => Get.toNamed(ComRoutes.comArdoiseDetail, arguments: ardoise),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(p8)),
        child: Container(
          height: 150,
          width: 150,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 8.0, color: color!)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(),
              Icon((isBusy) ? Icons.table_bar : Icons.table_bar_outlined, size: 60, color: color), 
              AutoSizeText(ardoise.ardoise.toUpperCase(), maxLines: 2, textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );

    // Container(
    //   width: 100,
    //   height: 100,
    //   decoration: BoxDecoration(border: Border.all(color: color, width: 2)),
    //   child: Center(
    //     child: Column(
    //       children: const [
    //         Icon(Icons.table_bar, size: p50),
    //       ],
    //     ),
    //   ),
    // );
  }

  ardoiseDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Nouvelle table', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 100,
                  width: 200,
                  child: Obx(() => controller.isLoading
                      ? loading()
                      : Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              nomTabletWidget(),
                            ],
                          )))),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler',
                      style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    final form = controller.formKey.currentState!;
                    if (form.validate()) {
                      controller.submit();
                      form.reset();
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          });
        });
  }

  Widget nomTabletWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.ardoiseController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom de la table',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }
}
