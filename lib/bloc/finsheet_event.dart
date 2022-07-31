part of 'finsheet_bloc.dart';

@immutable
abstract class FinsheetEvent {}
class FinLoadDataDBEvent extends FinsheetEvent {}
class FinLoadDataEvent extends FinsheetEvent {}
class FinLoadDataReportEvent extends FinsheetEvent {}
