import 'package:get/get.dart';
import 'package:wm_commercial/src/pages/archives/controller/archive_controller.dart';

class ArchiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ArchiveController>(ArchiveController());
  }
}
