import 'package:medimate/bloc/patient_bloc.dart';

class PopToAllPatientListEvent extends PatientEvent
{
  PatientState state;

  PopToAllPatientListEvent(this.state);
}