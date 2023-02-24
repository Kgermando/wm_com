import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sembast/timestamp.dart';
import 'package:wm_commercial/src/api/reservation/paiement_reservation_api.dart';
import 'package:wm_commercial/src/models/reservation/paiement_reservation_model.dart';
import 'package:wm_commercial/src/models/reservation/reservation_model.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';

class PaiementReservationController extends GetxController
    with StateMixin<List<PaiementReservationModel>> {
  PaiementReservationApi paiementReservationApi = PaiementReservationApi();
  final ProfilController profilController = Get.find();

  var paiementReservationList = <PaiementReservationModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  String? motif;
  TextEditingController montantController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  @override
  void dispose() {
    montantController.dispose();

    super.dispose();
  }

  void clear() {
    motif = null;
    montantController.clear();
  }

  void getList() async {
    paiementReservationApi.getAllData().then((response) {
      paiementReservationList.clear();
      paiementReservationList.addAll(response);
      paiementReservationList.refresh();
      change(paiementReservationList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) => paiementReservationApi.getOneData(id);

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await paiementReservationApi.deleteData(id).then((value) {
        clear();
        getList();
        Get.snackbar("Supprimé avec succès!", "Cet élément a bien été supprimé",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
        _isLoading.value = false;
      });
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  Future submit(ReservationModel reservationModel) async {
    try {
      _isLoading.value = true;
      final dataItem = PaiementReservationModel(
          reference: reservationModel.id!,
          client: reservationModel.client,
          motif: motif.toString(),
          montant: montantController.text,
          signature: profilController.user.matricule,
          created: Timestamp.now());
      await paiementReservationApi.insertData(dataItem).then((value) async {
        clear();
        getList();
        Get.back();
        Get.snackbar("Enregistrement effectué!", "Le document a bien été créé!",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
      });
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar(
        "Erreur s'est produite",
        "$e",
        backgroundColor: Colors.red,
      );
    }
  }

  Future submitUpdate(PaiementReservationModel paiementReservationModel) async {
    try {
      _isLoading.value = true;
      final dataItem = PaiementReservationModel(
          reference: paiementReservationModel.reference,
          client: paiementReservationModel.client,
          motif: (motif == null)
              ? paiementReservationModel.motif
              : motif.toString(),
          montant: (montantController.text == '')
              ? paiementReservationModel.montant
              : montantController.text,
          signature: profilController.user.matricule,
          created: Timestamp.now());
      await paiementReservationApi.updateData(dataItem).then((value) {
        clear();
        getList();
        Get.back();
        Get.snackbar(
            "Modification effectué!", "Le document a bien été sauvegadé",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
      });
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }
}
