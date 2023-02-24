import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/api/commerciale/history_rabitaillement_api.dart';
import 'package:wm_commercial/src/models/commercial/history_ravitaillement_model.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';

class HistoryRavitaillementController extends GetxController
    with StateMixin<List<HistoryRavitaillementModel>> {
  final HistoryRavitaillementApi historyRavitaillementApi =
      HistoryRavitaillementApi();
  final ProfilController profilController = Get.find();

  var historyRavitaillementList = <HistoryRavitaillementModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

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



  void getList() async {
    await historyRavitaillementApi.getAllData().then((response) {
      historyRavitaillementList.clear();
      historyRavitaillementList.addAll(response);
      historyRavitaillementList.refresh();
      change(historyRavitaillementList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await historyRavitaillementApi.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await historyRavitaillementApi.deleteData(id).then((value) {
        historyRavitaillementList.clear();
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
}
