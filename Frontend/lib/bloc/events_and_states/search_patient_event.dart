import 'package:medimate/bloc/patient_bloc.dart';

class SearchPatientEvent extends PatientEvent
{
  String name;

  SearchPatientEvent(this.name);
}

class SearchingPatientState extends PatientState {}

class SearchPatientSuccessState extends PatientState
{
  final List patients;

  SearchPatientSuccessState(this.patients);
}

class SearchPatientFailState extends PatientState
{
  final error;

  SearchPatientFailState (this.error);
}