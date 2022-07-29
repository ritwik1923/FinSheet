// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:finsheet/data/provider/database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

import 'package:finsheet/data/model/fin_model.dart';

part 'finsheet_event.dart';
part 'finsheet_state.dart';

class FinsheetBloc extends Bloc<FinsheetEvent, FinsheetState> {
  FinData repository;
  FinsheetBloc(
    this.repository,
  ) : super(FinsheetInitialState()) {
    on<FinLoadDataEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is FinLoadDataEvent) {
        emit(FinsheetLoadingState());
        try {
          List<FinModel> data = await repository.getTodayFin();
          emit(FinsheetLoadedState(data: data));
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
          List<FinModel> data = await repository.getLastFin();
          emit(FinsheetLoadedReportState(data: data));
        } catch (_) {
          emit(FinsheetErrorReportState());
        }
      }
    });
  }
}
