import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/data/visits.dart';

class ShowVisitDetailsEvent extends PatientEvent
{
  Visits visit;

  ShowVisitDetailsEvent(this.visit);
}

class ShowingVisitDetailsState extends PatientState
{
  Visits visit;

  ShowingVisitDetailsState(this.visit);
}