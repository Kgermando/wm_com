import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/constants/responsive.dart';
import 'package:wm_commercial/src/models/archive/archive_model.dart';
import 'package:wm_commercial/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_commercial/src/navigation/header/header_bar.dart';
import 'package:wm_commercial/src/pages/archives/controller/archive_controller.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/routes/routes.dart';
import 'package:wm_commercial/src/widgets/responsive_child_widget.dart';

class DetailArchive extends StatefulWidget {
  const DetailArchive({super.key, required this.archiveModel});
  final ArchiveModel archiveModel;

  @override
  State<DetailArchive> createState() => _DetailArchiveState();
}

class _DetailArchiveState extends State<DetailArchive> {
  final ProfilController profilController = Get.find();
  final ArchiveController controller = Get.put(ArchiveController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Archive";
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();

  Future<ArchiveModel> refresh() async {
    final ArchiveModel dataItem =
        await controller.detailView(widget.archiveModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.archiveModel.folderName),
      drawer: const DrawerMenu(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenu())),
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
                  controller: ScrollController(),
                  physics: const ScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: p20,
                        bottom: p8,
                        right: Responsive.isDesktop(context) ? p20 : 0,
                        left: Responsive.isDesktop(context) ? p20 : 0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: p20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              refresh().then((value) =>
                                                  Navigator.pushNamed(context,
                                                      ArchiveRoutes.archivesDetail,
                                                      arguments: value));
                                            },
                                            icon: const Icon(Icons.refresh,
                                                color: Colors.green)),
                                        
                                      ],
                                    ),
                                    SelectableText(
                                        DateFormat("dd-MM-yyyy HH:mm").format(
                                            widget.archiveModel.created),
                                        textAlign: TextAlign.start),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: p20),
                            dataWidget()
                          ],
                        ),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  Widget dataWidget() {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    int roleUser = int.parse(profilController.user.role);
    String departement = widget.archiveModel.departement;
    int level = int.parse(widget.archiveModel.level);
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Nom du Document :',
                  textAlign: TextAlign.start,
                  style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.archiveModel.nomDocument,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(color: mainColor),
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Département :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(departement,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(color: mainColor),
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Description :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.archiveModel.description,
                  textAlign: TextAlign.start, style: bodyMedium)),
          Divider(color: mainColor),
          if (roleUser <= level)
            ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Fichier archivé :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: (widget.archiveModel.fichier == '-')
                  ? const Text('-')
                  : TextButton(
                      onPressed: () {
                        var extension =
                            widget.archiveModel.fichier.split(".").last;
                        if (extension == 'pdf') {
                          Get.toNamed(ArchiveRoutes.archivePdf,
                              arguments: widget.archiveModel.fichier);
                          pdfViewerKey.currentState?.openBookmarkView();
                        }
                        if (extension == 'png' || extension == 'jpg') {
                          Get.toNamed(ArchiveRoutes.archiveImage,
                              arguments: widget.archiveModel.fichier);
                        }
                      },
                      child: Text("Cliquer pour visualiser",
                          textAlign: TextAlign.start,
                          style: bodyMedium.copyWith(color: Colors.red)),
                    ),
            ),
          Divider(color: mainColor),
          ResponsiveChildWidget(
              flex1: 1,
              flex2: 3,
              child1: Text('Signature :',
                  textAlign: TextAlign.start,
                  style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              child2: SelectableText(widget.archiveModel.signature,
                  textAlign: TextAlign.start, style: bodyMedium))
        ],
      ),
    );
  }

  Widget editButton() {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.purple.shade700),
      tooltip: "Modification",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Etes-vous sûr de modifier ceci?',
              style: TextStyle(color: mainColor)),
          content: const Text('Cette action permet de modifier ce document.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(ArchiveRoutes.archivesDetail,
                    arguments: widget.archiveModel);
                // Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
