import 'package:country_dial_code/country_dial_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medimate/bloc/events_and_states/add_new_patient_event.dart';
import 'package:medimate/bloc/events_and_states/enter_patient_details_event.dart';
import 'package:medimate/bloc/events_and_states/load_recent_patient_list_event.dart';
import 'package:medimate/bloc/patient_bloc.dart';
import 'package:medimate/models/router_delegate.dart';

class AddPatient extends StatelessWidget
{
  final _formKey = GlobalKey<FormState>();
  final _parameters = ['name', 'contact', 'age', 'illness', 'prescription', 'period', 'DOA', 'fee'];
  final _visitDetails = {};

  AddPatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      appBar: AppBar
        (
        title: const Text('Add patient'),
      ),
      body: BlocBuilder<PatientBloc, PatientState>
        (
          builder: (context, state)
          {
            if (state is EnteringPatientDetailsState)
            {
              return _form(context);
            }
            else if (state is AddingNewPatientState)
            {
              return const Center(child: CircularProgressIndicator(),);
            }
            else if (state is AddNewPatientSuccessState)
            {
              return AlertDialog
                (
                title: const Text('Visit added successfully!'),
                actions:
                [
                  TextButton
                    (
                    onPressed: ()
                    {
                      MyRouterDelegate.find().popRoute();
                      BlocProvider.of<PatientBloc>(context).add(LoadRecentPatientListEvent(DateTime.now().toString()));
                    },
                    child: const Text('Great!')
                  )
                ],
              );
            }
            else if (state is AddNewPatientFailState)
            {
              return Center(child: Text('Adding new visit failed with the following error:\n${state.error}'),);
            }
            return Container();
          }
      ),
    );
  }

  Widget _form(BuildContext context)
  {
    return Form
      (
      key: _formKey,
      child: SizedBox
        (
        height: 550,
        child: Column
          (
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            Expanded
              (
              child: ListView.builder
                (
                itemCount: _parameters.length,
                itemBuilder: (context, index)
                {
                  return _formFields(index, context);
                }
              ),
            ),
            ElevatedButton
              (
              onPressed: ()
              {
               if (_formKey.currentState!.validate())
               {
                 _formKey.currentState?.save();
                 BlocProvider.of<PatientBloc>(context).add(AddNewPatientEvent(_visitDetails));
                 // MyRouterDelegate.find().popRoute();
               }
              },
              child: const Text('Enter')
            ),
            // const SizedBox (height: 100)
          ],
        ),
      )
    );
  }

  Widget _formFields(int index, BuildContext context)
  {
    String parameter = _parameters[index];
    String label = parameter.replaceRange(0, 1, parameter.substring(0,1).toUpperCase());
    final keyboardTypes =
    [
      TextInputType.name,
      TextInputType.phone,
      TextInputType.number,
      TextInputType.text,
      TextInputType.text,
      TextInputType.text,
      TextInputType.datetime,
      TextInputType.number
    ];
    const icons =
    [
      Icon(Icons.person),
      Icon(Icons.phone),
      Icon(Icons.cake),
      Icon(Icons.sick),
      Icon(Icons.medication),
      Icon(Icons.access_time),
      Icon(Icons.today),
      Icon(Icons.currency_rupee)
    ];

    // final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
    // print(systemLocales);
    // String? isCountryCode = systemLocales.first.countryCode;

    return Padding
      (
      padding: const EdgeInsets.fromLTRB(15.0, 8, 15, 8),
      child: TextFormField
        (
        initialValue: label == 'DOA' ? DateTime.now().toString().substring(0, 10): null,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration
          (
          labelText: label,
          prefixIcon: icons[index],
          prefixIconColor: Theme.of(context).colorScheme.primary,
          prefix: parameter == 'contact' ? _dropdownMenuButton(): null,
          filled: true,
          fillColor: Theme.of(context).cardTheme.color,
          constraints: const BoxConstraints(maxHeight: 45),
          focusedBorder: OutlineInputBorder
            (
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 3),
            borderRadius: BorderRadius.circular(14)
          ),
          enabledBorder: OutlineInputBorder
            (
            borderSide: BorderSide(color: Theme.of(context).cardTheme.color!),
            borderRadius: BorderRadius.circular(14)
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Please enter some text': null,
        onSaved: (value) => _visitDetails.putIfAbsent(parameter, () => value),
        textInputAction: index == _parameters.length - 1 ? TextInputAction.done : TextInputAction.next,
        keyboardType: keyboardTypes[index],
      ),
    );
  }

  Widget _dropdownMenuButton()
  {
    final countryLocales = WidgetsBinding.instance.window.locales;
    countryLocales.add(const Locale('in', 'IN'));
    final dropDownItems = List.generate(countryLocales.length, (index) => DropdownMenuItem(value: CountryDialCode.fromCountryCode(countryLocales[index].countryCode!).dialCode, child: Text(CountryDialCode.fromCountryCode(countryLocales[index].countryCode!).dialCode)));
    String? initialValue = CountryDialCode.fromCountryCode(countryLocales.first.countryCode!).dialCode;

    return DropdownButton
      (
      elevation: 0,
      value: initialValue,
      items: dropDownItems,
      onChanged: (value)
      {
        initialValue = value;
      },
      icon: const Icon(Icons.arrow_drop_down),
    );
  }
}