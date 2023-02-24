import 'dart:async';

import 'package:sembast/sembast.dart'; 
import 'package:wm_commercial/src/models/commercial/facture_cart_model.dart';
import 'package:wm_commercial/src/store/database_api.dart';

class FactureStore {
  static const String storeName = "factures";

  final _store = intMapStoreFactory.store(storeName);
  Future<Database> get _db async => await DatabaseApi.instance.database;

  save(FactureCartModel entity) async {
    await _store.add(await _db, entity.toJson());
  }

  update(FactureCartModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.update(await _db, entity.toJson(), finder: finder);
  }

  delete(FactureCartModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.delete(await _db, finder: finder);
  }

  Future<Stream<List<FactureCartModel>>> stream() async {
    var streamTransformer = StreamTransformer<
        List<RecordSnapshot<int, Map<String, dynamic>>>,
        List<FactureCartModel>>.fromHandlers(
      handleData: _streamTransformerHandlerData,
    );

    return _store.query().onSnapshots(await _db).transform(streamTransformer);
  }

  Future<List<FactureCartModel>> getAllData() async {
    final snapshot = await _store.find(await _db);
    return snapshot.map((e) => FactureCartModel.fromDatabase(e)).toList();
  }

  _streamTransformerHandlerData(
      List<RecordSnapshot<int, Map<String, dynamic>>> snapshotList,
      EventSink<List<FactureCartModel>> sink) {
    List<FactureCartModel> resultSet = [];
    for (var element in snapshotList) {
      resultSet.add(FactureCartModel.fromDatabase(element));
    }
    sink.add(resultSet);
  }
}
