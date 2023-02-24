// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_commercial/src/api/header_http.dart';
import 'package:wm_commercial/src/api/route_api.dart'; 
import 'package:http/http.dart' as http;
import 'package:wm_commercial/src/models/commercial/bon_consommation_model.dart';

class BonConsommationApi extends GetConnect {
  var client = http.Client();

  Future<List<BonConsommationModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(bonsConsommationUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<BonConsommationModel> data = [];
      for (var u in bodyList) {
        data.add(BonConsommationModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<BonConsommationModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/bon-consommations/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return BonConsommationModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<BonConsommationModel> insertData(BonConsommationModel bonConsommationModel) async {
    Map<String, String> header = headers;

    var data = bonConsommationModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addBonsConsommationUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return BonConsommationModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(bonConsommationModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<BonConsommationModel> updateData(BonConsommationModel bonConsommationModel) async {
    Map<String, String> header = headers;

    var data = bonConsommationModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/bon-consommations/update-bon-consommation/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return BonConsommationModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse("$mainUrl/bon-consommations/delete-bon-consommation/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
