import 'package:medimate/bloc/patient_bloc.dart';

class LoadRecentPatientListEvent extends PatientEvent
{
  String date;

  LoadRecentPatientListEvent(this.date);
}

class LoadingRecentPatientListState extends PatientState {}

class LoadRecentPatientListSuccessState extends PatientState
{
  final List list;
  final String date;

  LoadRecentPatientListSuccessState (this.list, this.date);
}

class LoadRecentPatientListFailState extends PatientState
{
  final error;

  LoadRecentPatientListFailState(this.error);
}