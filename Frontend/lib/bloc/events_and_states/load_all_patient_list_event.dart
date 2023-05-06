import 'package:medimate/bloc/patient_bloc.dart';

class LoadAllPatientListEvent extends PatientEvent {}

class LoadingAllPatientListState extends PatientState {}

class LoadAllPatientListSuccessState extends PatientState
{
  final List list;

  LoadAllPatientListSuccessState (this.list);
}

class LoadAllPatientListFailState extends PatientState
{
  final error;

  LoadAllPatientListFailState(this.error);
}