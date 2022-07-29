part of 'finsheet_bloc.dart';

@immutable
abstract class FinsheetEvent {}
class FinLoadDataEvent extends FinsheetEvent {}
class FinLoadDataReportEvent extends FinsheetEvent {}
