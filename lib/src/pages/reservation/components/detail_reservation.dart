import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wm_commercial/src/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/models/reservation/paiement_reservation_model.dart';
import 'package:wm_commercial/src/models/reservation/reservation_model.dart';
import 'package:wm_commercial/src/models/users/user_model.dart';
import 'package:wm_commercial/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_commercial/src/navigation/header/header_bar.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/pages/reservation/components/reservation_a6_pdf.dart';
import 'package:wm_commercial/src/pages/reservation/controller/paiement_reservation_controller.dart';
import 'package:wm_commercial/src/pages/reservation/controller/reservation_controller.dart'; 
import 'package:wm_commercial/src/routes/routes.dart';
import 'package:wm_commercial/src/widgets/loading.dart';
import 'package:wm_commercial/src/widgets/print_widget.dart';
import 'package:wm_commercial/src/widgets/responsive_child_widget.dart';
import 'package:wm_commercial/src/widgets/title_widget.dart';

class DetailReservation extends StatefulWidget {
  const DetailReservation({super.key, required this.reservationModel});
  final ReservationModel reservationModel;

  @override
  State<DetailReservation> createState() => _DetailReservationState();
}

class _DetailReservationState extends State<DetailReservation> {
  final ReservationController controller = Get.put(ReservationController());
  final PaiementReservationController paiementReservationController =
      Get.put(PaiementReservationController());
  final ProfilController profilController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Reservation";

  Future<UserModel> refresh() async {
    final UserModel dataItem =
        await controller.detailView(widget.reservationModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) {
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    int userRole = int.parse(profilController.user.role);
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(
          context, scaffoldKey, title, widget.reservationModel.eventName),
      drawer: const DrawerMenu(),
      floatingActionButton: Responsive.isMobile(context)
          ? FloatingActionButton(
              tooltip: "Ajouter le montant de paiement",
              child: const Icon(Icons.add),
              onPressed: () {
                newDialog();
              })
          : FloatingActionButton.extended(
              label: const Text("Ajouter un nouveau paiement"),
              tooltip: "Ajouter le montant de paiement",
              icon: const Icon(Icons.add),
              onPressed: () {
                newDialog();
              },
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenu())),
          Expanded(
              flex: 5,
              child: paiementReservationController.obx(
                  onLoading: loadingPage(context),
                  onEmpty: const Text('Aucune donnée'),
                  onError: (error) => loadingError(context, error!), (state) {
                var paiementReservation = state!
                    .where((element) =>
                        element.reference == widget.reservationModel.id!)
                    .toList();
                return SingleChildScrollView(
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
                      child: Column(
                        children: [
                          Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: p20, vertical: p20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const TitleWidget(title: "Reservation"),
                                      Row(
                                        children: [
                                          IconButton(
                                              tooltip: 'Actualiser',
                                              onPressed: () {
                                                refresh().then((value) =>
                                                    Navigator.pushNamed(context,
                                                        RhRoutes.rhdetailUser,
                                                        arguments: value));
                                              },
                                              icon: Icon(Icons.refresh,
                                                  color:
                                                      Colors.green.shade700)),
                                          IconButton(
                                              color: Colors.purple,
                                              onPressed: () {
                                                Get.toNamed(
                                                    ReservationRoutes
                                                        .reservationUpdate,
                                                    arguments: widget
                                                        .reservationModel);
                                              },
                                              icon: const Icon(Icons.edit)),
                                          if (userRole <= 2) deleteButton(),
                                          PrintWidget(
                                              tooltip: "Imprimer le CV",
                                              onPressed: () {
                                                ReservationPDFA6.generatePdf(
                                                    widget.reservationModel,
                                                    paiementReservation,
                                                    "\$");
                                              }),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: p20),
                                  ResponsiveChildWidget(
                                      child1: Text('Evenement :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium!.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.eventName,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  Divider(color: mainColor),
                                  ResponsiveChildWidget(
                                      child1: Text(
                                          'Nom du client (Organisateur) :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.client,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  Divider(color: mainColor),
                                  ResponsiveChildWidget(
                                      child1: Text('Téléphone :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.telephone,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  Divider(color: mainColor),
                                  ResponsiveChildWidget(
                                      child1: Text('Email :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.email,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  Divider(color: mainColor),
                                  ResponsiveChildWidget(
                                      child1: Text('Adresse :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.adresse,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  Divider(color: mainColor),
                                  ResponsiveChildWidget(
                                      child1: Text('Nbre de Personnes :',
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.nbrePersonne,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  Divider(color: mainColor),
                                  ResponsiveChildWidget(
                                      child1: Text("Durée de l'évenement :",
                                          textAlign: TextAlign.start,
                                          style: bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold)),
                                      child2: SelectableText(
                                          widget.reservationModel.dureeEvent,
                                          textAlign: TextAlign.start,
                                          style: bodyMedium)),
                                  // Divider(color: mainColor),
                                  const SizedBox(height: p20),
                                ],
                              ),
                            ),
                          ),
                          paiementReservationController.obx(
                              onLoading: loadingPage(context),
                              onEmpty: const Text('Aucune donnée'),
                              onError: (error) => loadingError(context, error!),
                              (state) {
                            List<PaiementReservationModel> paiementReservation =
                                state!
                                    .where((element) =>
                                        element.reference ==
                                        widget.reservationModel.id!)
                                    .toList();
                            double total = 0.0;
                            for (var element in paiementReservation) {
                              total = double.parse(element.montant);
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: p10),
                                const TitleWidget(title: "Paiements"),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: paiementReservation.length,
                                    itemBuilder: (context, index) {
                                      final paiement =
                                          paiementReservation[index];
                                      var isDelete = DateTime.now().difference(
                                          paiement.created.toDateTime());
                                      return Card(
                                        child: ListTile(
                                          title: Text(paiement.motif),
                                          subtitle: Text(
                                              DateFormat("dd-MM-yyyy HH:mm")
                                                  .format(paiement.created
                                                      .toDateTime())),
                                          trailing: SizedBox(
                                            width: 100,
                                            child: Row(
                                              children: [
                                                Text(
                                                    "${NumberFormat.decimalPattern('fr').format(double.parse(paiement.montant))} \$",
                                                    style: bodyLarge!.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                if (isDelete.inHours <= 1)
                                                  // const SizedBox(width: p5),
                                                  Obx(() =>
                                                      paiementReservationController
                                                              .isLoading
                                                          ? loadingMini()
                                                          : deleteMontantButton(
                                                              paiement)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                const SizedBox(height: p20),
                                const Divider(color: Colors.red),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total payé", style: headlineSmall),
                                      Text(
                                          "${NumberFormat.decimalPattern('fr').format(total)} \$",
                                          style: headlineSmall!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red))
                                    ],
                                  ),
                                )
                              ],
                            );
                          })
                        ],
                      ),
                    ));
              }))
        ],
      ),
    );
  }

  Widget deleteButton() {
    return IconButton(
      color: Colors.red.shade700,
      icon: const Icon(Icons.delete),
      tooltip: "Suppression",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de supprimé ceci?',
              style: TextStyle(color: Colors.red)),
          content: const Text(
              'Cette action permet de supprimer définitivement ce document.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                controller.deleteData(widget.reservationModel.id!);
                Navigator.pop(context, 'ok');
              },
              child: Obx(() => controller.isLoading
                  ? loading()
                  : const Text('OK', style: TextStyle(color: Colors.red))),
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteMontantButton(PaiementReservationModel paiement) {
    return IconButton(
      color: Colors.red.shade700,
      icon: const Icon(Icons.close),
      tooltip: "Suppression",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Etes-vous sûr de supprimé ceci?',
              style: TextStyle(color: Colors.red)),
          content: const Text(
              'Cette action permet de supprimer définitivement ce document.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                paiementReservationController.deleteData(paiement.id!);
                Navigator.pop(context, 'ok');
              },
              child: Obx(() => paiementReservationController.isLoading
                  ? loadingMini()
                  : const Text('OK', style: TextStyle(color: Colors.red))),
            ),
          ],
        ),
      ),
    );
  }

  newDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('Ajouter le paiement',
                  style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 200,
                  width: 200,
                  child: Obx(() => paiementReservationController.isLoading
                      ? loading()
                      : Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              motifWidget(),
                              montant(),
                            ],
                          )))),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    final form = controller.formKey.currentState!;
                    if (form.validate()) {
                      paiementReservationController
                          .submit(widget.reservationModel);
                      form.reset();
                    }
                  },
                  child: Obx(() =>
                      controller.isLoading ? loading() : const Text('OK')),
                ),
              ],
            );
          });
        });
  }

  Widget motifWidget() {
    List<String> suggestionList = paiementReservationController
        .paiementReservationList
        .map((e) => e.motif)
        .toSet()
        .toList();
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: EasyAutocomplete(
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Motif de paiement",
          ),
          keyboardType: TextInputType.text,
          suggestions: suggestionList,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
          onChanged: (value) {
            paiementReservationController.motif = value;
          },
        ));
  }

  Widget montant() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: paiementReservationController.montantController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Montant en \$',
          ),
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
