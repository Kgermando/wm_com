import 'package:get/get.dart';
import 'package:wm_commercial/src/pages/archives/controller/archive_folder_controller.dart';

class ArchiveFolderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ArchiveFolderController>(ArchiveFolderController());
  }
}
// 