import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/constants/responsive.dart';
import 'package:wm_commercial/src/models/commercial/prod_model.dart';
import 'package:wm_commercial/src/navigation/drawer/drawer_menu.dart';
import 'package:wm_commercial/src/navigation/header/header_bar.dart';
import 'package:wm_commercial/src/pages/commercial/controller/produit_model/produit_model_controller.dart';
import 'package:wm_commercial/src/utils/dropdown.dart';
import 'package:wm_commercial/src/widgets/btn_widget.dart';
import 'package:wm_commercial/src/widgets/responsive_child_widget.dart';
import 'package:wm_commercial/src/widgets/title_widget.dart';

class UpdateProductModele extends StatefulWidget {
  const UpdateProductModele({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  State<UpdateProductModele> createState() => _UpdateProductModeleState();
}

class _UpdateProductModeleState extends State<UpdateProductModele> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String title = "Commercial";
  final ProduitModelController controller = Get.find();

  @override
  initState() {
    setState(() {
      controller.categorieController = widget.productModel.categorie;
      controller.sousCategorie1Controller = widget.productModel.sousCategorie1;
      controller.sousCategorie2Controller = widget.productModel.sousCategorie2;
      controller.sousCategorie3Controller = widget.productModel.sousCategorie3;
      controller.uniteController = widget.productModel.sousCategorie4;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:
          headerBar(context, scaffoldKey, title, widget.productModel.idProduct),
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
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(p20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TitleWidget(
                                      title:
                                          "Modification de l'identifiant Produit"),
                                  const SizedBox(
                                    height: p20,
                                  ),
                                  categorieWidget(controller),
                                  ResponsiveChildWidget(
                                      child1: sousCategorie1Widget(controller),
                                      child2: sousCategorie2Widget(controller)),
                                  ResponsiveChildWidget(
                                      child1: sousCategorie3Widget(controller),
                                      child2: sousCategorie4Widget(controller)),
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
                                          controller.submitUpdate(
                                              widget.productModel);
                                          form.reset();
                                        }
                                      }))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  Widget categorieWidget(ProduitModelController controller) {
    List<String> suggestionList =
        controller.produitModelList.map((e) => e.categorie).toSet().toList();
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: EasyAutocomplete(
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Categorie",
          ),
          keyboardType: TextInputType.text,
          suggestions: suggestionList,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
          onChanged: (value) {
            controller.categorieController = value;
          },
        ));
  }

  Widget sousCategorie1Widget(ProduitModelController controller) {
    List<String> suggestionList = controller.produitModelList
        .map((e) => e.sousCategorie1)
        .toSet()
        .toList();
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: EasyAutocomplete(
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Sous Categorie 1",
          ),
          keyboardType: TextInputType.text,
          suggestions: suggestionList,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
          onChanged: (value) {
            controller.sousCategorie1Controller = value;
          },
        ));
  }

  Widget sousCategorie2Widget(ProduitModelController controller) {
    List<String> suggestionList = controller.produitModelList
        .map((e) => e.sousCategorie2)
        .toSet()
        .toList();
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: EasyAutocomplete(
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Sous Categorie 2",
          ),
          keyboardType: TextInputType.text,
          suggestions: suggestionList,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
          onChanged: (value) {
            controller.sousCategorie2Controller = value;
          },
        ));
  }

  Widget sousCategorie3Widget(ProduitModelController controller) {
    List<String> suggestionList = controller.produitModelList
        .map((e) => e.sousCategorie3)
        .toSet()
        .toList();
    return Container(
        margin: const EdgeInsets.only(bottom: p20),
        child: EasyAutocomplete(
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            labelText: "Sous Categorie 3",
          ),
          keyboardType: TextInputType.text,
          suggestions: suggestionList,
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Ce champs est obligatoire';
            } else {
              return null;
            }
          },
          onChanged: (value) {
            controller.sousCategorie3Controller = value;
          },
        ));
  }

  Widget sousCategorie4Widget(ProduitModelController controller) {
    List<String> suggestionList = Dropdown().unites;
    return Container(
      margin: const EdgeInsets.only(bottom: p20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Unité de vente',
          labelStyle: const TextStyle(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: const EdgeInsets.only(left: 5.0),
        ),
        value: controller.uniteController,
        isExpanded: true,
        validator: (value) => value == null ? "Select Unité" : null,
        items: suggestionList.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            controller.uniteController = value;
          });
        },
      ),
    );
  }
}
