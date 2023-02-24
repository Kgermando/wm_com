import 'package:get/get.dart';
import 'package:wm_commercial/src/pages/reservation/controller/paiement_reservation_controller.dart';
import 'package:wm_commercial/src/pages/reservation/controller/reservation_controller.dart'; 

class ReservationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ReservationController>(ReservationController());
    Get.put<PaiementReservationController>(PaiementReservationController());
  }
}
