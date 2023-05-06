import 'package:medimate/bloc/patient_bloc.dart';

class PopToPatientDetailsEvent extends PatientEvent
{
  PatientState state;

  PopToPatientDetailsEvent(this.state);
}