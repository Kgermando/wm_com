import 'package:get/get.dart';
import 'package:wm_commercial/src/pages/finance/controller/caisses/caisse_controller.dart';
import 'package:wm_commercial/src/pages/finance/controller/caisses/caisse_name_controller.dart'; 

class CaisseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CaisseNameController>(CaisseNameController());
    Get.put<CaisseController>(CaisseController());
  }
}
