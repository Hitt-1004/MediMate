import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/load_recent_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/load_all_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/pop_to_all_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/pop_to_patient_details_event.dart';
import 'package:medimate/bloc/events_and_states/search_patient_event.dart';
import 'package:medimate/bloc/events_and_states/add_new_patient_event.dart';
import 'package:medimate/bloc/events_and_states/enter_patient_details_event.dart';
import 'package:medimate/bloc/events_and_states/show_patient_details_event.dart';
import 'package:medimate/bloc/events_and_states/pop_to_recent_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/show_visit_details_event.dart';
import 'package:medimate/bloc/events_and_states/updating_visit_details_event.dart';
import 'package:medimate/data/patient_repository.dart';
import 'package:medimate/data/visits.dart';

abstract class PatientEvent {}

abstract class PatientState {}

class PatientBloc extends Bloc<PatientEvent, PatientState>
{
  final _patientRepository = PatientRepository();

  PatientBloc(): super(LoadingRecentPatientListState())
  {
    on
      (
      (event, emit) async
      {
        if (event is LoadRecentPatientListEvent)
        {
          emit(LoadingRecentPatientListState());

          try
          {
            List<Visits> recentPatientList = await _patientRepository.getRecentPatientList(event.date.substring(0, 10));

            emit (LoadRecentPatientListSuccessState(recentPatientList, event.date));
          }
          catch (e)
          {
            emit(LoadRecentPatientListFailState(e));
          }
        }
        else if (event is LoadAllPatientListEvent)
        {
          emit(LoadingAllPatientListState());

          try
          {
            List<Visits> allPatientList = await _patientRepository.getAllPatientList();
            emit (LoadAllPatientListSuccessState(allPatientList));
          }
          catch (e)
          {
            emit(LoadAllPatientListFailState(e));
          }
        }
        else if (event is SearchPatientEvent)
        {
          emit (SearchingPatientState());

          try
          {
            List<Visits> patientsList = await _patientRepository.searchPatient(event.name);
            emit(SearchPatientSuccessState(patientsList));
          }
          catch (e)
          {
            emit(SearchPatientFailState(e));
          }
        }
        else if (event is EnterPatientDetailsEvent)
        {
          emit(EnteringPatientDetailsState());
        }
        else if (event is AddNewPatientEvent)
        {
          emit(AddingNewPatientState());

          try
          {
            await _patientRepository.addPatient(event.visitDetails);
            emit(AddNewPatientSuccessState());
          }
          catch (e)
          {
            emit(AddNewPatientFailState(e));
          }
        }
        else if (event is ShowPatientDetailsEvent)
        {
          emit(LoadingPatientDetailsListState());

          try
          {
            List patientDetails = await _patientRepository.getPatientHistory(event.name, event.contact);
            emit(LoadPatientDetailsListSuccessState(patientDetails));
          }
          catch (e)
          {
            emit(LoadPatientDetailsListFailState(e));
          }
        }
        else if (event is PopToRecentPatientListEvent)
        {
          emit(event.state);
        }
        else if (event is PopToAllPatientListEvent)
        {
          emit(event.state);
        }
        else if (event is ShowVisitDetailsEvent)
        {
          emit (ShowingVisitDetailsState(event.visit));
        }
        else if (event is PopToPatientDetailsEvent)
        {
          emit (event.state);
        }
        else if (event is UpdateVisitDetailsEvent)
          {
            emit(UpdatingVisitState());

            try
            {
              await _patientRepository.updatePatient(event.visit);
              emit(UpdateVisitSuccessState(event.visit['name'], event.visit['contact']));
            }
            catch (e)
            {
              emit(UpdateVisitFailState(e));
            }
          }
      }
    );
  }
}