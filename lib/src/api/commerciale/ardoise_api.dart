// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_commercial/src/api/header_http.dart';
import 'package:wm_commercial/src/api/route_api.dart'; 
import 'package:http/http.dart' as http;
import 'package:wm_commercial/src/models/commercial/ardoise_model.dart';

class ArdoiseApi extends GetConnect {
  var client = http.Client();

  Future<List<ArdoiseModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(ardoiseUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<ArdoiseModel> data = [];
      for (var u in bodyList) {
        data.add(ArdoiseModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ArdoiseModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/ardoises/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return ArdoiseModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ArdoiseModel> insertData(ArdoiseModel ardoiseModel) async {
    Map<String, String> header = headers;

    var data = ardoiseModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addArdoiseUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return ArdoiseModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(ardoiseModel);
    } else {
      throw Exception(resp.statusCode);
    }
  }

  Future<ArdoiseModel> updateData(ArdoiseModel ardoiseModel) async {
    Map<String, String> header = headers;

    var data = ardoiseModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/ardoises/update-ardoise/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return ArdoiseModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse("$mainUrl/ardoises/delete-ardoise/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(res.statusCode);
    }
  }
}
