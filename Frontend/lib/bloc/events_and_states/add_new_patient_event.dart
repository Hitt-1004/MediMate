import 'package:medimate/bloc/patient_bloc.dart';

class AddNewPatientEvent extends PatientEvent
{
  Map visitDetails;

  AddNewPatientEvent(this.visitDetails);
}

class AddingNewPatientState extends PatientState {}

class AddNewPatientSuccessState extends PatientState {}

class AddNewPatientFailState extends PatientState
{
  final error;

  AddNewPatientFailState (this.error);
}