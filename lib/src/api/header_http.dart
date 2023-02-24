import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:wm_commercial/src/utils/info_system.dart';


final box = GetStorage(); 

String? accessToken = box.read(InfoSystem.keyAccessToken);

String token = (accessToken == null) ? '' :  jsonDecode(accessToken!);

Map<String, String> headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  "Authorization": "Bearer $token"
};

Map<String, String> headerForm = {
  'Content-Type': 'multipart/form-data',
  'Authorization': 'Bearer $token'
};
