import 'dart:async';

import 'package:sembast/sembast.dart'; 
import 'package:wm_commercial/src/models/finance/caisse_model.dart';
import 'package:wm_commercial/src/store/database_api.dart';

class CaisseStore {
  static const String storeName = "caisses";

  final _store = intMapStoreFactory.store(storeName);
  Future<Database> get _db async => await DatabaseApi.instance.database;

  save(CaisseModel entity) async {
    await _store.add(await _db, entity.toJson());
  }

  update(CaisseModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.update(await _db, entity.toJson(), finder: finder);
  }

  delete(CaisseModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.delete(await _db, finder: finder);
  }

  Future<Stream<List<CaisseModel>>> stream() async {
    // debugPrint("Geting Data Stream");
    var streamTransformer = StreamTransformer<
        List<RecordSnapshot<int, Map<String, dynamic>>>,
        List<CaisseModel>>.fromHandlers(
      handleData: _streamTransformerHandlerData,
    );

    return _store.query().onSnapshots(await _db).transform(streamTransformer);
  }

  Future<List<CaisseModel>> getAllData() async {
    final snapshot = await _store.find(await _db);
    return snapshot.map((e) => CaisseModel.fromDatabase(e)).toList();
  }

  _streamTransformerHandlerData(
      List<RecordSnapshot<int, Map<String, dynamic>>> snapshotList,
      EventSink<List<CaisseModel>> sink) {
    List<CaisseModel> resultSet = [];
    for (var element in snapshotList) {
      resultSet.add(CaisseModel.fromDatabase(element));
    }
    sink.add(resultSet);
  }
}
