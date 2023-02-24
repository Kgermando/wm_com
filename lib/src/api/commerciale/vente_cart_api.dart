// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:get/get.dart';
import 'package:wm_commercial/src/api/header_http.dart';
import 'package:wm_commercial/src/api/route_api.dart';
import 'package:wm_commercial/src/models/commercial/vente_cart_model.dart';
import 'package:http/http.dart' as http;

class VenteCartApi extends GetConnect {
  var client = http.Client();

  Future<List<VenteCartModel>> getAllData() async {
    Map<String, String> header = headers;

    var resp = await client.get(ventesUrl, headers: header);

    if (resp.statusCode == 200) {
      List<dynamic> bodyList = json.decode(resp.body);
      List<VenteCartModel> data = [];
      for (var u in bodyList) {
        data.add(VenteCartModel.fromJson(u));
      }
      return data;
    } else {
      throw Exception(jsonDecode(resp.body)['message']);
    }
  }

  Future<VenteCartModel> getOneData(int id) async {
    Map<String, String> header = headers;

    var getUrl = Uri.parse("$mainUrl/ventes/$id");
    var resp = await client.get(getUrl, headers: header);
    if (resp.statusCode == 200) {
      return VenteCartModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<VenteCartModel> insertData(VenteCartModel venteCartModel) async {
    Map<String, String> header = headers;

    var data = venteCartModel.toJson();
    var body = jsonEncode(data);

    var resp = await client.post(addVentesUrl, headers: header, body: body);
    if (resp.statusCode == 200) {
      return VenteCartModel.fromJson(json.decode(resp.body));
    } else if (resp.statusCode == 401) {
      // await AuthApi().refreshAccessToken();
      return insertData(venteCartModel);
    } else {
      throw Exception(json.decode(resp.body)['message']);
    }
  }

  Future<VenteCartModel> updateData(VenteCartModel venteCartModel) async {
    Map<String, String> header = headers;

    var data = venteCartModel.toJson();
    var body = jsonEncode(data);
    var updateUrl = Uri.parse("$mainUrl/ventes/update-vente/");

    var res = await client.put(updateUrl, headers: header, body: body);
    if (res.statusCode == 200) {
      return VenteCartModel.fromJson(json.decode(res.body));
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }

  Future<void> deleteData(int id) async {
    Map<String, String> header = headers;

    var deleteUrl = Uri.parse("$mainUrl/ventes/delete-vente/$id");

    var res = await client.delete(deleteUrl, headers: header);
    if (res.statusCode == 200) {
    } else {
      throw Exception(json.decode(res.body)['message']);
    }
  }
}
