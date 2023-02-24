import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/api/commerciale/bon_consommation_api.dart';
import 'package:wm_commercial/src/models/commercial/bon_consommation_model.dart';
import 'package:wm_commercial/src/models/commercial/cart_model.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';

class BonConsommationController extends GetxController
    with StateMixin<List<BonConsommationModel>> {
  final BonConsommationApi bonConsommationApi = BonConsommationApi();
  final ProfilController profilController = Get.find();

  var bonConsommationList = <BonConsommationModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  String? ardoise;
  int? reference;

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

  void clear() {
    ardoise = null;
  }

  void getList() async {
    await bonConsommationApi.getAllData().then((response) {
      bonConsommationList.clear();
      bonConsommationList.addAll(response);
      change(bonConsommationList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await bonConsommationApi.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await bonConsommationApi.deleteData(id).then((value) {
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

  void submit(RxList<CartModel> cartList) async {
    try {
      _isLoading.value = true;
      final jsonList = jsonEncode(cartList);
      final dataItem = BonConsommationModel(
        ardoise: ardoise.toString(),
        reference: reference!,
        consommation: jsonList,
        succursale: profilController.user.succursale,
        signature: profilController.user.matricule,
        created: DateTime.now(),
      );
      await bonConsommationApi.insertData(dataItem).then((value) {
        clear();
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

  void updateData(BonConsommationModel data, RxList<CartModel> cartList) async {
    try {
      _isLoading.value = true;
      final jsonList = jsonEncode(cartList);
      final dataItem = BonConsommationModel(
        ardoise: ardoise.toString(),
        reference: reference!,
        consommation: jsonList,
        succursale: profilController.user.succursale,
        signature: profilController.user.matricule,
        created: DateTime.now(),
      );
      await bonConsommationApi.updateData(dataItem).then((value) {
        clear();
        getList();
        Get.back();
        Get.snackbar("Modification effectuée avec succès!",
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
