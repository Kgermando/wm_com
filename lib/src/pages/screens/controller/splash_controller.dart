import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wm_commercial/src/controllers/departement_notify_controller.dart';
import 'package:wm_commercial/src/controllers/network_controller.dart';
import 'package:wm_commercial/src/pages/auth/controller/login_controller.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/achats/achat_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/achats/ravitaillement_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/cart/cart_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/dashboard/dashboard_com_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/factures/facture_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/factures/facture_creance_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/factures/numero_facture_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/gains/gain_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/history/history_ravitaillement_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/history/history_vente_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/produit_model/produit_model_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/vente_effectue/ventes_effectue_controller.dart';
import 'package:wm_commercial/src/pages/mailling/controller/mailling_controller.dart';
import 'package:wm_commercial/src/pages/reservation/controller/paiement_reservation_controller.dart';
import 'package:wm_commercial/src/pages/reservation/controller/reservation_controller.dart';
import 'package:wm_commercial/src/pages/rh/controller/personnels_controller.dart';
import 'package:wm_commercial/src/pages/rh/controller/user_actif_controller.dart';
import 'package:wm_commercial/src/pages/update/controller/update_controller.dart';
import 'package:wm_commercial/src/routes/routes.dart';
import 'package:wm_commercial/src/pages/archives/controller/archive_controller.dart';
import 'package:wm_commercial/src/pages/archives/controller/archive_folder_controller.dart';
import 'package:wm_commercial/src/pages/auth/controller/change_password_controller.dart';
import 'package:wm_commercial/src/pages/auth/controller/forgot_controller.dart';
import 'package:wm_commercial/src/utils/info_system.dart';

class SplashController extends GetxController {
  final LoginController loginController = Get.put(LoginController());
  final NetworkController networkController = Get.put(NetworkController());

  final getStorge = GetStorage();

  @override
  void onReady() {
    super.onReady();
    // getStorge.erase();

    String? idToken = getStorge.read(InfoSystem.keyIdToken);
    if (kDebugMode) {
      print("splash idToken $idToken");
    }
    if (idToken != null) {
      Get.lazyPut(() => ProfilController());
      Get.lazyPut(() => UsersController());
      Get.lazyPut(() => DepartementNotifyCOntroller());

      // Mail
      Get.lazyPut(() => MaillingController());

      // Archive
      Get.lazyPut(() => ArchiveFolderController());
      Get.lazyPut(() => ArchiveController());

      // Authentification
      Get.lazyPut(() => LoginController());
      // Get.lazyPut(() => ProfilController());
      Get.lazyPut(() => ChangePasswordController());
      Get.lazyPut(() => ForgotPasswordController());

      // Commercial
      Get.lazyPut(() => DashboardComController());
      Get.lazyPut(() => AchatController());
      Get.lazyPut(() => CartController());
      Get.lazyPut(() => FactureController());
      Get.lazyPut(() => FactureCreanceController());
      Get.lazyPut(() => NumeroFactureController());
      Get.lazyPut(() => GainCartController());
      Get.lazyPut(() => HistoryRavitaillementController());
      Get.lazyPut(() => VenteCartController());
      Get.lazyPut(() => ProduitModelController());
      Get.lazyPut(() => RavitaillementController());
      Get.lazyPut(() => VenteEffectueController());

      // Reservation
      Get.lazyPut(() => ReservationController());
      Get.lazyPut(() => PaiementReservationController());

      // RH
      Get.lazyPut(() => PersonnelsController());
      Get.lazyPut(() => UsersController());

      // Update Version
      Get.lazyPut(() => UpdateController());

      isLoggIn();
    } else {
      Get.offAllNamed(UserRoutes.login);
    }
  }

  void isLoggIn() async {
    await loginController.authApi.getUserId().then((userData) async {
      // var departement = jsonDecode(userData.departement);
      if (userData.departement == "Commercial") {
        if (int.parse(userData.role) <= 2) {
          Get.offAndToNamed(ComRoutes.comDashboard);
        } else {
          Get.offAndToNamed(ComRoutes.comVente);
        }
      }
    });
  }
}
