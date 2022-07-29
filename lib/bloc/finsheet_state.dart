// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'finsheet_bloc.dart';

@immutable
abstract class FinsheetState {}

class FinsheetInitialState extends FinsheetState {}

class FinsheetLoadingState extends FinsheetState {}

class FinsheetLoadedState extends FinsheetState {
  List<FinModel> data;
  FinsheetLoadedState({
    required this.data,
  });
}

class FinsheetErrorState extends FinsheetState {}
class FinsheetLoadingReportState extends FinsheetState {}

class FinsheetLoadedReportState extends FinsheetState {
  List<FinModel> data;
  FinsheetLoadedReportState({
    required this.data,
  });
}

class FinsheetErrorReportState extends FinsheetState {}
