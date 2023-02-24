import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/api/commerciale/produit_model_api.dart';
import 'package:wm_commercial/src/models/commercial/prod_model.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';

class ProduitModelController extends GetxController
    with StateMixin<List<ProductModel>> {
  final ProduitModelApi produitModelApi = ProduitModelApi();
  final ProfilController profilController = Get.find();

  var produitModelList = <ProductModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  String categorieController = "";
  String sousCategorie1Controller = "";
  String sousCategorie2Controller = "";
  String sousCategorie3Controller = "";
  // TextEditingController categorieController = TextEditingController();
  // TextEditingController sousCategorie1Controller = TextEditingController();
  // TextEditingController sousCategorie2Controller = TextEditingController();
  // TextEditingController sousCategorie3Controller = TextEditingController();
  String? uniteController; // sousCategorie4

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

  // @override
  // void dispose() {
  //   categorieController.dispose();
  //   sousCategorie1Controller.dispose();
  //   sousCategorie2Controller.dispose();
  //   sousCategorie3Controller.dispose();
  //   uniteController = null;
  //   super.dispose();
  // }

  void clear() {
    // categorieController.clear();
    // sousCategorie1Controller.clear();
    // sousCategorie2Controller .clear();
    // sousCategorie3Controller.clear();
    categorieController = '';
    sousCategorie1Controller = '';
    sousCategorie2Controller = '';
    sousCategorie3Controller = '';
    uniteController = null;
  }

  void getList() async {
    await produitModelApi.getAllData().then((response) {
      produitModelList.clear();
      produitModelList.addAll(response);
      produitModelList.refresh();
      change(produitModelList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await produitModelApi.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await produitModelApi.deleteData(id).then((value) {
        clear();
        produitModelList.clear();
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
      final idProductform =
          "${categorieController.toString()}-${sousCategorie1Controller.toString()}-${sousCategorie2Controller.toString()}-${sousCategorie3Controller.toString()}-${uniteController.toString()}";
      final dataItem = ProductModel(
          categorie: categorieController.toString(),
          sousCategorie1: (sousCategorie1Controller.toString() == "")
              ? '-'
              : sousCategorie1Controller.toString(),
          sousCategorie2: (sousCategorie2Controller.toString() == "")
              ? '-'
              : sousCategorie2Controller.toString(),
          sousCategorie3: (sousCategorie3Controller.toString() == "")
              ? '-'
              : sousCategorie3Controller.toString(),
          sousCategorie4:
              (uniteController == "") ? '-' : uniteController.toString(),
          idProduct: idProductform.replaceAll(' ', '').toUpperCase(),
          signature: profilController.user.matricule,
          created: DateTime.now());
      await produitModelApi.insertData(dataItem).then((value) {
        clear();
        produitModelList.clear();
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

  void submitUpdate(ProductModel data) async {
    try {
      _isLoading.value = true;
      final idProductform =
          "${categorieController.toString()}-${sousCategorie1Controller.toString()}-${sousCategorie2Controller.toString()}-${sousCategorie3Controller.toString()}-${uniteController.toString()}";
      final dataItem = ProductModel(
          id: data.id,
          categorie: (categorieController.toString() == "")
              ? data.categorie
              : categorieController.toString(),
          sousCategorie1: (sousCategorie1Controller.toString() == "")
              ? data.sousCategorie1
              : sousCategorie1Controller.toString(),
          sousCategorie2: (sousCategorie2Controller.toString() == "")
              ? data.sousCategorie2
              : sousCategorie2Controller.toString(),
          sousCategorie3: (sousCategorie3Controller.toString() == "")
              ? data.sousCategorie3
              : sousCategorie3Controller.toString(),
          sousCategorie4: (uniteController == "")
              ? data.sousCategorie4
              : uniteController.toString(),
          idProduct: idProductform.replaceAll(' ', '').toUpperCase(),
          signature: profilController.user.matricule,
          created: DateTime.now());
      await produitModelApi.updateData(dataItem).then((value) {
        clear();
        produitModelList.clear();
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

  void submitDD(ProductModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = ProductModel(
          id: data.id!,
          categorie: data.categorie,
          sousCategorie1: data.sousCategorie1,
          sousCategorie2: data.sousCategorie2,
          sousCategorie3: data.sousCategorie3,
          sousCategorie4: data.sousCategorie4,
          idProduct: data.idProduct,
          signature: data.signature,
          created: data.created);
      await produitModelApi.updateData(dataItem).then((value) {
        clear();
        produitModelList.clear();
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
