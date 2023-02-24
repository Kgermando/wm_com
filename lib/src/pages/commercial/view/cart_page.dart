import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/constants/responsive.dart';
import 'package:wm_commercial/src/helpers/monnaire_storage.dart';
import 'package:wm_commercial/src/models/commercial/ardoise_model.dart';
import 'package:wm_commercial/src/models/commercial/cart_model.dart';
import 'package:wm_commercial/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_commercial/src/navigation/header/header_bar.dart';
import 'package:wm_commercial/src/pages/commercial/components/cart/cart_item_widget.dart';
import 'package:wm_commercial/src/pages/commercial/controller/ardoise/ardoise_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/cart/cart_controller.dart';
import 'package:wm_commercial/src/routes/routes.dart';
import 'package:wm_commercial/src/widgets/loading.dart';
import 'package:wm_commercial/src/widgets/title_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final CartController controller = Get.find();
  final ArdoiseController ardoiseController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  String subTitle = "Panier";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title, subTitle),
      drawer: const DrawerMenu(),
      floatingActionButton: (controller.cartList.isNotEmpty)
          ? speedialWidget(controller)
          : Container(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenu())),
          Expanded(
              flex: 5,
              child: controller.obx(
                  onLoading: loadingPage(context),
                  onEmpty: const Text('Le panier est vide.'),
                  onError: (error) => loadingError(context, error!),
                  (state) => SingleChildScrollView(
                      controller: ScrollController(),
                      physics: const ScrollPhysics(),
                      child: Container(
                        margin: const EdgeInsets.only(top: p20, bottom: p8),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TitleWidget(title: 'Panier'),
                                IconButton(
                                    onPressed: () {
                                      // Navigator.pushNamed(
                                      //     context, ComRoutes.comCart);
                                      Get.toNamed(ComRoutes.comCart);
                                      controller.getList();
                                    },
                                    icon: const Icon(Icons.refresh,
                                        color: Colors.green))
                              ],
                            ),
                            Obx(() => ListView.builder(
                                shrinkWrap: true,
                                itemCount: state!.length,
                                itemBuilder: (context, index) {
                                  final cart = state[index];
                                  return CartItemWidget(
                                      cart: cart, controller: controller);
                                })),
                            Obx(() => SizedBox(
                                height: p50, child: totalCart(controller)))
                          ],
                        ),
                      ))))
        ],
      ),
    );
  }

  Widget totalCart(CartController controller) {
    // Montant a Vendre
    double sumCart = 0.0;

    var dataPriceCart = controller.cartList
        .map((e) => (double.parse(e.quantityCart) >= double.parse(e.qtyRemise))
            ? double.parse(e.remise) * double.parse(e.quantityCart)
            : double.parse(e.priceCart) * double.parse(e.quantityCart))
        .toList();

    for (var data in dataPriceCart) {
      sumCart += data;
    }

    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Text(
        'Total: ${NumberFormat.decimalPattern('fr').format(sumCart)} ${monnaieStorage.monney}',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700),
      ),
    );
  }

  SpeedDial speedialWidget(CartController controller) {
    return SpeedDial(
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
            child: const Icon(Icons.table_bar),
            foregroundColor: Colors.white,
            backgroundColor: Colors.pink.shade700,
            label: 'Table',
            onPressed: () {
              newArdoiseDialog();
            }),
        SpeedDialChild(
            child: const Icon(Icons.add_shopping_cart),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            label: 'Vente au comptant',
            onPressed: () {
              newAComptantDialog();
            }),
        SpeedDialChild(
            child: const Icon(Icons.add_shopping_cart),
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
            label: 'Vente à crédit',
            onPressed: () {
              newACreditDialog();
              // controller.submitFactureCreance();
            }),
      ],
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }

  newAComptantDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title:
                  Text('Vente au comptant', style: TextStyle(color: mainColor)),
              content: SizedBox(
                  height: 200,
                  width: 200,
                  child: Obx(() => controller.isFactureLoading
                      ? loading()
                      : Form(
                          key: controller.factureFormKey,
                          child: Column(
                            children: [
                              nomClientWidget(),
                              telephoneWidget(),
                            ],
                          )))),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    final form = controller.factureFormKey.currentState!;
                    if (form.validate()) {
                      controller.submitFacture(controller.cartList);
                      form.reset();
                    }
                  },
                  child: const Text('📨 Save'),
                ),
                TextButton(
                  onPressed: () {
                    final form = controller.factureFormKey.currentState!;
                    if (form.validate()) {
                      controller.submitFacture(controller.cartList);
                      controller.createFacturePDF(controller.cartList);
                      form.reset();
                    }
                  },
                  child: const Text('🖨 Print'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          });
        });
  }

  newACreditDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Vente à Crédit',
                  style: TextStyle(color: Colors.orange)),
              content: SizedBox(
                  height: 400,
                  width: 300,
                  child: Obx(() => controller.isCreanceLoading
                      ? loading()
                      : Form(
                          key: controller.creanceFormKey,
                          child: Column(
                            children: [
                              nomClientACreditWidget(),
                              telephoneACreditWidget(),
                              adresseACreditWidget(),
                              delaiPaiementWidget(),
                            ],
                          )))),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    final form = controller.creanceFormKey.currentState!;
                    if (form.validate()) {
                      controller.submitFactureCreance(controller.cartList);
                      form.reset();
                    }
                  },
                  child: const Text('📨 Save'),
                ),
                TextButton(
                  onPressed: () {
                    final form = controller.creanceFormKey.currentState!;
                    if (form.validate()) {
                      controller.submitFactureCreance(controller.cartList);
                      controller.createPDFCreance(controller.cartList);
                      form.reset();
                    }
                  },
                  child: const Text('🖨 Print'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          });
        });
  }

  newArdoiseDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Selectionner la table',
                  style: TextStyle(color: Colors.orange)),
              content: SizedBox(
                  height: 200,
                  width: 300,
                  child: Obx(
                    () =>
                        controller.isCreanceLoading ? loading() : tableWidget(),
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          });
        });
  }

  Widget nomClientWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.nomClientController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom du client',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget telephoneWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.telephoneController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Téléphone',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          // validator: (value) {
          //   if (value != null && value.isEmpty) {
          //     return 'Ce champs est obligatoire';
          //   } else {
          //     return null;
          //   }
          // },
        ));
  }

  Widget nomClientACreditWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.nomClientAcreditController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom du client',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget telephoneACreditWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.telephoneAcreditController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Téléphone',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget adresseACreditWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.addresseAcreditController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Adresse',
          ),
          keyboardType: TextInputType.text,
          style: const TextStyle(),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget delaiPaiementWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: DateTimePicker(
          initialEntryMode: DatePickerEntryMode.input,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.date_range),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Delai de Paiement',
          ),
          controller: controller.delaiPaiementAcreditController,
          firstDate: DateTime(1930),
          lastDate: DateTime(2100),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
        ));
  }

  Widget tableWidget() {
    List<String> dataList = ardoiseController.ardoiseList
        .map((element) => element.ardoise)
        .toList();
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: ardoiseController.isLoading
          ? loading()
          : DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Selectionner la Table',
                labelStyle: const TextStyle(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                contentPadding: const EdgeInsets.only(left: 5.0),
              ),
              value: ardoiseController.table,
              isExpanded: true,
              items: dataList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  ardoiseController.table = value;
                  if (ardoiseController.table != null) {
                    List<CartModel> cartList = [];
                    ArdoiseModel ardoise = ardoiseController.ardoiseList
                        .where((p0) => p0.ardoise == ardoiseController.table)
                        .first;

                    if (ardoise.ardoiseJson != "") {
                      List<dynamic> ardoiseJson =
                          jsonDecode(ardoise.ardoiseJson);
                      List<CartModel> cartItemList = [];
                      for (var element in ardoiseJson) {
                        cartItemList.add(CartModel.fromJson(element));
                      }

                      for (var element in cartItemList) {
                        cartList.add(element);
                      }

                      for (var cart in controller.cartList) {
                        cartList.add(cart);
                      }
                      ardoiseController.tableInsertData(ardoise, cartList);
                      // Navigator.pop(context);
                    } else {
                      ardoiseController.tableInsertData(
                          ardoise, controller.cartList);
                      // Navigator.pop(context);
                    }
                  }
                });
              },
            ),
    );
  }
}
