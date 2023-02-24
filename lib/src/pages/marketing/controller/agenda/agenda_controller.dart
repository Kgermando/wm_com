import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sembast/timestamp.dart';
import 'package:wm_commercial/src/api/marketing/agenda_api.dart';
import 'package:wm_commercial/src/models/marketing/agenda_model.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';

class AgendaController extends GetxController
    with StateMixin<List<AgendaModel>> {
  final AgendaApi agendaApi = AgendaApi();
  final ProfilController profilController = Get.find();

  var agendaList = <AgendaModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateRappelController = TextEditingController();

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
    titleController.dispose();
    descriptionController.dispose();
    dateRappelController.dispose();
    super.dispose();
  }

  void getList() async {
    await agendaApi.getAllData().then((response) {
      agendaList.clear();
      agendaList.addAll(response.where(
          (element) => element.signature == profilController.user.matricule));
      agendaList.refresh();
      change(agendaList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await agendaApi.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await agendaApi.deleteData(id).then((value) {
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

  void submit() async {
    try {
      _isLoading.value = true;
      final dataItem = AgendaModel(
          title: titleController.text,
          description: descriptionController.text,
          dateRappel: DateTime.parse(dateRappelController.text),
          signature: profilController.user.matricule,
          created: Timestamp.now());
      await agendaApi.insertData(dataItem).then((value) {
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

  void submitUpdate(AgendaModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = AgendaModel(
          id: data.id!,
          title: titleController.text,
          description: descriptionController.text,
          dateRappel: DateTime.parse(dateRappelController.text),
          signature: profilController.user.matricule,
          created: data.created);
      await agendaApi.updateData(dataItem).then((value) {
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
