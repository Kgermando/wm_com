import 'dart:async';

import 'package:sembast/sembast.dart'; 
import 'package:wm_commercial/src/models/commercial/creance_cart_model.dart';
import 'package:wm_commercial/src/store/database_api.dart';

class FactureCreanceStore {
  static const String storeName = "facture_creances";

  final _store = intMapStoreFactory.store(storeName);
  Future<Database> get _db async => await DatabaseApi.instance.database;

  save(CreanceCartModel entity) async {
    await _store.add(await _db, entity.toJson());
  }

  update(CreanceCartModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.update(await _db, entity.toJson(), finder: finder);
  }

  delete(CreanceCartModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.delete(await _db, finder: finder);
  }

  Future<Stream<List<CreanceCartModel>>> stream() async {
    var streamTransformer = StreamTransformer<
        List<RecordSnapshot<int, Map<String, dynamic>>>,
        List<CreanceCartModel>>.fromHandlers(
      handleData: _streamTransformerHandlerData,
    );

    return _store.query().onSnapshots(await _db).transform(streamTransformer);
  }

  Future<List<CreanceCartModel>> getAllData() async {
    final snapshot = await _store.find(await _db);
    return snapshot.map((e) => CreanceCartModel.fromDatabase(e)).toList();
  }

  _streamTransformerHandlerData(
      List<RecordSnapshot<int, Map<String, dynamic>>> snapshotList,
      EventSink<List<CreanceCartModel>> sink) {
    List<CreanceCartModel> resultSet = [];
    for (var element in snapshotList) {
      resultSet.add(CreanceCartModel.fromDatabase(element));
    }
    sink.add(resultSet);
  }
}
