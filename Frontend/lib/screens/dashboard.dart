import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/bloc/events_and_states/enter_patient_details_event.dart';
import 'package:medimate/bloc/events_and_states/load_all_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/load_recent_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/show_visit_details_event.dart';
import 'package:medimate/bloc/theme_cubit.dart';
import 'package:medimate/data/date.dart';
import 'package:medimate/models/router_delegate.dart';

class Dashboard extends StatelessWidget
{
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
        appBar: _appBar(context),
        body: BlocBuilder<PatientBloc, PatientState>
          (
          builder: (context, state)
          {
            return Column
              (
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
              [
                Row
                  (
                  children:
                  [
                    if (state is LoadRecentPatientListSuccessState) _datePicker(context, state.date),
                    Expanded(child: _topCard(context)),
                  ],
                ),
                const SizedBox(height: 10,),
                if (state is LoadingRecentPatientListState) const Center(child: CircularProgressIndicator(),)
                else if(state is LoadRecentPatientListSuccessState && state.list.isNotEmpty) _appointmentsList(state.list)
                else if (state is LoadRecentPatientListSuccessState) const Center(child: Text("No visits yet!"),)
                else if (state is LoadRecentPatientListFailState) Center(child: Text('${state.error}'),)
                // else if (state is AddNewPatientSuccessState) BlocProvider.of<PatientBloc>(context).add(LoadRecentPatientListEvent(DateTime.now().toString()))
              ]
            );
          },
        ),
        floatingActionButton: _floatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _bottomNavigationBar(context)
    );
  }

  PreferredSizeWidget _appBar(BuildContext context)
  {
    return AppBar
      (
      title: const Text('MediMate'),
      actions:
      [
        BlocBuilder<ThemeCubit, ThemeMode>
          (
          builder: (context, themeMode) => IconButton
            (
            onPressed: ()
            {
              BlocProvider.of<ThemeCubit>(context).toggleTheme();
            },
            icon: themeMode == ThemeMode.system
                ? const Icon(Icons.brightness_auto)
                : (themeMode == ThemeMode.light
                ? const Icon(Icons.light_mode) : const Icon(Icons.nights_stay)),
          ),
        )
      ],
    );
  }

  Widget _datePicker(BuildContext context, String date)
  {
    String month = Date().setMonth(int.parse(date.substring(5, 7)));
    DateTime? selectedDate = DateTime.tryParse(date);

    return Padding
      (
      padding: const EdgeInsets.fromLTRB(10, 10, 7, 10),
      child: TextButton
        (
        onPressed: () async
        {
          selectedDate = await showDatePicker
            (
            context: context,
            initialDate: DateTime.parse(date),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );

          if (selectedDate != null && selectedDate.toString() != date && context.mounted)
          {
            BlocProvider.of<PatientBloc>(context).add(LoadRecentPatientListEvent(selectedDate.toString()));
          }
        },
        style: ButtonStyle
          (
          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
          fixedSize: MaterialStateProperty.all(const Size(85, 85)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
        ),
        child: Column
          (
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            Text
              (
              date.substring(8, 10),
              style: TextStyle
                (
                color: Theme.of(context).scaffoldBackgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 30
              )
            ),
            Text
              (
              month.toLowerCase(),
              style: TextStyle
                (
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _topCard(BuildContext context)
  {
    final state = BlocProvider.of<PatientBloc>(context).state;

    return Padding
      (
      padding: const EdgeInsets.fromLTRB(7, 10, 10, 10),
      child: Card
        (
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile
          (
          title: const Text
            (
            'Patients \nVisited',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: state is LoadRecentPatientListSuccessState ? (state.list.isNotEmpty ? Text(state.list.length.toString()): const Text('0')): null,
        )
      ),
    );
  }

  Widget _appointmentsList(List patientList)
  {
    return Expanded
      (
      child: Column
        (
        children:
        [
          const Text
            (
            'Recent visits',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded
            (
            child: ListView.builder
              (
              itemCount: patientList.length,
              itemBuilder: (context, index)
              {
                return _appointmentsCard(patientList, index, context);
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentsCard(List patientList, int index, BuildContext context)
  {
    return Padding
      (
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
      child: GestureDetector
        (
        onTap: ()
        {
          BlocProvider.of<PatientBloc>(context).add(ShowVisitDetailsEvent(patientList[index]));
          MyRouterDelegate.find().pushPage('/visitDetails');
        },
        child:Card
          (
          child: ListTile
            (
            title: Text
              (
              patientList[index].name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text
              (
              patientList[index].illness,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
          ),
        ),
      )
    );
  }

  Widget _floatingActionButton(BuildContext context)
  {
    return FloatingActionButton
      (
      onPressed: ()
      {
        MyRouterDelegate.find().pushPage('/addPatient');
        BlocProvider.of<PatientBloc>(context).add(EnterPatientDetailsEvent());
      },
      child: const Icon(Icons.add),);
  }

  Widget _bottomNavigationBar(BuildContext context)
  {
    return BottomNavigationBar
      (
      showSelectedLabels: false,
      items:
        [
          BottomNavigationBarItem
            (
              icon: Row
                (
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                [
                  const Icon(Icons.home_filled),
                  const SizedBox(width: 5,),
                  Text('Home', style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                ],
              ),
              label: 'Dashboard'
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.list_rounded), label: 'All patients')
        ],
      onTap: (index)
      {
        if (index == 1)
        {
          BlocProvider.of<PatientBloc>(context).add(LoadAllPatientListEvent());
          MyRouterDelegate.find().pushPage('/allPatientList');
        }
      },
    );
  }
}