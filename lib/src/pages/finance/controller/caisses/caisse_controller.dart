import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sembast/timestamp.dart';
import 'package:wm_commercial/src/api/finance/caisse_api.dart';
import 'package:wm_commercial/src/models/finance/caisse_model.dart';
import 'package:wm_commercial/src/models/finance/caisse_name_model.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/utils/dropdown.dart';
import 'package:wm_commercial/src/utils/type_operation.dart';

class CaisseController extends GetxController
    with StateMixin<List<CaisseModel>> {
  final CaisseApi caisseApi = CaisseApi();
  final ProfilController profilController = Get.find();

  var caisseList = <CaisseModel>[].obs;

  final GlobalKey<FormState> formKeyEncaissement = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyDecaissement = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController nomCompletController = TextEditingController();
  TextEditingController pieceJustificativeController = TextEditingController();
  TextEditingController libelleController = TextEditingController();
  TextEditingController montantController = TextEditingController();

  String? typeOperation; // For Update

  final List<String> typeCaisse = TypeOperation().typeVereCaisse;
  final List<String> departementList = Dropdown().departement;

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  @override
  void refresh() {
    getList();
    super.refresh();
  }

  @override
  void dispose() {
    nomCompletController.dispose();
    pieceJustificativeController.dispose();
    libelleController.dispose();
    montantController.dispose();
    super.dispose();
  }

  void clear() {
    typeOperation = null;
    nomCompletController.clear();
    pieceJustificativeController.clear();
    libelleController.clear();
    montantController.clear();
  }

  void getList() async {
    await caisseApi.getAllData().then((response) {
      caisseList.clear();
      caisseList.assignAll(response);
      change(caisseList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await caisseApi.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await caisseApi.deleteData(id).then((value) {
        caisseList.clear();
        getList();
        Get.back();
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

  void submitEncaissement(CaisseNameModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = CaisseModel(
          nomComplet: nomCompletController.text,
          pieceJustificative: pieceJustificativeController.text,
          libelle: libelleController.text,
          montantEncaissement: montantController.text,
          departement: '-',
          typeOperation: 'Encaissement',
          numeroOperation: 'Transaction-Caisse-${caisseList.length + 1}',
          signature: profilController.user.matricule,
          reference: data.id!,
          caisseName: data.nomComplet,
          created: Timestamp.now(),
          montantDecaissement: "0");
      await caisseApi.insertData(dataItem).then((value) {
        clear();
        caisseList.clear();
        getList();
        Get.back();
        Get.snackbar("Soumission effectuée avec succès!",
            "Le document a bien été sauvegadé",
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

  void submitDecaissement(CaisseNameModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = CaisseModel(
        nomComplet: nomCompletController.text,
        pieceJustificative: '-',
        libelle: libelleController.text,
        montantEncaissement: "0",
        departement: '-',
        typeOperation: 'Decaissement',
        numeroOperation: 'Transaction-Caisse-${caisseList.length + 1}',
        signature: profilController.user.matricule,
        reference: data.id!,
        caisseName: data.nomComplet,
        created: Timestamp.now(),
        montantDecaissement: montantController.text,
      );
      await caisseApi.insertData(dataItem).then((value) {
        clear();
        caisseList.clear();
        getList();
        Get.back();
        Get.snackbar("Soumission effectuée avec succès!",
            "Le document a bien été sauvegadé",
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
}
