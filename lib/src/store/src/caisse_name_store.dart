import 'dart:async';

import 'package:sembast/sembast.dart';
import 'package:wm_commercial/src/models/finance/caisse_name_model.dart';
import 'package:wm_commercial/src/store/database_api.dart';

class CaisseNameStore {
  static const String storeName = "caisse_names";

  final _store = intMapStoreFactory.store(storeName);
  Future<Database> get _db async => await DatabaseApi.instance.database;

  save(CaisseNameModel entity) async {
    await _store.add(await _db, entity.toJson());
  }

  update(CaisseNameModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.update(await _db, entity.toJson(), finder: finder);
  }

  delete(CaisseNameModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.delete(await _db, finder: finder);
  }

  Future<Stream<List<CaisseNameModel>>> stream() async {
    // debugPrint("Geting Data Stream");
    var streamTransformer = StreamTransformer<
        List<RecordSnapshot<int, Map<String, dynamic>>>,
        List<CaisseNameModel>>.fromHandlers(
      handleData: _streamTransformerHandlerData,
    );

    return _store.query().onSnapshots(await _db).transform(streamTransformer);
  }

  Future<List<CaisseNameModel>> getAllData() async {
    final snapshot = await _store.find(await _db);
    return snapshot.map((e) => CaisseNameModel.fromDatabase(e)).toList();
  }

  _streamTransformerHandlerData(
      List<RecordSnapshot<int, Map<String, dynamic>>> snapshotList,
      EventSink<List<CaisseNameModel>> sink) {
    List<CaisseNameModel> resultSet = [];
    for (var element in snapshotList) {
      resultSet.add(CaisseNameModel.fromDatabase(element));
    }
    sink.add(resultSet);
  }
}
