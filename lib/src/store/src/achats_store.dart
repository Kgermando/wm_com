import 'dart:async';

import 'package:sembast/sembast.dart'; 
import 'package:wm_commercial/src/models/commercial/achat_model.dart';
import 'package:wm_commercial/src/store/database_api.dart';

class AchatStore {
  static const String storeName = "achats";

  final _store = intMapStoreFactory.store(storeName);
  Future<Database> get _db async => await DatabaseApi.instance.database;

  save(AchatModel entity) async {
    await _store.add(await _db, entity.toJson());
  }

  update(AchatModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.update(await _db, entity.toJson(), finder: finder);
  }

  delete(AchatModel entity) async {
    final finder = Finder(filter: Filter.byKey(entity.id));
    await _store.delete(await _db, finder: finder);
  }

  Future<Stream<List<AchatModel>>> stream() async {
    var streamTransformer = StreamTransformer<
        List<RecordSnapshot<int, Map<String, dynamic>>>,
        List<AchatModel>>.fromHandlers(
      handleData: _streamTransformerHandlerData,
    );

    return _store.query().onSnapshots(await _db).transform(streamTransformer);
  }

  Future<List<AchatModel>> getAllData() async {
    final snapshot = await _store.find(await _db);
    return snapshot.map((e) => AchatModel.fromDatabase(e)).toList();
  }

  _streamTransformerHandlerData(
      List<RecordSnapshot<int, Map<String, dynamic>>> snapshotList,
      EventSink<List<AchatModel>> sink) {
    List<AchatModel> resultSet = [];
    for (var element in snapshotList) {
      resultSet.add(AchatModel.fromDatabase(element));
    }
    sink.add(resultSet);
  }
}
