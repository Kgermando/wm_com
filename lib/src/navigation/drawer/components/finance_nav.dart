import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/models/users/user_model.dart';
import 'package:wm_commercial/src/controllers/departement_notify_controller.dart';
import 'package:wm_commercial/src/navigation/drawer/drawer_widget.dart';
import 'package:wm_commercial/src/pages/finance/controller/caisses/caisse_name_controller.dart'; 

class FinanceNav extends StatefulWidget {
  const FinanceNav(
      {super.key,
      required this.currentRoute,
      required this.user,
      required this.departementList,
      required this.controller});
  final String currentRoute;
  final UserModel user;
  final String departementList;
  final DepartementNotifyCOntroller controller;

  @override
  State<FinanceNav> createState() => _FinanceNavState();
}

class _FinanceNavState extends State<FinanceNav> {
  final CaisseNameController caisseNameController =
      Get.put(CaisseNameController());
  bool isOpenCaisse = false;

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final bodySmall = Theme.of(context).textTheme.bodySmall; 
    return ExpansionTile(
      leading: const Icon(Icons.savings, size: 20.0),
      title: Text('Caisses', style: bodyMedium),
      initiallyExpanded: false,
      onExpansionChanged: (val) {
        setState(() {
          isOpenCaisse = !val;
        });
      },
      children: caisseNameController.caisseNameList.map((element) {
        return DrawerWidget(
            selected:
                widget.currentRoute == '/transactions-caisse/${element.id}',
            icon: Icons.arrow_right,
            sizeIcon: 15.0,
            title: element.nomComplet.toUpperCase(),
            style: bodySmall!,
            onTap: () {
              Get.toNamed('/transactions-caisse/${element.id!}',
                  arguments: element);
            });
      }).toList(),
    );
  }
}
