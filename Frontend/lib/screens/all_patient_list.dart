import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/load_all_patient_list_event.dart';
import 'package:medimate/bloc/events_and_states/search_patient_event.dart';
import 'package:medimate/bloc/events_and_states/show_patient_details_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/models/router_delegate.dart';

class AllPatientList extends StatelessWidget
{
  const AllPatientList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      appBar: AppBar
        (
        title: const Text('All Patients'),
      ),
      body: Column
        (
        children:
        [
          _searchBar(context),
          BlocBuilder<PatientBloc, PatientState>
            (
            builder: (context, state)
            {
              if (state is LoadingAllPatientListState || state is SearchingPatientState)
              {
                return const Center(child: CircularProgressIndicator(),);
              }
              else if (state is LoadAllPatientListSuccessState)
              {
                return _patientGrid(state.list);
              }
              else if (state is SearchPatientSuccessState)
              {
                return _patientGrid(state.patients);
              }
              else if (state is LoadAllPatientListFailState)
              {
                return Center(child: Text(state.error.toString()),);
              }
              else if (state is SearchPatientFailState)
              {
                return Center(child: Text(state.error.toString()),);
              }
              return Container();
            },
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  Widget _searchBar(BuildContext context)
  {
    return Padding
      (
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: TextField
        (
        textCapitalization: TextCapitalization.words,
        onSubmitted: (name) => BlocProvider.of<PatientBloc>(context).add(SearchPatientEvent(name)),
        // onChanged: (name) => BlocProvider.of<PatientBloc>(context).add(SearchPatientEvent(name)),
        decoration: InputDecoration
          (
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Theme.of(context).colorScheme.primary,
          label: const Text('Search'),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          hintText: 'Type the name of the patient',
          filled: true,
          fillColor: Theme.of(context).cardTheme.color,
          constraints: const BoxConstraints(maxHeight: 45),
          focusedBorder: OutlineInputBorder
            (
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3),
            borderRadius: BorderRadius.circular(25)
          ),
          enabledBorder: OutlineInputBorder
            (
            borderSide: BorderSide(color: Theme.of(context).cardTheme.color!),
            borderRadius: BorderRadius.circular(25)
          ),
        ),
      ),
    );
  }

  Widget _patientGrid(List patientList)
  {
    return Expanded
      (
      child: GridView.builder
        (
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount
          (
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
        ),
        itemCount: patientList.length,
        itemBuilder: (context, index)
        {
          return _patientCard(patientList, index, context);
        },
      ),
    );
  }

  Widget _patientCard(List patientList, int index, BuildContext context)
  {
    String name = patientList[index].name;
    String contact = patientList[index].contact;

    return GestureDetector
      (
      onTap: ()
      {
        BlocProvider.of<PatientBloc>(context).add(ShowPatientDetailsEvent(name, contact));
        final routerDelegate = MyRouterDelegate.find();
        routerDelegate.pushPage('/patientDetails');
      },
      child: Card
        (
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile
          (
          isThreeLine: true,
          title: Text
            (
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            maxLines: 1,
          ),
          subtitle: Text
            (
            contact,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
        ),
      ),
    );
  }

  Widget _bottomNavigationBar(BuildContext context)
  {
    return BottomNavigationBar
      (
      showSelectedLabels: false,
      currentIndex: 1,
      items:
      [
        const BottomNavigationBarItem (icon: Icon(Icons.home), label: 'Dashboard'),
        BottomNavigationBarItem
          (
            icon: Row
              (
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                const Icon(Icons.list_rounded),
                const SizedBox(width: 5,),
                Text('All patients', style: TextStyle(color: Theme.of(context).colorScheme.primary),),
              ],
            ),
            label: 'All patients'
        )
      ],
      onTap: (index)
      {
        if (index == 0)
        {
          final routerDelegate = MyRouterDelegate.find();
          routerDelegate.popRoute();
        }
      },
    );
  }
}