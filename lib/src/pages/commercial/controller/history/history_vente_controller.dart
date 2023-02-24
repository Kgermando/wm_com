import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:wm_commercial/src/api/commerciale/vente_cart_api.dart';
import 'package:wm_commercial/src/models/commercial/vente_cart_model.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';

class VenteCartController extends GetxController
    with StateMixin<List<VenteCartModel>> {
  final VenteCartApi venteCartApi = VenteCartApi();
  final ProfilController profilController = Get.find();

  List<VenteCartModel> venteCartList = [];

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
    await venteCartApi.getAllData().then((response) {
      venteCartList.clear();
      venteCartList.addAll(response);
      change(venteCartList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await venteCartApi.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await venteCartApi.deleteData(id).then((value) {
        venteCartList.clear();
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
