import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/api/archives/archive_api.dart';
import 'package:wm_commercial/src/api/upload_file_api.dart';
import 'package:wm_commercial/src/models/archive/archive_model.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/utils/dropdown.dart';

class ArchiveController extends GetxController
    with StateMixin<List<ArchiveModel>> {
  final ArchiveApi archiveApi = ArchiveApi();
  final ProfilController profilController = Get.find();

  List<ArchiveModel> archiveList = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final List<String> departementList = Dropdown().departement;

  TextEditingController nomDocumentController = TextEditingController();
  String? departement;
  String? level;
  TextEditingController descriptionController = TextEditingController();

  final _isUploading = false.obs;
  bool get isUploading => _isUploading.value;
  final _isUploadingDone = false.obs;
  bool get isUploadingDone => _isUploadingDone.value;

  String? uploadedFileUrl;

  void uploadFile(String file) async {
    _isUploading.value = true;
    await FileApi().uploadFiled(file).then((value) {
      _isUploading.value = false;
      _isUploadingDone.value = true;
      uploadedFileUrl = value;
    });
  }

  @override
  void onInit() {
    super.onInit();
    getList();
  }

  @override
  void refresh() {
    getList();
    super.refresh();
  }

  @override
  void dispose() {
    nomDocumentController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void clear() {
    departement = null;
    uploadedFileUrl = null;
    nomDocumentController.clear();
    descriptionController.clear();
  }

  void getList() async {
    await archiveApi.getAllData().then((response) {
      archiveList.clear();
      archiveList.addAll(response);
      change(archiveList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await archiveApi.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await archiveApi.deleteData(id).then((value) {
        archiveList.clear();
        getList();
        Get.back();
        Get.snackbar("Supprimé avec succès!", "Cet élément a bien été supprimé",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
        _isLoading.value = false;
      });
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  void submit(ArchiveFolderModel data) async {
    try {
      _isLoading.value = true;
      final archiveModel = ArchiveModel(
          departement: data.departement,
          folderName: data.folderName,
          nomDocument: nomDocumentController.text,
          description: descriptionController.text,
          fichier: (uploadedFileUrl == '') ? '-' : uploadedFileUrl.toString(),
          signature: profilController.user.matricule,
          created: DateTime.now(),
          reference: data.id!,
          level: level.toString());
      await archiveApi.insertData(archiveModel).then((value) {
        clear();
        archiveList.clear();
        getList();
        Get.back();
        Get.snackbar("Archivage effectuée avec succès!",
            "Le document a bien été sauvegadé",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
        _isLoading.value = false;
      });
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  void updateData(ArchiveModel data) async {
    try {
      _isLoading.value = true;
      final archiveModel = ArchiveModel(
          id: data.id,
          departement: data.departement,
          folderName: data.folderName,
          nomDocument: (nomDocumentController.text == "")
              ? nomDocumentController.text
              : data.nomDocument,
          description: (descriptionController.text == "")
              ? descriptionController.text
              : data.description,
          fichier: (uploadedFileUrl == '') ? '-' : uploadedFileUrl.toString(),
          signature: profilController.user.matricule,
          created: DateTime.now(),
          reference: data.reference,
          level: level.toString());
      await archiveApi.updateData(archiveModel).then((value) {
        clear();
        archiveList.clear();
        getList();
        Get.back();
        Get.snackbar("Modification de l'Archive effectuée avec succès!",
            "Le document a bien été sauvegadé",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
        _isLoading.value = false;
      });
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar("Erreur de soumission", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }
}
