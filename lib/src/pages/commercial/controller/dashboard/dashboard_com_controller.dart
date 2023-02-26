import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:sembast/timestamp.dart';
import 'package:wm_commercial/src/api/commerciale/vente_gain_api.dart';
import 'package:wm_commercial/src/models/commercial/cart_model.dart';
import 'package:wm_commercial/src/models/commercial/courbe_vente_gain_model.dart';
import 'package:wm_commercial/src/models/commercial/vente_chart_model.dart';
import 'package:wm_commercial/src/pages/commercial/controller/ardoise/ardoise_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/factures/facture_creance_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/gains/gain_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/history/history_vente_controller.dart';
import 'package:wm_commercial/src/pages/finance/controller/caisses/caisse_controller.dart';

class DashboardComController extends GetxController {
  final VenteGainApi venteGainApi = VenteGainApi();
  final VenteCartController venteCartController = Get.find();
  final GainCartController gainController = Get.find();
  final FactureCreanceController factureCreanceController = Get.find();
  final CaisseController caisseController = Get.put(CaisseController());

  final ArdoiseController ardoiseController = Get.put(ArdoiseController());

  // 10 produits le plus vendu
  var venteChartList = <VenteChartModel>[].obs;

  var venteDayList = <CourbeVenteModel>[].obs;
  var gainDayList = <CourbeGainModel>[].obs;

  var venteMouthList = <CourbeVenteModel>[].obs;
  var gainMouthList = <CourbeGainModel>[].obs;

  var venteYearList = <CourbeVenteModel>[].obs;
  var gainYearList = <CourbeGainModel>[].obs;

  final _sumGain = 0.0.obs;
  double get sumGain => _sumGain.value;
  final _sumVente = 0.0.obs;
  double get sumVente => _sumVente.value;
  final _sumDCreance = 0.0.obs;
  double get sumDCreance => _sumDCreance.value;

//  Finance
  // Caisse
  final _recetteCaisse = 0.0.obs;
  double get recetteCaisse => _recetteCaisse.value;
  final _depensesCaisse = 0.0.obs;
  double get depensesCaisse => _depensesCaisse.value;
  final _soldeCaisse = 0.0.obs;
  double get soldeCaisse => _soldeCaisse.value;

  // Tables
  final _tableCount = 0.obs;
  int get tableCount => _tableCount.value;
  final _tableCountBusy = 0.obs;
  int get tableCountBusy => _tableCountBusy.value;

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    // _sumGain = 0.0.obs;
    // _sumVente = 0.0.obs;
    // _sumDCreance = 0.0.obs;
    // _recetteCaisse = 0.0.obs;
    // _depensesCaisse = 0.0.obs;
    // _soldeCaisse = 0.0.obs;

    venteChartList.clear();
    venteDayList.clear();
    gainDayList.clear();
    gainMouthList.clear();
    gainMouthList.clear();
    venteYearList.clear();
    gainYearList.clear();
    getData();
  }

  //   @override
  // void refresh() {
  //   getData();
  //   super.refresh();
  // }

  Future<void> getData() async {
    var getVenteChart = await VenteGainApi().getVenteChart();

    var getAllDataVenteDay = await VenteGainApi().getAllDataVenteDay();
    var getAllDataGainDay = await VenteGainApi().getAllDataGainDay();

    var getAllDataVenteMouth = await VenteGainApi().getAllDataVenteMouth();
    var getAllDataGainMouth = await VenteGainApi().getAllDataGainMouth();

    var getAllDataVenteYear = await VenteGainApi().getAllDataVenteYear();
    var getAllDataGainYear = await VenteGainApi().getAllDataGainYear();

    var gains = await gainController.gainApi.getAllData();
    var ventes = await venteCartController.venteCartApi.getAllData();
    var factureCreance =
        await factureCreanceController.creanceFactureApi.getAllData();

    var dataCaisseList = await caisseController.caisseApi.getAllData();

    var ardoiseList = await ardoiseController.ardoiseApi.getAllData();

    venteChartList.clear();
    venteDayList.clear();
    gainDayList.clear();
    gainMouthList.clear();
    gainMouthList.clear();
    venteYearList.clear();
    gainYearList.clear();

    venteChartList.addAll(getVenteChart);
    venteDayList.addAll(getAllDataVenteDay);
    gainDayList.addAll(getAllDataGainDay);
    venteMouthList.addAll(getAllDataVenteMouth);
    gainMouthList.addAll(getAllDataGainMouth);
    venteYearList.addAll(getAllDataVenteYear);
    gainYearList.addAll(getAllDataGainYear);

    // Gain
    var dataGain = gains
        .where((element) =>
            element.created.toDateTime().day ==
            Timestamp.now().toDateTime().day)
        .map((e) => e.sum)
        .toList();
    for (var data in dataGain) {
      _sumGain.value += data;
    }

    // Ventes
    var dataPriceVente = ventes
        .where((element) =>
            element.created.toDateTime().day ==
            Timestamp.now().toDateTime().day)
        .map((e) => double.parse(e.priceTotalCart))
        .toList();
    for (var data in dataPriceVente) {
      _sumVente.value += data;
    }

    // Créances
    for (var item in factureCreance) {
      final cartItem = jsonDecode(item.cart) as List;
      List<CartModel> cartItemList = [];

      for (var element in cartItem) {
        cartItemList.add(CartModel.fromJson(element));
      }

      for (var data in cartItemList) {
        if (double.parse(data.quantityCart) >= double.parse(data.qtyRemise)) {
          double total =
              double.parse(data.remise) * double.parse(data.quantityCart);
          _sumDCreance.value += total;
        } else {
          double total =
              double.parse(data.priceCart) * double.parse(data.quantityCart);
          _sumDCreance.value += total;
        }
      }
    }

    // Caisse
    var recetteCaisseList = dataCaisseList
        .where((element) => element.typeOperation == "Encaissement")
        .toList();
    var depensesCaisseList = dataCaisseList
        .where((element) => element.typeOperation == "Decaissement")
        .toList();
    for (var item in recetteCaisseList) {
      _recetteCaisse.value += double.parse(item.montantEncaissement);
    }
    for (var item in depensesCaisseList) {
      _depensesCaisse.value += double.parse(item.montantDecaissement);
    }
    _soldeCaisse.value = _recetteCaisse.value - _depensesCaisse.value;

    // Ardoise
    _tableCount.value = ardoiseList.length;
    _tableCountBusy.value =
        ardoiseList.where((element) => element.ardoiseJson != '').length;

    update();
  }
}
