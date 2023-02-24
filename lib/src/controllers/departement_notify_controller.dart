import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wm_commercial/src/api/notifications/commercial/cart_notify_api.dart';
import 'package:wm_commercial/src/api/notifications/mails/mails_notify_api.dart';
import 'package:wm_commercial/src/api/notifications/marketing/agenda_notify_api.dart';
import 'package:wm_commercial/src/models/notify/notify_model.dart';
import 'package:wm_commercial/src/pages/auth/controller/profil_controller.dart';
import 'package:wm_commercial/src/utils/info_system.dart';

class DepartementNotifyCOntroller extends GetxController {
  Timer? timerCommercial;

  final ProfilController profilController = Get.put(ProfilController());

  // Header
  CartNotifyApi cartNotifyApi = CartNotifyApi();
  MailsNotifyApi mailsNotifyApi = MailsNotifyApi();
  AgendaNotifyApi agendaNotifyApi = AgendaNotifyApi();

 
  // Header
  final _cartItemCount = 0.obs;
  int get cartItemCount => _cartItemCount.value; 

  final _mailsItemCount = 0.obs;
  int get mailsItemCount => _mailsItemCount.value;

  final _agendaItemCount = 0.obs;
  int get agendaItemCount => _agendaItemCount.value;
 

  @override
  void onInit() {
    super.onInit();
    getDataNotify();
  }

  void getDataNotify() async {
    final getStorge = GetStorage();
    String? idToken = getStorge.read(InfoSystem.keyIdToken);
    if (idToken != null) { 
       timerCommercial = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (kDebugMode) {
          print("notify Commercial");
        }
        getCountMail();
        getCountAgenda();
        getCountCart();
      });
    }
  }

  @override
  void dispose() { 
    timerCommercial!.cancel(); 
    super.dispose();
  }

  // Header
  void getCountCart() async {
    NotifyModel notifySum =
        await cartNotifyApi.getCount(profilController.user.matricule);
    _cartItemCount.value = notifySum.count;
    update();
  }

  void getCountMail() async {
    NotifyModel notifySum =
        await mailsNotifyApi.getCount(profilController.user.matricule);
    _mailsItemCount.value = notifySum.count;
    update();
  }

  void getCountAgenda() async {
    NotifyModel notifySum =
        await agendaNotifyApi.getCount(profilController.user.matricule);
    _agendaItemCount.value = notifySum.count;
    update();
  }

  
}
