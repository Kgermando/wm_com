import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/constants/responsive.dart';
import 'package:wm_commercial/src/helpers/monnaire_storage.dart';
import 'package:wm_commercial/src/models/commercial/cart_model.dart';
import 'package:wm_commercial/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_commercial/src/navigation/header/header_bar.dart';
import 'package:wm_commercial/src/pages/commercial/components/ardoise/table_ardoise_cart.dart';
import 'package:wm_commercial/src/pages/commercial/controller/ardoise/ardoise_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/cart/cart_controller.dart';
import 'package:wm_commercial/src/routes/routes.dart';
import 'package:wm_commercial/src/widgets/loading.dart';
import 'package:wm_commercial/src/widgets/title_widget.dart';

import 'package:wm_commercial/src/models/commercial/ardoise_model.dart';

class DetailArdoise extends StatefulWidget {
  const DetailArdoise({super.key, required this.ardoiseModel});
  final ArdoiseModel ardoiseModel;

  @override
  State<DetailArdoise> createState() => _DetailArdoiseState();
}

class _DetailArdoiseState extends State<DetailArdoise> {
  final ArdoiseController controller = Get.find();
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final CartController cartController = Get.find();
  // final FactureCartPDFA6 factureCartPDFA6 = Get.put(FactureCartPDFA6());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";

  @override
  initState() {
    controller.ardoiseController =
        TextEditingController(text: widget.ardoiseModel.ardoise);
    super.initState();
  }

  Future<ArdoiseModel> refresh() async {
    final ArdoiseModel dataItem =
        await controller.detailView(widget.ardoiseModel.id!);
    return dataItem;
  }

  @override
  Widget build(BuildContext context) { 
    List<dynamic> cartItem = [];
    if (widget.ardoiseModel.ardoiseJson != "") { 
      cartItem = jsonDecode(widget.ardoiseModel.ardoiseJson) as List;
    }
   
    List<CartModel> cartListItem = [];

    for (var element in cartItem) {
      cartListItem.add(CartModel.fromJson(element));
    }

    return Scaffold(
      key: scaffoldKey,
      appBar:
          headerBar(context, scaffoldKey, title, widget.ardoiseModel.ardoise),
      drawer: const DrawerMenu(),
      floatingActionButton: (widget.ardoiseModel.ardoiseJson != "")
          ? speedialWidget(cartListItem)
          : Container(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: !Responsive.isMobile(context),
              child: const Expanded(flex: 1, child: DrawerMenu())),
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
                  controller: ScrollController(),
                  physics: const ScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: p20,
                        bottom: p8,
                        right: Responsive.isMobile(context) ? 0 : p20,
                        left: Responsive.isMobile(context) ? 0 : p20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: p20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TitleWidget(
                                        title: widget.ardoiseModel.ardoise.toUpperCase()),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  refresh().then((value) =>
                                                      Navigator.pushNamed(
                                                          context,
                                                          ComRoutes
                                                              .comArdoiseDetail,
                                                          arguments: value));
                                                },
                                                icon: const Icon(Icons.refresh,
                                                    color: Colors.green)),
                                            if (widget
                                                    .ardoiseModel.ardoiseJson ==
                                                "")
                                            editButton(),
                                            if (widget
                                                    .ardoiseModel.ardoiseJson ==
                                                "")
                                            deleteButton(),
                                          ],
                                        ),
                                        SelectableText(
                                            DateFormat("dd-MM-yy HH:mm").format(
                                                widget.ardoiseModel.created.toDateTime()),
                                            textAlign: TextAlign.start),
                                      ],
                                    )
                                  ],
                                ),
                                // Divider(
                                //   color: mainColor,
                                // ),
                                // dataWidget(),
                              ],
                            ),
                          ),
                        ),
                        if (widget.ardoiseModel.ardoiseJson != "")
                        TableArdoiseCart(
                          cartList:
                              jsonDecode(widget.ardoiseModel.ardoiseJson)
                                  as List,
                          ardoiseModel: widget.ardoiseModel,
                        ),
                        const SizedBox(height: p20),
                        if (widget.ardoiseModel.ardoiseJson != "") totalCart(),

                        const SizedBox(height: 100),
                        if (widget.ardoiseModel.ardoiseJson == "")
                        Center(
                          child: Icon(Icons.table_bar_outlined, color: Colors.green, size: MediaQuery.of(context).size.height / 3)),
                        if (widget.ardoiseModel.ardoiseJson == "")
                        Text("${widget.ardoiseModel.ardoise} disponible", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }

  Widget totalCart() {
    final headlineSmall = Theme.of(context).textTheme.headlineSmall;

    List<dynamic> cartItem;
    cartItem = jsonDecode(widget.ardoiseModel.ardoiseJson) as List;

    List<CartModel> cartItemList = [];

    for (var element in cartItem) {
      cartItemList.add(CartModel.fromJson(element));
    }

    double sumCart = 0;
    for (var data in cartItemList) {
      var qtyRemise = double.parse(data.qtyRemise);
      var quantity = double.parse(data.quantityCart);
      if (quantity >= qtyRemise) {
        sumCart += double.parse(data.remise) * double.parse(data.quantityCart);
      } else {
        sumCart +=
            double.parse(data.priceCart) * double.parse(data.quantityCart);
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: p30, horizontal: p10),
      child: Row(
        mainAxisAlignment: Responsive.isMobile(context) ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Container(
              decoration: BoxDecoration(
                  border: Border(
                left: BorderSide(
                  color: mainColor,
                  width: 2,
                ),
              )),
              child: Padding(
                padding: const EdgeInsets.only(left: p10),
                child: Text("Total: ",
                    style: headlineSmall!.copyWith(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold)),
              )),
          const SizedBox(width: p20),
          Text(
              "${NumberFormat.decimalPattern('fr').format(sumCart)} ${monnaieStorage.monney}",
              textAlign: TextAlign.center,
              maxLines: 1,
              style: headlineSmall.copyWith(color: Colors.red.shade700))
        ],
      ),
    );
  }

  SpeedDial speedialWidget(List<CartModel> cartListItem) {
    return SpeedDial(
      closedForegroundColor: themeColor,
      openForegroundColor: Colors.white,
      closedBackgroundColor: themeColor,
      openBackgroundColor: themeColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
            child: const Icon(Icons.add_shopping_cart),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            label: 'Vente au comptant',
            onPressed: () {
              newAComptantDialog(cartListItem);
            }),
        SpeedDialChild(
            child: const Icon(Icons.add_shopping_cart),
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
            label: 'Vente à crédit',
            onPressed: () {
              newACreditDialog(cartListItem);
            }),
      ],
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }

  newAComptantDialog(List<CartModel> cartListItem) {
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
                  child: Obx(() => cartController.isFactureLoading
                      ? loading()
                      : Form(
                          key: cartController.factureFormKey,
                          child: Column(
                            children: [
                              nomClientWidget(),
                              telephoneWidget(),
                            ],
                          )))),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    final form = cartController.factureFormKey.currentState!;
                    if (form.validate()) {
                      cartController.submitFacture(cartListItem);
                      controller.closeTable(widget.ardoiseModel);
                      form.reset();
                    }
                  },
                  child: const Text('📨 Save'),
                ),
                TextButton(
                  onPressed: () {
                    final form = cartController.factureFormKey.currentState!;
                    if (form.validate()) {
                      cartController.submitFacture(cartListItem);
                      cartController.createFacturePDF(cartListItem);
                      controller.closeTable(widget.ardoiseModel);
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

  newACreditDialog(List<CartModel> cartListItem) {
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
                  child: Obx(() => cartController.isCreanceLoading
                      ? loading()
                      : Form(
                          key: cartController.creanceFormKey,
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
                    final form = cartController.creanceFormKey.currentState!;
                    if (form.validate()) {
                      cartController.submitFactureCreance(cartListItem);
                      controller.closeTable(widget.ardoiseModel);
                      form.reset();
                    }
                  },
                  child: const Text('📨 Save'),
                ),
                TextButton(
                  onPressed: () {
                    final form = cartController.creanceFormKey.currentState!;
                    if (form.validate()) {
                      cartController.submitFactureCreance(cartListItem);
                      cartController.createPDFCreance(cartListItem);
                      controller.closeTable(widget.ardoiseModel);
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

  Widget nomClientWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: cartController.nomClientController,
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
          controller: cartController.telephoneController,
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
          controller: cartController.nomClientAcreditController,
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
          controller: cartController.telephoneAcreditController,
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
          controller: cartController.addresseAcreditController,
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
          controller: cartController.delaiPaiementAcreditController,
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

  Widget editButton() {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.purple.shade700),
      tooltip: "Modification du nom",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title:
              Text('Modification du nom', style: TextStyle(color: mainColor)),
          content: SizedBox(
            height: 200,
            child: Obx(() => controller.isLoading
                ? loading()
                : Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        nomTabletWidget(),
                      ],
                    ))),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                controller.updateData(widget.ardoiseModel);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget nomTabletWidget() {
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: TextFormField(
          controller: controller.ardoiseController,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: 'Nom de la table',
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

  Widget deleteButton() {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red.shade700),
      tooltip: "Supprimer",
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Etes-vous sûr de supprimer ceci?',
              style: TextStyle(color: Colors.red.shade700)),
          content: const Text(
              'Cette action permet de supprimer définitivement ce document.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text('Annuler',
                  style: TextStyle(color: Colors.red.shade700)),
            ),
            TextButton(
              onPressed: () {
                controller.deleteData(widget.ardoiseModel.id!);
                Navigator.pop(context, 'ok');
              },
              child: Text('OK',
                  style: TextStyle(color: Colors.red.shade700)),
            ),
          ],
        ),
      ),
    );
  }
}
