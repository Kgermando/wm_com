import 'dart:async';

import 'package:sembast/sembast.dart'; 
import 'package:wm_commercial/src/models/commercial/ardoise_model.dart';
import 'package:wm_commercial/src/store/database_api.dart';

class ArdoiseStore {
  static const String storeName = "ardoises";

  final _store = intMapStoreFactory.store(storeName);
  Future<Database> get _db async => await DatabaseApi.instance.database;

  save(ArdoiseModel entity) async {
    await _store.add(await _db, entity.toJson());
  }

  update(ArdoiseModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.update(await _db, entity.toJson(), finder: finder);
  }

  delete(ArdoiseModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.delete(await _db, finder: finder);
  }

  Future<Stream<List<ArdoiseModel>>> stream() async {
    var streamTransformer = StreamTransformer<
        List<RecordSnapshot<int, Map<String, dynamic>>>,
        List<ArdoiseModel>>.fromHandlers(
      handleData: _streamTransformerHandlerData,
    );

    return _store.query().onSnapshots(await _db).transform(streamTransformer);
  }

  Future<List<ArdoiseModel>> getAllData() async {
    final snapshot = await _store.find(await _db);
    return snapshot.map((e) => ArdoiseModel.fromDatabase(e)).toList();
  }

  _streamTransformerHandlerData(
      List<RecordSnapshot<int, Map<String, dynamic>>> snapshotList,
      EventSink<List<ArdoiseModel>> sink) {
    List<ArdoiseModel> resultSet = [];
    for (var element in snapshotList) {
      resultSet.add(ArdoiseModel.fromDatabase(element));
    }
    sink.add(resultSet);
  }
}
