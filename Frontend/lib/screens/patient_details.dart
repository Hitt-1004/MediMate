import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/show_patient_details_event.dart';
import 'package:medimate/bloc/events_and_states/show_visit_details_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/data/date.dart';
import 'package:medimate/models/router_delegate.dart';

class PatientDetails extends StatelessWidget
{
  const PatientDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      appBar: AppBar(title: const Text('Patient Details')),
      body: BlocBuilder<PatientBloc, PatientState>
        (
        builder: (context, state)
        {
          if (state is LoadingPatientDetailsListState)
          {
            return const Center(child: CircularProgressIndicator(),);
          }
          else if (state is LoadPatientDetailsListSuccessState)
          {
            List detailsList = state.patientDetailsList;

            return Column
              (
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                ListTile
                  (
                  title: Padding
                    (
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text
                      (
                      detailsList[0].name.toString().toUpperCase(),
                      style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Padding
                    (
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text
                      (
                      detailsList[0].contact,
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                _detailsListView(detailsList)
              ],
            );
          }
          else if (state is LoadPatientDetailsListFailState)
          {
            return Center(child: Text(state.error.toString()),);
          }
          return Container();
        }
      ),
    );
  }

  Widget _detailsListView(List detailsList)
  {
    return Expanded
      (
        child: ListView.builder
          (
            itemCount: detailsList.length,
            itemBuilder: (context, index) => _detailsCard(detailsList, index, context)
        )
    );
  }

  Widget _detailsCard(List detailsList, int index, BuildContext context)
  {
    final day = detailsList[index].DOA.toString().substring(8, 10);

    String month = Date().setMonth(int.parse(detailsList[index].DOA.toString().substring(5, 7)));

    final date = '$day $month';

    return GestureDetector
      (
      onTap: ()
      {
        BlocProvider.of<PatientBloc>(context).add(ShowVisitDetailsEvent(detailsList[index]));
        final routerDelegate = MyRouterDelegate.find();
        routerDelegate.pushPage('/visitDetails');
      },
      child: Padding
        (
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Row
          (
          children:
          [
            Container
              (
              height: 102,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              decoration: ShapeDecoration
                (
                  color: Theme.of(context).colorScheme.primary,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)))
              ),
              child: RotatedBox
                (
                quarterTurns: -1,
                child: Text
                  (
                  date,
                  style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
                ),
              ),
            ),
            Expanded
              (
              child: Card
                (
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12))),
                child: ListTile
                  (
                  title: Text
                    (
                    detailsList[index].illness,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text
                    (
                    detailsList[index].prescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
