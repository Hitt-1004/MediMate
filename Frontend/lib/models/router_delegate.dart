import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/pop_to_patient_details_event.dart';
import 'package:medimate/screens/add_patient.dart';
import 'package:medimate/screens/all_patient_list.dart';
import 'package:medimate/screens/dashboard.dart';
import 'package:medimate/screens/patient_details.dart';
import 'package:medimate/bloc/events_and_states/pop_to_all_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/pop_to_recent_patient_list_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/screens/visit_details.dart';

class MyRouterDelegate extends RouterDelegate<List<RouteSettings>> with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>>
{
  @override
  GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
  final _pages = <Page>
  [
    const MaterialPage
      (
        child: Dashboard(),
        key: ValueKey('/dashboard'),
        name: '/dashboard'
    ),
  ];
  PatientState? _previousDashboardState;
  PatientState? _previousAllPatientListState;
  PatientState? _previousPatientDetailsState;
  String? _pageThatPushedVisitDetails;

  static MyRouterDelegate? _myRouterDelegate;

  static void put(MyRouterDelegate myRouterDelegate)
  {
    _myRouterDelegate = myRouterDelegate;
  }

  static MyRouterDelegate find()
  {
    return _myRouterDelegate!;
  }

  void pushPage(String routeName)
  {
    Widget child;
    PatientBloc patientBloc = BlocProvider.of<PatientBloc>(navigatorKey!.currentContext!);

    switch (routeName)
    {
      case '/addPatient':
        {
          _previousDashboardState = patientBloc.state;
          child = AddPatient();
        }
        break;
      case '/allPatientList':
        {
          _previousDashboardState = patientBloc.state;
          child = const AllPatientList();
        }
        break;
      case '/patientDetails':
        {
          _previousAllPatientListState = patientBloc.state;
          child = const PatientDetails();
        }
        break;
      case '/visitDetails':
        {
          _pageThatPushedVisitDetails = _pages.last.name;
          if (_pageThatPushedVisitDetails == '/dashboard') _previousDashboardState = patientBloc.state;
          if (_pageThatPushedVisitDetails == '/patientDetails') _previousPatientDetailsState = patientBloc.state;
          child = VisitDetails();
        }
        break;
      default:
        {
          child = const Dashboard();
        }
    }

    _pages.add
      (
        MaterialPage
          (
          child: child,
          key: ValueKey(routeName),
          name: routeName,
        )
    );

    notifyListeners();
  }

  @override
  Future<bool> popRoute()
  {
    if (_pages.length > 1)
    {
      Page poppedPage = _pages.removeLast();
      PatientBloc patientBloc = BlocProvider.of<PatientBloc>(navigatorKey!.currentContext!);

      if (poppedPage.name == '/addPatient' || poppedPage.name == '/allPatientList' || (poppedPage.name == '/visitDetails' && _pageThatPushedVisitDetails == '/dashboard'))
      {
        patientBloc.add(PopToRecentPatientListEvent(_previousDashboardState!));
      }
      if (poppedPage.name == '/patientDetails')
      {
        patientBloc.add(PopToAllPatientListEvent(_previousAllPatientListState!));
      }
      if (poppedPage.name == '/visitDetails' && _pageThatPushedVisitDetails == '/patientDetails')
      {
        patientBloc.add(PopToPatientDetailsEvent(_previousPatientDetailsState!));
      }

      notifyListeners();
      return Future.value(true);
    }
    return Future.value(false);
  }

  bool _onPopPage(Route route, dynamic result)
  {
    if (!route.didPop(result)) return false;

    popRoute();
    return true;
  }

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) async {}

  @override
  Widget build(BuildContext context)
  {
    return Navigator
      (
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: _onPopPage,
    );
  }
 }