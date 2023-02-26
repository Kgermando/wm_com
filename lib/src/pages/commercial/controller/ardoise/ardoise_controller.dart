import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sembast/timestamp.dart';
import 'package:wm_commercial/src/api/commerciale/ardoise_api.dart';
import 'package:wm_commercial/src/api/commerciale/cart_api.dart';
import 'package:wm_commercial/src/models/commercial/ardoise_model.dart';
import 'package:wm_commercial/src/models/commercial/cart_model.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/cart/cart_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/factures/facture_controller.dart';
import 'package:wm_commercial/src/routes/routes.dart';

class ArdoiseController extends GetxController
    with StateMixin<List<ArdoiseModel>> {
  final ArdoiseApi ardoiseApi = ArdoiseApi();
  final CartApi cartApi = CartApi();
  final CartController cartController = Get.find();
  final ProfilController profilController = Get.find();
  final FactureController factureController = Get.find();

  var ardoiseList = <ArdoiseModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TextEditingController ardoiseController = TextEditingController();
  String? table;

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
    ardoiseController.dispose();
    super.dispose();
  }

  void clear() {
    ardoiseController.clear();
  }

  void getList() async {
    await ardoiseApi.getAllData().then((response) {
      ardoiseList.clear();
      ardoiseList.addAll(response);
      change(ardoiseList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await ardoiseApi.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await ardoiseApi.deleteData(id).then((value) {
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
      // final jsonList = jsonEncode(cartList);
      final dataItem = ArdoiseModel(
        ardoise: ardoiseController.text,
        ardoiseJson: '',
        statut: 'false',
        succursale: profilController.user.succursale,
        signature: profilController.user.matricule,
        created: Timestamp.now(),
      );
      await ardoiseApi.insertData(dataItem).then((value) {
        clear();
        getList();
        Get.toNamed(ComRoutes.comArdoise);
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

  void updateData(ArdoiseModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = ArdoiseModel(
        id: data.id,
        ardoise: (ardoiseController.text == '')
            ? data.ardoise
            : ardoiseController.text,
        ardoiseJson: data.ardoiseJson,
        statut: data.statut,
        succursale: profilController.user.succursale,
        signature: profilController.user.matricule,
        created: Timestamp.now(),
      );
      await ardoiseApi.updateData(dataItem).then((value) {
        clear();
        getList();
        Get.toNamed(ComRoutes.comArdoise);
        Get.snackbar("Modification effectuée avec succès!", "",
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

  // Ajout des commandes à l'ardoise
  void tableInsertData(ArdoiseModel data, List<CartModel> cartList) async {
    try {
      _isLoading.value = true;
      final jsonList = jsonEncode(cartList);
      final dataItem = ArdoiseModel(
        id: data.id,
        ardoise: data.ardoise,
        ardoiseJson: jsonList,
        statut: 'true',
        succursale: profilController.user.succursale,
        signature: profilController.user.matricule,
        created: Timestamp.now(),
      );
      await ardoiseApi.updateData(dataItem).then((value) {
        cartController.cleanCart().then((value) {
          clear();
          cartController.cartList.clear();
          ardoiseList.clear();
          getList();
          Get.back();
          Get.snackbar("Ajout effectuée avec succès!", "",
              backgroundColor: Colors.green,
              icon: const Icon(Icons.check),
              snackPosition: SnackPosition.TOP);
          _isLoading.value = false;
        });
      });
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  // Ajout des commandes à l'ardoise
  void tableUpdateData(ArdoiseModel data, List<CartModel> cartList) async {
    try {
      _isLoading.value = true;
      final jsonList = jsonEncode(cartList);
      final dataItem = ArdoiseModel(
        id: data.id,
        ardoise: data.ardoise,
        ardoiseJson: jsonList,
        statut: 'true',
        succursale: profilController.user.succursale,
        signature: profilController.user.matricule,
        created: Timestamp.now(),
      );
      await ardoiseApi.updateData(dataItem).then((value) {
        clear();
        cartController.cartList.clear();
        ardoiseList.clear();
        getList();
        Get.back();
        Get.snackbar("Ajout effectuée avec succès!", "",
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

  // Ajout des commandes à l'ardoise
  void closeTable(ArdoiseModel data) async {
    try {
      _isLoading.value = true;
      final dataItem = ArdoiseModel(
        id: data.id,
        ardoise: data.ardoise,
        ardoiseJson: '',
        statut: 'false',
        succursale: profilController.user.succursale,
        signature: profilController.user.matricule,
        created: Timestamp.now(),
      );
      await ardoiseApi.updateData(dataItem).then((value) {
        clear();
        ardoiseList.clear();
        getList();
        Get.back();
        Get.snackbar("Modification effectuée avec succès!", "",
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

  // Restitution objet dans cart
  void insertDataCart(CartModel data) async {
    try {
      _isLoading.value = true;
      final cartModel = CartModel(
        idProductCart: data.idProductCart,
        quantityCart: data.quantityCart, // controllerQuantityCart.toString(),
        priceCart: data.priceCart,
        priceAchatUnit: data.priceAchatUnit,
        unite: data.unite,
        tva: data.tva,
        remise: data.remise,
        qtyRemise: data.qtyRemise,
        succursale: data.succursale,
        signature: data.signature,
        created: data.created,
        createdAt: data.createdAt,
      );
      await cartApi.insertData(cartModel).then((value) { 
        // clear();
        // ardoiseList.clear();
        // getList();
        // Get.back();
        // Get.snackbar("Rest effectuée avec succès!", "",
        //     backgroundColor: Colors.green,
        //     icon: const Icon(Icons.check),
        //     snackPosition: SnackPosition.TOP);
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
