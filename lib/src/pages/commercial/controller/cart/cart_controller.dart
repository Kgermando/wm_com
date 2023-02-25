// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sembast/timestamp.dart';
import 'package:wm_commercial/src/api/commerciale/cart_api.dart';
import 'package:wm_commercial/src/helpers/monnaire_storage.dart';
import 'package:wm_commercial/src/models/commercial/achat_model.dart';
import 'package:wm_commercial/src/models/commercial/cart_model.dart';
import 'package:wm_commercial/src/models/commercial/creance_cart_model.dart';
import 'package:wm_commercial/src/models/commercial/facture_cart_model.dart';
import 'package:wm_commercial/src/models/commercial/gain_model.dart';
import 'package:wm_commercial/src/models/commercial/number_facture.dart';
import 'package:wm_commercial/src/models/commercial/vente_cart_model.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/pages/commercial/components/factures/pdf_a6/creance_cart_a6_pdf.dart';
import 'package:wm_commercial/src/pages/commercial/components/factures/pdf_a6/facture_cart_a6_pdf.dart';
import 'package:wm_commercial/src/pages/commercial/controller/achats/achat_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/factures/facture_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/factures/facture_creance_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/factures/numero_facture_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/gains/gain_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/history/history_vente_controller.dart';

class CartController extends GetxController with StateMixin<List<CartModel>> {
  final CartApi cartApi = CartApi();

  final FactureController factureController = Get.find();
  final FactureCreanceController factureCreanceController = Get.find();
  final NumeroFactureController numeroFactureController = Get.find();
  final GainCartController gainController = Get.find();
  final VenteCartController venteCartController = Get.find();
  final AchatController achatController = Get.find();
  final ProfilController profilController = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final FactureCartPDFA6 factureCartPDFA6 = Get.put(FactureCartPDFA6());
  final CreanceCartPDFA6 creanceCartPDFA6 = Get.put(CreanceCartPDFA6());

  var cartList = <CartModel>[].obs;

  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isLoadingCancel = false.obs;
  bool get isLoadingCancel => _isLoadingCancel.value;

  // String? controllerQuantityCart;
  // TextEditingController quantityCartController = TextEditingController();

  final GlobalKey<FormState> factureFormKey = GlobalKey<FormState>();
  final _isFactureLoading = false.obs;
  bool get isFactureLoading => _isFactureLoading.value;

  final GlobalKey<FormState> creanceFormKey = GlobalKey<FormState>();
  final _isCreanceLoading = false.obs;
  bool get isCreanceLoading => _isCreanceLoading.value;

  // Au comptant
  TextEditingController nomClientController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();

  // A crédit
  TextEditingController nomClientAcreditController = TextEditingController();
  TextEditingController telephoneAcreditController = TextEditingController();
  TextEditingController addresseAcreditController = TextEditingController();
  TextEditingController delaiPaiementAcreditController =
      TextEditingController();


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
    // quantityCartController.dispose();
    nomClientController.dispose();
    telephoneController.dispose();

    nomClientAcreditController.dispose();
    telephoneAcreditController.dispose();
    addresseAcreditController.dispose();
    delaiPaiementAcreditController.dispose();
    super.dispose();
  }

  void clear() {
    // quantityCartController.clear();
    // controllerQuantityCart = null;

    nomClientController.clear();
    telephoneController.clear();

    nomClientAcreditController.clear();
    telephoneAcreditController.clear();
    addresseAcreditController.clear();
    delaiPaiementAcreditController.clear();
  }



  void getList() async { 
    await cartApi.getAllData(profilController.user.matricule).then((response) {
      cartList.clear();
      cartList.addAll(response); 
      change(cartList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await cartApi.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await cartApi.deleteData(id).then((value) {
        getList();
        // Get.back();
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

  void addCart(AchatModel achat, TextEditingController quantityCartController) async {
    try {
      _isLoading.value = true;
      final cartModel = CartModel(
          idProductCart: achat.idProduct,
          quantityCart:
              quantityCartController.text, // controllerQuantityCart.toString(),
          priceCart: achat.prixVenteUnit,
          priceAchatUnit: achat.priceAchatUnit,
          unite: achat.unite,
          tva: achat.tva,
          remise: achat.remise,
          qtyRemise: achat.qtyRemise,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: Timestamp.now(),
          createdAt: achat.created.toDateTime());
      await cartApi.insertData(cartModel).then((value) async {
        var qty =
            double.parse(achat.quantity) - double.parse(value.quantityCart);
        final achatModel = AchatModel(
            id: achat.id!,
            idProduct: achat.idProduct,
            quantity: qty.toString(),
            quantityAchat: achat.quantityAchat,
            priceAchatUnit: achat.priceAchatUnit,
            prixVenteUnit: achat.prixVenteUnit,
            unite: achat.unite,
            tva: achat.tva,
            remise: achat.remise,
            qtyRemise: achat.qtyRemise,
            qtyLivre: achat.qtyLivre,
            succursale: achat.succursale,
            signature: achat.signature,
            created: achat.created);
        await achatController.achatApi.updateData(achatModel).then((value) {
          clear();
          cartList.clear();
          getList();
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

  Future<void> submitFacture(List<CartModel> cartListItem) async {
    try {
      _isFactureLoading.value = true;
      final jsonList = jsonEncode(cartListItem);
      final factureCartModel = FactureCartModel(
          cart: jsonList,
          client: '${numeroFactureController.numberFactureList.length + 1}',
          nomClient:
              (nomClientController.text == '') ? '-' : nomClientController.text,
          telephone:
              (telephoneController.text == '') ? '-' : telephoneController.text,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: Timestamp.now());
      await factureController.factureApi
          .insertData(factureCartModel)
          .then((value) async {
        // Genere le numero de la facture
        numberFactureField(value.client, value.succursale, value.signature);
        // Ajout des items dans historique
        venteHisotory(cartListItem);
        // Add Gain par produit
        gainVentes(cartListItem);
        // Vide de la panier
        cleanCart().then((value) {
          clear();
          getList();
          Get.back();
          // Get.snackbar("Ajoutée avec succès!",
          //     "Le document a bien été soumis",
          //     backgroundColor: Colors.green,
          //     icon: const Icon(Icons.check),
          //     snackPosition: SnackPosition.TOP);
        });
      });
      _isFactureLoading.value = false;
    } catch (e) {
      _isFactureLoading.value = false;
      Get.snackbar("Erreur lors de la soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  // PDF Generate Facture
  Future<void> createFacturePDF(List<CartModel> cartListItem) async {
    try {
      _isFactureLoading.value = true;
      final jsonList = jsonEncode(cartListItem);
      final factureCartModel = FactureCartModel(
          cart: jsonList,
          client: '${numeroFactureController.numberFactureList.length + 1}',
          nomClient:
              (nomClientController.text == '') ? '-' : nomClientController.text,
          telephone:
              (telephoneController.text == '') ? '-' : telephoneController.text,
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: Timestamp.now());
      List<FactureCartModel> factureList = [];
      factureList.add(factureCartModel);
      // ignore: unused_local_variable
      FactureCartModel? facture;
      for (var item in factureList) {
        facture = item;
      }
      factureCartPDFA6.generatePdf(facture!, monnaieStorage.monney);
      clear();
      _isFactureLoading.value = false;
    } catch (e) {
      _isFactureLoading.value = false;
      Get.snackbar("Erreur lors de la soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> submitFactureCreance(List<CartModel> cartListItem) async {
    try {
      _isCreanceLoading.value = true;
      final jsonList = jsonEncode(cartListItem);
      final creanceCartModel = CreanceCartModel(
          cart: jsonList,
          client: '${numeroFactureController.numberFactureList.length + 1}',
          nomClient: (nomClientAcreditController.text == '')
              ? '-'
              : nomClientAcreditController.text,
          telephone: (telephoneAcreditController.text == '')
              ? '-'
              : nomClientAcreditController.text,
          addresse: (addresseAcreditController.text == '')
              ? '-'
              : addresseAcreditController.text,
          delaiPaiement: Timestamp.parse(
                  (delaiPaiementAcreditController.text == '')
                      ? '2050-07-19 00:00:00'
                      : delaiPaiementAcreditController.text)
              .toDateTime(),
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: Timestamp.now());
      await factureCreanceController.creanceFactureApi
          .insertData(creanceCartModel)
          .then((value) {
        numberFactureField(value.client, value.succursale, value.signature);
        // Ajout des items dans historique
        venteHisotory(cartListItem);
        // Add Gain par produit
        gainVentes(cartListItem);
        // Vide de la panier
        cleanCart().then((value) {
          clear();
          getList();
          Get.back();
          // Get.snackbar("Ajoutée avec succès!",
          //     "Le document a bien été soumis",
          //     backgroundColor: Colors.green,
          //     icon: const Icon(Icons.check),
          //     snackPosition: SnackPosition.TOP);
        });
        _isCreanceLoading.value = false;
      });
    } catch (e) {
      _isCreanceLoading.value = false;
      Get.snackbar("Erreur lors de la soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  // PDF Generate Creance
  Future<void> createPDFCreance(List<CartModel> cartListItem) async {
    try {
      _isCreanceLoading.value = true;
      final jsonList = jsonEncode(cartListItem);
      final creanceCartModel = CreanceCartModel(
          cart: jsonList,
          client: '${numeroFactureController.numberFactureList.length + 1}',
          nomClient: (nomClientAcreditController.text == '')
              ? '-'
              : nomClientAcreditController.text,
          telephone: (telephoneAcreditController.text == '')
              ? '-'
              : nomClientAcreditController.text,
          addresse: (addresseAcreditController.text == '')
              ? '-'
              : addresseAcreditController.text,
          delaiPaiement: Timestamp.parse(
                  (delaiPaiementAcreditController.text == '')
                      ? '2050-07-19 00:00:00'
                      : delaiPaiementAcreditController.text)
              .toDateTime(),
          succursale: profilController.user.succursale,
          signature: profilController.user.matricule,
          created: Timestamp.now());

      List<CreanceCartModel> creanceList = [];
      creanceList.add(creanceCartModel);
      // ignore: unused_local_variable
      CreanceCartModel? creance;

      for (var item in creanceList) {
        creance = item;
      }
      creanceCartPDFA6.generatePdf(creance!, monnaieStorage.monney);
      // await CreanceCartPDFA6.generate(creance!, monnaieStorage);
      clear();
      _isCreanceLoading.value = false;
    } catch (e) {
      _isCreanceLoading.value = false;
      Get.snackbar("Erreur lors de la soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> cleanCart() async {
    await CartApi().deleteAllData(profilController.user.matricule);
  }

  Future<void> numberFactureField(
      String number, String succursale, String signature) async {
    final numberFactureModel = NumberFactureModel(
        number: number,
        succursale: succursale,
        signature: signature,
        created: Timestamp.now());
    await numeroFactureController.numberFactureApi
        .insertData(numberFactureModel);
  }

  Future<void> venteHisotory(List<CartModel> cartItemList) async {
    cartItemList.forEach((item) async {
      double priceTotal = 0;
      if (double.parse(item.quantityCart) >= double.parse(item.qtyRemise)) {
        priceTotal =
            double.parse(item.quantityCart) * double.parse(item.remise);
      } else {
        priceTotal =
            double.parse(item.quantityCart) * double.parse(item.priceCart);
      }
      final venteCartModel = VenteCartModel(
          idProductCart: item.idProductCart,
          quantityCart: item.quantityCart,
          priceTotalCart: priceTotal.toString(),
          unite: item.unite,
          tva: item.tva,
          remise: item.remise,
          qtyRemise: item.qtyRemise,
          succursale: item.succursale,
          signature: item.signature,
          created: item.created,
          createdAt: item.createdAt);
      await venteCartController.venteCartApi.insertData(venteCartModel);
    });
  }

  Future<void> gainVentes(List<CartModel> cartItemList) async {
    cartItemList.forEach((item) async {
      double gainTotal = 0;
      if (double.parse(item.quantityCart) >= double.parse(item.qtyRemise)) {
        gainTotal =
            (double.parse(item.remise) - double.parse(item.priceAchatUnit)) *
                double.parse(item.quantityCart);
      } else {
        gainTotal =
            (double.parse(item.priceCart) - double.parse(item.priceAchatUnit)) *
                double.parse(item.quantityCart);
      }
      final gainModel = GainModel(
          sum: gainTotal,
          succursale: item.succursale,
          signature: item.signature,
          created: item.created);
      await gainController.gainApi.insertData(gainModel);
    });
  }

  updateAchat(CartModel cart) async {
    try {
      _isLoadingCancel.value = true;
      final achatQtyList = achatController.achatList
          .where((e) => e.idProduct == cart.idProductCart);

      final achatQty = achatQtyList
          .map(
              (e) => double.parse(e.quantity) + double.parse(cart.quantityCart))
          .first;

      final achatIdProduct = achatQtyList.map((e) => e.idProduct).first;
      final achatQuantityAchat = achatQtyList.map((e) => e.quantityAchat).first;
      final achatAchatUnit = achatQtyList.map((e) => e.priceAchatUnit).first;
      final achatPrixVenteUnit = achatQtyList.map((e) => e.prixVenteUnit).first;
      final achatUnite = achatQtyList.map((e) => e.unite).first;
      final achatId = achatQtyList.map((e) => e.id).first;
      final achattva = achatQtyList.map((e) => e.tva).first;
      final achatRemise = achatQtyList.map((e) => e.remise).first;
      final achatQtyRemise = achatQtyList.map((e) => e.qtyRemise).first;
      final achatQtyLivre = achatQtyList.map((e) => e.qtyLivre).first;
      final achatSuccursale = achatQtyList.map((e) => e.succursale).first;
      final achatSignature = achatQtyList.map((e) => e.signature).first;
      final achatCreated = achatQtyList.map((e) => e.created).first;

      final achatModel = AchatModel(
          id: achatId!,
          idProduct: achatIdProduct,
          quantity: achatQty.toString(),
          quantityAchat: achatQuantityAchat,
          priceAchatUnit: achatAchatUnit,
          prixVenteUnit: achatPrixVenteUnit,
          unite: achatUnite,
          tva: achattva,
          remise: achatRemise,
          qtyRemise: achatQtyRemise,
          qtyLivre: achatQtyLivre,
          succursale: achatSuccursale,
          signature: achatSignature,
          created: achatCreated);
      await achatController.achatApi.updateData(achatModel);
      deleteData(cart.id!);
      _isLoadingCancel.value = false;
    } catch (e) {
      _isLoadingCancel.value = false;
      Get.snackbar("Une Erreur ", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }
}
