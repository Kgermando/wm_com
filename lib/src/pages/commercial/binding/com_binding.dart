import 'package:get/get.dart';
import 'package:wm_commercial/src/pages/commercial/components/factures/pdf_a6/creance_cart_a6_pdf.dart';
import 'package:wm_commercial/src/pages/commercial/components/factures/pdf_a6/facture_cart_a6_pdf.dart';
import 'package:wm_commercial/src/pages/commercial/controller/achats/achat_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/achats/ravitaillement_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/ardoise/ardoise_controller.dart';
import 'package:wm_commercial/src/pages/commercial/controller/bon_consommation/bon_consommation_controller.dart';
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

class ComBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardComController>(DashboardComController());
    Get.put<AchatController>(AchatController());
    Get.put<CartController>(CartController());
    Get.put<FactureController>(FactureController());
    Get.put<FactureCreanceController>(FactureCreanceController());
    Get.put<GainCartController>(GainCartController());
    Get.put<HistoryRavitaillementController>(HistoryRavitaillementController());
    Get.put<NumeroFactureController>(NumeroFactureController());
    Get.put<ProduitModelController>(ProduitModelController());
    Get.put<RavitaillementController>(RavitaillementController());
    Get.put<VenteCartController>(VenteCartController());
    Get.put<VenteEffectueController>(VenteEffectueController());

    Get.put<ArdoiseController>(ArdoiseController());
    Get.put<BonConsommationController>(BonConsommationController());

    // PDF
    Get.put<FactureCartPDFA6>(FactureCartPDFA6()); 
    Get.put<CreanceCartPDFA6>(CreanceCartPDFA6());

    // Finance
    Get.put<CaisseController>(CaisseController());
  }
}
