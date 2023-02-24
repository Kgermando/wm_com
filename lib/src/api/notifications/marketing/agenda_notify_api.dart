// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_commercial/src/api/header_http.dart';
import 'package:wm_commercial/src/api/route_api.dart';
import 'package:wm_commercial/src/models/notify/notify_model.dart';
import 'package:http/http.dart' as http;

class AgendaNotifyApi extends GetConnect {
  var client = http.Client();

  Future<NotifyModel> getCount(String matricule) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$agendasNotifyUrl/get-count/$matricule");
    var resp = await client.get(getUrl, headers: header);

    if (resp.statusCode == 200) {
      return NotifyModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return getCount(matricule);
    } else {
      throw Exception(resp.statusCode);
    }
  }
}
