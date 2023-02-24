import 'dart:async';

import 'package:sembast/sembast.dart'; 
import 'package:wm_commercial/src/models/commercial/cart_model.dart';
import 'package:wm_commercial/src/store/database_api.dart';

class CartStore {
  static const String storeName = "carts";

  final _store = intMapStoreFactory.store(storeName);
  Future<Database> get _db async => await DatabaseApi.instance.database;

  save(CartModel entity) async {
    await _store.add(await _db, entity.toJson());
  }

  update(CartModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.update(await _db, entity.toJson(), finder: finder);
  }

  delete(CartModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.delete(await _db, finder: finder);
  }

  Future<Stream<List<CartModel>>> stream() async {
    var streamTransformer = StreamTransformer<
        List<RecordSnapshot<int, Map<String, dynamic>>>,
        List<CartModel>>.fromHandlers(
      handleData: _streamTransformerHandlerData,
    );

    return _store.query().onSnapshots(await _db).transform(streamTransformer);
  }

  Future<List<CartModel>> getAllData() async {
    final snapshot = await _store.find(await _db);
    return snapshot.map((e) => CartModel.fromDatabase(e)).toList();
  }

  _streamTransformerHandlerData(
      List<RecordSnapshot<int, Map<String, dynamic>>> snapshotList,
      EventSink<List<CartModel>> sink) {
    List<CartModel> resultSet = [];
    for (var element in snapshotList) {
      resultSet.add(CartModel.fromDatabase(element));
    }
    sink.add(resultSet);
  }
}
