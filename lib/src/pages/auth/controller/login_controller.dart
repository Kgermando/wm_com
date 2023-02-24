import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wm_commercial/src/api/auth/auth_api.dart';
import 'package:wm_commercial/src/api/user/user_api.dart';
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
import 'package:wm_commercial/src/pages/finance/controller/caisses/caisse_controller.dart';
import 'package:wm_commercial/src/pages/reservation/controller/paiement_reservation_controller.dart';
import 'package:wm_commercial/src/pages/reservation/controller/reservation_controller.dart';
import 'package:wm_commercial/src/pages/rh/controller/personnels_controller.dart';
import 'package:wm_commercial/src/pages/rh/controller/user_actif_controller.dart';
import 'package:wm_commercial/src/routes/routes.dart';
import 'package:wm_commercial/src/utils/info_system.dart';
import 'package:wm_commercial/src/pages/mailling/controller/mailling_controller.dart';
import 'package:wm_commercial/src/controllers/departement_notify_controller.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/pages/update/controller/update_controller.dart';
import 'package:wm_commercial/src/pages/archives/controller/archive_controller.dart';
import 'package:wm_commercial/src/pages/archives/controller/archive_folder_controller.dart';
import 'package:wm_commercial/src/pages/auth/controller/change_password_controller.dart';
import 'package:wm_commercial/src/pages/auth/controller/forgot_controller.dart';

class LoginController extends GetxController {
  final AuthApi authApi = AuthApi();
  final UserApi userApi = UserApi();

  GetStorage getStorge = GetStorage();

  final _loadingLogin = false.obs;
  bool get isLoadingLogin => _loadingLogin.value;

  final _loadingLogOut = false.obs;
  bool get loadingLogOut => _loadingLogOut.value;

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    matriculeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void clear() {
    matriculeController.clear();
    passwordController.clear();
  }

  String? validator(String value) {
    if (value.isEmpty) {
      return 'Please this field must be filled';
    }
    return null;
  }

  void login() async {
    String? idToken = getStorge.read(InfoSystem.keyIdToken);
    if (kDebugMode) {
      print("login IDUser $idToken");
    }
    final form = loginFormKey.currentState!;
    if (form.validate()) {
      try {
        _loadingLogin.value = true;
        await authApi
            .login(matriculeController.text, passwordController.text)
            .then((value) async {
          clear();
          _loadingLogin.value = false;
          if (value) {
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

            // Finance
            Get.lazyPut(() => CaisseController());

            // Update Version
            Get.lazyPut(() => UpdateController());

            GetStorage box = GetStorage();
            String? idToken = box.read(InfoSystem.keyIdToken);

            if (idToken != null) {
              await authApi.getUserId().then((userData) async {
                box.write('userModel', json.encode(userData));
                var departement = jsonDecode(userData.departement);
                if (departement.first == "Commercial") {
                  if (int.parse(userData.role) <= 2) {
                    Get.offAndToNamed(ComRoutes.comDashboard);
                  } else {
                    Get.offAndToNamed(ComRoutes.comVente);
                  }
                }
                _loadingLogin.value = false;
                Get.snackbar("Authentification réussie",
                    "Bienvenue ${userData.prenom} dans l'interface ${InfoSystem().name()}",
                    backgroundColor: Colors.green,
                    icon: const Icon(Icons.check),
                    snackPosition: SnackPosition.TOP);
              });
            }
          } else {
            _loadingLogin.value = false;
            Get.snackbar("Echec d'authentification",
                "Vérifier votre matricule et mot de passe",
                backgroundColor: Colors.red,
                icon: const Icon(Icons.close),
                snackPosition: SnackPosition.TOP);
          }
        });
      } catch (e) {
        _loadingLogin.value = false;
        Get.snackbar("Erreur lors de la connection", "$e",
            backgroundColor: Colors.red,
            icon: const Icon(Icons.close),
            snackPosition: SnackPosition.TOP);
      }
    }
  }

  Future<void> logout() async {
    try {
      _loadingLogOut.value = true;
      getStorge.remove('idToken');
      getStorge.erase();
      await authApi.logout();
      Get.offAllNamed(UserRoutes.logout);
      Get.snackbar("Déconnexion réussie!", "",
          backgroundColor: Colors.green,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
      _loadingLogOut.value = false;
    } catch (e) {
      _loadingLogOut.value = false;
      Get.snackbar("Erreur lors de la connection", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.close),
          snackPosition: SnackPosition.TOP);
    }
  }
}
