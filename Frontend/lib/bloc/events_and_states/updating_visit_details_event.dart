import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/data/visits.dart';

class UpdateVisitDetailsEvent extends PatientEvent
{
  Map visit;

  UpdateVisitDetailsEvent(this.visit);
}

class UpdatingVisitState extends PatientState {}

class UpdateVisitSuccessState extends PatientState
{
  String name;
  String contact;

  UpdateVisitSuccessState(this.name, this.contact);
}

class UpdateVisitFailState extends PatientState
{
  final error;

  UpdateVisitFailState (this.error);
}
