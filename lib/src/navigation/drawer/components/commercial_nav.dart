import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/controllers/departement_notify_controller.dart';
import 'package:wm_commercial/src/models/users/user_model.dart';
import 'package:wm_commercial/src/navigation/drawer/drawer_widget.dart';
import 'package:wm_commercial/src/pages/commercial/controller/dashboard/dashboard_com_controller.dart';
import 'package:wm_commercial/src/routes/routes.dart';

class CommercialNav extends StatefulWidget {
  const CommercialNav(
      {super.key,
      required this.currentRoute,
      required this.user,
      required this.departementList,
      required this.controller});
  final String currentRoute;
  final UserModel user;
  final List<dynamic> departementList;
  final DepartementNotifyCOntroller controller;

  @override
  State<CommercialNav> createState() => _CommercialNavState();
}

class _CommercialNavState extends State<CommercialNav> {
  final DashboardComController dashboardComController = Get.find();
  bool isOpen = false;
  bool isOpen1 = false;
  bool isOpen2 = false;

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodyText1 = Theme.of(context).textTheme.bodySmall;
    int userRole = int.parse(widget.user.role);
    return ExpansionTile(
      leading: const Icon(Icons.store, size: 30.0),
      title: AutoSizeText('Commercial', maxLines: 1, style: bodyMedium),
      initiallyExpanded:
          widget.departementList.contains('Commercial') ? true : false,
      onExpansionChanged: (val) {
        setState(() {
          isOpen = !val;
        });
      },
      trailing: const Icon(Icons.arrow_drop_down),
      children: [
        if (userRole <= 3)
          DrawerWidget(
              selected: widget.currentRoute == ComRoutes.comDashboard,
              icon: Icons.dashboard,
              sizeIcon: 15.0,
              title: 'Dashboard',
              style: bodyText1!,
              onTap: () {
                // dashboardComController.getData();
                Get.toNamed(ComRoutes.comDashboard);
              }),
        DrawerWidget(
            selected: widget.currentRoute == ComRoutes.comVente,
            icon: Icons.shopping_basket_sharp,
            sizeIcon: 15.0,
            title: 'Ventes',
            style: bodyText1!,
            onTap: () {
              Get.toNamed(ComRoutes.comVente);
            }),
        DrawerWidget(
            selected: widget.currentRoute == ComRoutes.comAchat,
            icon: Icons.shopping_basket_sharp,
            sizeIcon: 15.0,
            title: 'Stock',
            style: bodyText1,
            onTap: () {
              Get.toNamed(ComRoutes.comAchat);
            }),
        DrawerWidget(
            selected: widget.currentRoute == ComRoutes.comArdoise,
            icon: Icons.table_bar,
            sizeIcon: 15.0,
            title: 'Tables',
            style: bodyText1,
            onTap: () {
              Get.toNamed(ComRoutes.comArdoise);
            }),
        DrawerWidget(
            selected: widget.currentRoute == ComRoutes.comFacture,
            icon: Icons.receipt_long,
            sizeIcon: 15.0,
            title: 'Factures',
            style: bodyText1,
            onTap: () {
              Get.toNamed(ComRoutes.comFacture);
            }),
        DrawerWidget(
            selected: widget.currentRoute == ComRoutes.comCart,
            icon: Icons.shopping_cart,
            sizeIcon: 15.0,
            title: 'Panier',
            style: bodyText1,
            onTap: () {
              Get.toNamed(ComRoutes.comCart);
            }),
        
        if (userRole <= 3)
          DrawerWidget(
              selected: widget.currentRoute == ComRoutes.comProduitModel,
              icon: Icons.verified,
              sizeIcon: 15.0,
              title: 'Identifiant Produit',
              style: bodyText1,
              onTap: () {
                Get.toNamed(ComRoutes.comProduitModel);
              }),
        DrawerWidget(
            selected: widget.currentRoute == ComRoutes.comVenteEffectue,
            icon: Icons.checklist_rtl,
            sizeIcon: 15.0,
            title: 'Historique de Ventes',
            style: bodyText1,
            onTap: () {
              Get.toNamed(ComRoutes.comVenteEffectue);
            }),
        if (userRole <= 3)
          DrawerWidget(
              selected:
                  widget.currentRoute == ComRoutes.comHistoryRavitaillement,
              icon: Icons.history,
              sizeIcon: 15.0,
              title: 'Historique de ravitaillements',
              style: bodyText1,
              onTap: () {
                Get.toNamed(ComRoutes.comHistoryRavitaillement);
              }),
      ],
    );
  }
}
