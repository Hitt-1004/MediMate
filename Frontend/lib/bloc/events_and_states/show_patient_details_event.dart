import 'package:medimate/bloc/patient_bloc.dart';

class ShowPatientDetailsEvent extends PatientEvent
{
  String name;
  String contact;

  ShowPatientDetailsEvent(this.name, this.contact);
}

class LoadingPatientDetailsListState extends PatientState {}

class LoadPatientDetailsListSuccessState extends PatientState
{
  final List patientDetailsList;

  LoadPatientDetailsListSuccessState (this.patientDetailsList);
}

class LoadPatientDetailsListFailState extends PatientState
{
  final error;

  LoadPatientDetailsListFailState (this.error);
}

class ClearPatientDetailsListState extends PatientState
{
  final list = [];
}