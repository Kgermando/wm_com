import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wm_commercial/src/api/mails/mail_api.dart';
import 'package:wm_commercial/src/api/upload_file_api.dart';
import 'package:wm_commercial/src/models/mail/mail_model.dart';
import 'package:wm_commercial/src/models/users/user_model.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/pages/rh/controller/user_actif_controller.dart';
import 'package:wm_commercial/src/routes/routes.dart';

class MaillingController extends GetxController
    with StateMixin<List<MailModel>> {
  final MailApi mailApi = MailApi();
  final ProfilController profilController = Get.find();
  final UsersController usersController = Get.find();

  var mailList = <MailModel>[].obs;
  var mailSendList = <MailModel>[].obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  String? emailController;
  TextEditingController objetController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController pieceJointeController = TextEditingController();
  bool read = false;
  List<UserModel> ccList = [];

  final _isUploading = false.obs;
  bool get isUploading => _isUploading.value;
  final _isUploadingDone = false.obs;
  bool get isUploadingDone => _isUploadingDone.value;

  String? uploadedFileUrl;

  void uploadFile(String file) async {
    _isUploading.value = true;
    await FileApi().uploadFiled(file).then((value) {
      uploadedFileUrl = value;
      _isUploading.value = false;
      _isUploadingDone.value = true;
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
    objetController.dispose();
    messageController.dispose();
    pieceJointeController.dispose();

    super.dispose();
  }

  void clear() {
    uploadedFileUrl == null;
    emailController == null;
    objetController.clear();
    messageController.clear();
    pieceJointeController.clear();
  }

// var ccList = jsonDecode(mail.cc);

  void getList() async {
    await mailApi.getAllData().then((response) {
      mailList.assignAll(response
          .where((element) =>
              element.email == profilController.user.email ||
              element.email == "support@eventdrc.com")
          .toList());
      mailSendList.assignAll(response
          .where((element) => element.emailDest == profilController.user.email)
          .toList());
      change(mailList, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  detailView(int id) async {
    final data = await mailApi.getOneData(id);
    return data;
  }

  void deleteData(int id) async {
    try {
      _isLoading.value = true;
      await mailApi.deleteData(id).then((value) {
        clear();
        mailList.clear();
        getList();
        // Get.back();
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

  void send() async {
    try {
      _isLoading.value = true;
      var userSelect = usersController.usersList
          .where((element) => element.email == emailController.toString())
          .first;
      var ccJson = jsonEncode(ccList);
      final mailModel = MailModel(
          fullName: "${userSelect.prenom} ${userSelect.nom}",
          email: emailController.toString(),
          cc: ccJson,
          objet: objetController.text,
          message: messageController.text,
          pieceJointe:
              (uploadedFileUrl == '') ? '-' : uploadedFileUrl.toString(),
          read: 'false',
          fullNameDest:
              "${profilController.user.prenom} ${profilController.user.nom}",
          emailDest: profilController.user.email,
          dateSend: DateTime.now(),
          dateRead: DateTime.now());
      await mailApi.insertData(mailModel).then((value) {
        clear();
        mailList.clear();
        getList();
        Get.back();
        Get.snackbar("Envoyer avec succès!", "Votre mail a bien été envoyé.",
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check),
            snackPosition: SnackPosition.TOP);
        _isLoading.value = false;
      });
    } catch (e) {
      Get.snackbar("Echec d'envoie", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }

  void readMail(MailModel mail, Color color) async {
    try {
      _isLoading.value = true;
      final dataItem = MailModel(
          id: mail.id!,
          fullName: mail.fullName,
          email: mail.email,
          cc: mail.cc,
          objet: mail.objet,
          message: mail.message,
          pieceJointe: mail.pieceJointe,
          read: 'true',
          fullNameDest: mail.fullNameDest,
          emailDest: mail.emailDest,
          dateSend: mail.dateSend,
          dateRead: DateTime.now());
      await mailApi.updateData(dataItem).then((value) {
        Get.toNamed(MailRoutes.mailDetail,
            arguments: MailColor(mail: mail, color: color));
        _isLoading.value = false;
      });
    } catch (e) {
      Get.snackbar("Erreur d'ouverture", "$e",
          backgroundColor: Colors.red,
          icon: const Icon(Icons.check),
          snackPosition: SnackPosition.TOP);
    }
  }
}
