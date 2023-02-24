import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/helpers/monnaire_storage.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/constants/responsive.dart';
import 'package:wm_commercial/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_commercial/src/navigation/header/header_bar.dart';
import 'package:wm_commercial/src/pages/commercial/controller/achats/achat_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/produit_model/produit_model_controller.dart';
import 'package:wm_commercial/src/utils/regex.dart';
import 'package:wm_commercial/src/widgets/btn_widget.dart';
import 'package:wm_commercial/src/widgets/responsive_child_widget.dart';
import 'package:wm_commercial/src/widgets/title_widget.dart';

class AddAchat extends StatefulWidget {
  const AddAchat({super.key});

  @override
  State<AddAchat> createState() => _AddAchatState();
}

class _AddAchatState extends State<AddAchat> {
  final MonnaieStorage monnaieStorage = Get.put(MonnaieStorage());
  final AchatController controller = Get.find();
  final ProduitModelController produitModelController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  String subTitle = "Ajout stock";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: headerBar(context, scaffoldKey, title, subTitle),
      drawer: const DrawerMenu(),
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
                        right: Responsive.isDesktop(context) ? p20 : 0,
                        left: Responsive.isDesktop(context) ? p20 : 0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Card(
                          elevation: 3,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: p20),
                            child: Form(
                              key: controller.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TitleWidget(title: "Ajout stock"),
                                  const SizedBox(
                                    height: p10,
                                  ),
                                  idProductField(),
                                  ResponsiveChildWidget(
                                      child1: quantityAchatField(),
                                      child2: priceAchatUnitField()),
                                  ResponsiveChildWidget(
                                      child1: prixVenteField(),
                                      child2: tvaField()),
                                  ResponsiveChildWidget(
                                      child1: qtyRemiseField(),
                                      child2: remiseField()),
                                  const SizedBox(
                                    height: p20,
                                  ),
                                  Obx(() => BtnWidget(
                                      title: 'Soumettre',
                                      isLoading: controller.isLoading,
                                      press: () {
                                        final form =
                                            controller.formKey.currentState!;
                                        if (form.validate()) {
                                          controller.submit();
                                          form.reset();
                                        }
                                      }))
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )))
        ],
      ),
    );
  }

  Widget idProductField() {
    List<String> prod = [];
    List<String> stocks = [];
    List<String> catList = [];

    prod = produitModelController.produitModelList
        .map((e) => e.idProduct)
        .toSet()
        .toList();
    stocks = controller.achatList.map((e) => e.idProduct).toSet().toList();

    catList = prod.toSet().difference(stocks.toSet()).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Identifiant du produit',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: controller.idProduct,
        isExpanded: true,
        // style: const TextStyle(color: Colors.deepPurple),
        items: catList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            controller.idProduct = value!;
          });
        },
      ),
    );
  }

  Widget quantityAchatField() {
    return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            labelText: 'Quantité entrer',
            labelStyle: const TextStyle(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'La Quantité total est obligatoire';
            } else if (RegExpIsValide().isValideVente.hasMatch(value!)) {
              return 'chiffres obligatoire';
            } else {
              return null;
            }
          },
          onChanged: (value) => setState(() {
            controller.quantityAchat = value.trim();
          }),
        ));
  }

  Widget priceAchatUnitField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: 'Prix d\'achat unitaire',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (value != null && value.isEmpty) {
            return 'Le Prix total d\'achat est obligatoire';
          } else if (RegExpIsValide().isValideVente.hasMatch(value!)) {
            return 'chiffres obligatoire';
          } else {
            return null;
          }
        },
        onChanged: (value) => setState(() {
          controller.priceAchatUnit = value.trim();
        }),
      ),
    );
  }

  Widget prixVenteField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: 'Prix de vente unitaire',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (value != null && value.isEmpty) {
            return 'Le Prix de vente unitaires est obligatoire';
          } else if (RegExpIsValide().isValideVente.hasMatch(value!)) {
            return 'chiffres obligatoire';
          } else {
            return null;
          }
        },
        onChanged: (value) => setState(() {
          controller.prixVenteUnit = (value == "") ? 0.0 : double.parse(value);
        }),
      ),
    );
  }

  Widget tvaField() {
    return ResponsiveChildWidget(
        flex1: 3,
        flex2: 1,
        child1: Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: TextFormField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: 'TVA en %',
              // hintText: 'Mettez "1" si vide',
              labelStyle: const TextStyle(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            validator: (value) {
              if (RegExpIsValide().isValideVente.hasMatch(value!)) {
                return 'chiffres obligatoire';
              } else {
                return null;
              }
            },
            onChanged: (value) => setState(() {
              controller.tva = (value == "") ? 0.0 : double.parse(value);
            }),
          ),
        ),
        child2: tvaValeur());
  }

  tvaValeur() {
    final titleLarge = Theme.of(context).textTheme.titleLarge;
    double pavTVA = 0;
    var pvau = controller.prixVenteUnit * controller.tva / 100;
    pavTVA = controller.prixVenteUnit + pvau;
    return Container(
        margin: const EdgeInsets.only(left: 10.0, bottom: 20.0),
        child: Column(
          children: [
            Text('P.V.U', style: titleLarge),
            Text('${pavTVA.toStringAsFixed(2)} ${monnaieStorage.monney}',
                style: titleLarge!.copyWith(fontWeight: FontWeight.bold)),
          ],
        ));
  }

  Widget remiseField() {
    return ResponsiveChildWidget(
        flex1: 3,
        flex2: 1,
        child1: Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: TextFormField(
            // controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: 'Remise en % (Facultatif) ',
              // hintText: 'Mettez "1" si vide',
              labelStyle: const TextStyle(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            validator: (value) {
              if (RegExpIsValide().isValideVente.hasMatch(value!)) {
                return 'chiffres obligatoire';
              } else {
                return null;
              }
            },
            onChanged: (value) => setState(() {
              controller.remise = (value == "") ? 0.0 : double.parse(value);
            }),
          ),
        ),
        child2: remiseValeur());
  }

  Widget qtyRemiseField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: 'Quantité pour la remise (Facultatif) ',
          // hintText: 'Mettez "1" si vide',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        validator: (value) {
          if (RegExpIsValide().isValideVente.hasMatch(value!)) {
            return 'chiffres obligatoire';
          } else {
            return null;
          }
        },
        onChanged: (value) => setState(() {
          controller.qtyRemise = (value == "") ? 0.0 : double.parse(value);
        }),
      ),
    );
  }

  double? pavTVARemise;

  remiseValeur() {
    var remiseEnPourcent = (controller.prixVenteUnit * controller.remise) / 100;
    pavTVARemise = controller.prixVenteUnit - remiseEnPourcent;
    return Container(
      margin: const EdgeInsets.only(left: 5.0, bottom: 20.0),
      child: Column(
        children: [
          Text('Remise',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.orange)),
          Text('${pavTVARemise!.toStringAsFixed(2)} ${monnaieStorage.monney}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.orange, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
