// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'finsheet_bloc.dart';

@immutable
abstract class FinsheetState {}

class FinsheetInitialState extends FinsheetState {}

class FinsheetLoadingDBState extends FinsheetState {}

class FinsheetLoadedDBState extends FinsheetState {
  // late Stream<List<FinModel>> streamfin;
  // late Stream<List<TagModel>> streamtag;
  Store store;
  SyncClient syncClient;
/*
  // void initState() {
  //   // super.initState();
  //   print("init db");
  //   getApplicationDocumentsDirectory().then((dir) {
  //     store = Store(
  //       getObjectBoxModel(),
  //       directory: join(dir.path, 'objectbox'),
  //     );

  //     if (Sync.isAvailable()) {
  //       syncClient = Sync.client(
  //         store,
  //         Platform.isAndroid ? 'ws://10.0.2.2:9999' : 'ws://127.0.0.1:9999',
  //         SyncCredentials.none(),
  //       );
  //       syncClient.start();
  //     }

  //     // streamfin = store
  //     //     .box<FinModel>()
  //     //     .query()
  //     //     .watch(triggerImmediately: true)
  //     //     .map((query) => query.find());
  //     //   streamtag = store
  //     //       .box<TagModel>()
  //     //       .query()
  //     //       .watch(triggerImmediately: true)
  //     //       .map((query) => query.find());
  //     //   // hasBeenInitialized = true;
  //   });
  // }
*/
// TODO destructore
  @override
  void dispose() {
    store.close();
    syncClient.close();
    // super.dispose();
  }

  FinsheetLoadedDBState(
    this.store,
    this.syncClient,
  );
  Future<void> addFin(FinModel data) async {
    store.box<FinModel>().put(data);
  }

  Future<void> delFin(FinModel data) async {
    store.box<FinModel>().remove(data.id);
  }

  Future<void> delFinAll() async {
    store.box<FinModel>().removeAll();
    store.box<TagModel>().removeAll();
  }

  Future<void> updateFin(FinModel data) async {
    store.box<FinModel>().put(data);
  }

  Stream<List<TagModel>> getallTags() => store
      .box<TagModel>()
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());
  // Future<TagModel> getTagsObj(String tag) => store
  //     .box<TagModel>()
  //     .query(TagModel_.tag.equals(tag))
  //     // .watch(triggerImmediately: true)
  //     // .map((query) => query.find());

  Stream<List<FinModel>> getminExpense() {
    DateTime startDate = DateTime.now().subtract(Duration(minutes: 5));
    DateTime endDate = DateTime.now();
    print('5 min s:${startDate},e: ${endDate}');

    return store
        .box<FinModel>()
        .query(FinModel_.createdTime.between(startDate.millisecondsSinceEpoch,
            endDate.millisecondsSinceEpoch - 1))
        // ..order(FinModel_.createdTime, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Stream<List<FinModel>> getTodayExpense(int number) {
    DateTime startDate = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    DateTime endDate = startDate.add(Duration(days: 1));
    print('1 day s:${startDate},e: ${endDate}');

    return store
        .box<FinModel>()
        .query(FinModel_.createdTime.between(
            DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch,
            DateTime.now().millisecondsSinceEpoch - 1))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Stream<List<FinModel>> getDateExpense(DateTime startdate, DateTime enddate) {
    // DateTime ss =
    return store
        .box<FinModel>()
        .query(FinModel_.createdTime.between(
            startdate.subtract(Duration(days: 1)).millisecondsSinceEpoch,
            enddate.millisecondsSinceEpoch))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Stream<List<FinModel>> getWeeklyExpense() => store
      .box<FinModel>()
      .query(FinModel_.createdTime.between(
          DateTime.now().subtract(Duration(days: 7)).millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch - 1))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
  Stream<List<FinModel>> getMonthlyExpense() => store
      .box<FinModel>()
      .query(FinModel_.createdTime.between(
          DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch - 1))
      .watch(triggerImmediately: true)
      .map((query) => query.find());
  Stream<List<FinModel>> getAllExpense() => store
      .box<FinModel>()
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());
}

class FinsheetErrorDBState extends FinsheetState {}

class FinsheetLoadingState extends FinsheetState {}

class FinsheetLoadedState extends FinsheetState {
  // List<FinModel> data;
  Stream<List<FinModel>> streamfin;
  FinsheetLoadedState({
    required this.streamfin,
  });
}

class FinsheetErrorState extends FinsheetState {}

class FinsheetLoadingReportState extends FinsheetState {}

class FinsheetLoadedReportState extends FinsheetState {
  Stream<List<TagModel>> streamtag;
  FinsheetLoadedReportState({
    required this.streamtag,
  });
}

class FinsheetErrorReportState extends FinsheetState {}
