// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';

import '../data/model/entities.dart';
import '../objectbox.g.dart';
import 'package:path/path.dart';

part 'finsheet_event.dart';
part 'finsheet_state.dart';

class FinsheetBloc extends Bloc<FinsheetEvent, FinsheetState> {
  // FinData repository;

  FinsheetBloc() : super(FinsheetInitialState()) {
    on<FinLoadDataDBEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is FinLoadDataDBEvent) {
        emit(FinsheetLoadingDBState());
        try {
          SyncClient syncClient;
          var dir = await getApplicationDocumentsDirectory();
          Store _store = Store(
            getObjectBoxModel(),
            directory: join(dir.path, 'objectbox'),
          );
          print("init db");

          if (Sync.isAvailable()) {
            syncClient = Sync.client(
              _store,
              Platform.isAndroid ? 'ws://10.0.2.2:9999' : 'ws://127.0.0.1:9999',
              SyncCredentials.none(),
            );
            syncClient.start();
            emit(FinsheetLoadedDBState(_store, syncClient));
          }

          // var _streamfin = _store
          //     .box<FinModel>()
          //     .query()
          //     .watch(triggerImmediately: true)
          //     .map((query) => query.find());
          // var _streamtag = _store
          //     .box<TagModel>()
          //     .query()
          //     .watch(triggerImmediately: true)
          //     .map((query) => query.find());
          // hasBeenInitialized = true;

        } catch (_) {
          print(_);
          emit(FinsheetErrorDBState());
        }
      }
    });
    on<FinLoadDataEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is FinLoadDataEvent) {
        emit(FinsheetLoadingState());
        try {
          // List<FinModel> data = await repository.getTodayFin();
          // emit(FinsheetLoadedState(data: data));
        } catch (_) {
          emit(FinsheetErrorState());
        }
      }
    });
    on<FinLoadDataReportEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is FinLoadDataReportEvent) {
        emit(FinsheetLoadingReportState());
        try {
          // List<FinModel> data = await repository.getLastFin();
          // emit(FinsheetLoadedReportState(data: data));
        } catch (_) {
          emit(FinsheetErrorReportState());
        }
      }
    });
  }
}
