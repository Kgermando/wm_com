import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/constants/app_theme.dart'; 
import 'package:wm_commercial/src/models/rh/agent_model.dart'; 
import 'package:wm_commercial/src/pages/rh/components/table_users_actif.dart';
import 'package:wm_commercial/src/pages/rh/controller/user_actif_controller.dart'; 

class InfosPersonne extends StatelessWidget {
  const InfosPersonne({super.key, required this.personne});
  final AgentModel personne;

  @override
  Widget build(BuildContext context) {
    final UsersController usersController = Get.find();
    return Padding(
      padding: const EdgeInsets.all(p20),
      child: usersController.obx((state) =>
          TableUserActif(usersController: usersController, state: state!)),
    );
  }
}
