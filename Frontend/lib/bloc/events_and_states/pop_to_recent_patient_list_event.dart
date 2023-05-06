import 'package:medimate/bloc/patient_bloc.dart';

class PopToRecentPatientListEvent extends PatientEvent
{
  PatientState state;

  PopToRecentPatientListEvent(this.state);
}