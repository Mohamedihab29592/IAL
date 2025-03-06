import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/enum.dart';
import '../../../../../core/widgets/appBar.dart';
import '../../../../../core/widgets/images_widget.dart';
import '../../../../../core/widgets/my_form_field.dart';
import '../../../data/Model/site_model.dart';
import '../../controller/bloc.dart';
import '../../controller/events.dart';
import '../../controller/state.dart';



class IncidentReportForm extends StatefulWidget {
  @override
  State<IncidentReportForm> createState() => _IncidentReportFormState();
}

var _incidentTypeController = TextEditingController();
var _typeController = TextEditingController();
var _locationController = TextEditingController();
var _addressController = TextEditingController();
var _incidentLocationController = TextEditingController();
var _reporterController = TextEditingController();
var _detailsController = TextEditingController();
var _missingController = TextEditingController();
var _dateController = TextEditingController();
var _timeController = TextEditingController();
var _policeNuController = TextEditingController();
var _siteHistoryController = TextEditingController();
var _involvedController = TextEditingController();
var _investigationController = TextEditingController();
var _correctiveController = TextEditingController();
var _finalController = TextEditingController();
var _legalController = TextEditingController();
var _nameGuardController = TextEditingController();
var _contactGuardController = TextEditingController();
var _idGuardController = TextEditingController();
var _guardAttackDController = TextEditingController();

class _IncidentReportFormState extends State<IncidentReportForm> {
  final _formKey = GlobalKey<FormState>();
  List<File> _selectedImages = [];




  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IncidentBloc, IncidentState>(
      listener: (context, state) {
        if (state is DocumentExported) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('File saved successfully in ${state.path}')),
          );
        }
        if (state is IncidentLoaded) {
          final siteDetails = state.formData['siteDetails'] as SiteDetailModel?;
          if (siteDetails != null) {
            _addressController.text = siteDetails.address ?? '';
          }
        }
      },
      builder: (context, state) {
        if (state is IncidentError) {
          return Center(child: Text(state.message));
        }

        return   PopScope(
            canPop: false,
            child: SafeArea(
              child:
              Scaffold(
                appBar: AppbarWidget(
                  title:"Incident report",

                  isClear: true,
                  isIRG: true,
                  context: context,
                  missingController: _missingController,
                  incidentLocationController:_incidentLocationController,
                  incidentTypeController:_incidentTypeController,
                  typeController: _typeController,
                  locationController: _locationController,
                  reporterController: _reporterController,
                  detailsController: _detailsController,
                  addressController: _addressController,
                  dateController: _dateController,
                  timeController: _timeController,
                  policeNuController: _policeNuController,
                  guardAttackDController: _guardAttackDController, siteHistoryController: _siteHistoryController, involvedController: _involvedController, investigationController: _investigationController, correctiveController: _correctiveController, finalController: _finalController, legalController: _legalController, nameGuardController: _nameGuardController, contactGuardController: _contactGuardController, idGuardController: _idGuardController,
                ),
                body: (state is IncidentLoaded) ? _buildForm(context, state):const Center(child: CircularProgressIndicator.adaptive()),



              ),
            )


        );
      },
    );
  }

  Widget _buildForm(BuildContext context, IncidentLoaded state) {


    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //Location type
              MyFormField(
                enableSearchSuggestions: false,
                enableSpellCheck: true,

                hint: "",
                showDownMenu: true,
                controller: _incidentTypeController,
                title: 'Incident Type',
                menuItems: state.lookupData.incidentTypes,
              ),
              const SizedBox(height: 20),

              //Date
              MyFormField(
                controller: _dateController,
                title: 'Incident Date',
                hint: "Select date",
                isReadonly: true,
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    _dateController.text =
                        "${selectedDate.toLocal()}".split(' ')[0];
                  }
                },
              ),
              const SizedBox(height: 20),
              //Time
              MyFormField(
                validator: (value) => null,
                controller: _timeController,
                title: 'Incident Time (Optional)',
                hint: "Select time",
                isReadonly: true,
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    _timeController.text = selectedTime.format(context);
                  }
                },
              ),

              const SizedBox(
                height: 20,
              ),
              //Location Name
              const SizedBox(height: 20),
// Location Name (Site ID)
              MyFormField(
                showDownMenu: true,
                controller: _locationController,
                title: 'Site ID',
                menuItems: state.locationFilterItems,
                onItemSelected: (selectedSite) {
                  // When site is selected, fetch its details
                  context.read<IncidentBloc>().add(
                    GetSiteDetailsEvent(selectedSite.id),
                  );
                },
              ),
              const SizedBox(height: 20),
              MyFormField(
                title: "Address",
                hint: "Site address will appear here",
                controller: _addressController,
              ),
              const SizedBox(
                height: 20,
              ),
              //Address
              MyFormField(
                showDownMenu: true,
                title: "Incident Location",
                hint: "",
                controller: _incidentLocationController,
                menuItems: state.lookupData.inc_location,
              ),

              const SizedBox(
                height: 20,
              ),
              MyFormField(
                title: "Reported by",
                hint: "Full Name",
                controller: _reporterController,
              ),

              const SizedBox(
                height: 20,
              ),
              //Details
              MyFormField(
                enableSpellCheck: true,
                controller: _detailsController,
                title: ' Details',
              ),
              const SizedBox(
                height: 20,
              ),
              //Action
              MyFormField(
                enableSpellCheck: true,

                controller: _missingController,
                title: ' Missing & Damages ',
              ),
              const SizedBox(
                height: 20,
              ),
              //Is Vodafone Equipment damaged?
              Padding(
                padding: const EdgeInsets.only(right: 38.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Flexible(child: Text("Door Alarm Received"),),
                    const Spacer(),

                    Row(
                      children: [
                        Radio<YesNo>(
                          value: YesNo.Yes,
                          groupValue: state.radioSelections["doorAlarm"],
                          onChanged: (YesNo? value) {
                            context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("doorAlarm", value!));

                          },
                        ),
                        const Text("Yes"),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<YesNo>(
                          value: YesNo.No,
                          groupValue: state.radioSelections["doorAlarm"],
                          onChanged: (YesNo? value) {
                            context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("doorAlarm", value!));

                          },
                        ),
                        const Text("No"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //Is Employees / Guard Injured?
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Flexible(child: Text("SOC Action      ")),
                  const Spacer(),
                  Row(
                    children: [
                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["socAction"],
                        onChanged: (YesNo? value) {

                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("socAction", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["socAction"],
                        onChanged: (YesNo? value) {

                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("socAction", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              //External vendor/ Customers/ Visitors injured?
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Flexible(
                      child: Text(
                          "Guard existence in location               ")),
                  Row(
                    children: [
                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["guardExsist"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("guardExsist", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["guardExsist"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("guardExsist", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              //Intrusion System Alarm Received
              Row(
                children: [
                  const Flexible(
                    child: Text("Guard attacked"),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["guardAttac"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("guardAttac", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),
                  Row(
                    children: [

                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["guardAttac"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("guardAttac", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),


                ],
              ),
              const SizedBox(
                height: 20,
              ),
              //Action taken by soc
              const SizedBox(
                height: 20,
              ),
              //Location Name

              MyFormField(
                enableSpellCheck: true,

                validator: (value) => null,
                title: "Guard Attack Details (Optional)",
                hint: "",
                controller: _guardAttackDController,
              ),

              const SizedBox(
                height: 20,
              ),


              //CCTv Camera
              Row(
                children: [
                  const Flexible(
                    flex: 1,
                    child: Text("CCTV Camera"),
                  ),
                  const Spacer(),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["cctv"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("cctv", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["cctv"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("cctv", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),

                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Flexible(
                    child: Text("Road Camera  "),
                  ),
                  const Spacer(),
                  Row(
                    children: [

                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["roadCctv"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("roadCctv", value!));

                        },
                      ),

                      const Text("Yes"),
                    ],
                  ),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["roadCctv"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("roadCctv", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),

                ],
              ),
              Row(
                children: [
                  const Flexible(
                    flex: 1,
                    child: Text("Concrete cube"),
                  ),
                  const Spacer(),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["concreate"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("concreate", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["concreate"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("concreate", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),

                ],
              ),
              Row(
                children: [
                  const Flexible(
                    child: Text("Guarding room"),
                  ),
                  const Spacer(),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["guardingRoom"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("guardingRoom", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),

                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["guardingRoom"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("guardingRoom", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),

                ],
              ),
              const SizedBox(height: 20,),

              MyFormField(
                enableSpellCheck: true,

                title: "Site Incident history",
                hint: "",
                controller: _siteHistoryController,
              ),
              const SizedBox(height: 20),
              MyFormField(
                title: "Involved Persons Details",
                hint: "",
                controller: _involvedController,
              ),

              //Legal Notified

              Row(
                children: [
                  const Flexible(
                    flex: 1,
                    child: Text("Legal Notified             "),
                  ),
                  const Spacer(),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["islegal"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("islegal", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),
                  Row(
                    children: [

                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["islegal"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("islegal", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),

                ],
              ),
              Row(
                children: [
                  const Flexible(
                    child: Text("Police Report issuance"),
                  ),
                  const Spacer(),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["policere"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("policere", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),

                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["policere"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("policere", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),

                ],
              ),
              const SizedBox(height: 20),
              MyFormField(
                validator: (value) => null,
                title: "Police report Number (Optional)",
                hint: "",
                controller: _policeNuController,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  const Flexible(
                    child: Text("Area Manager Visit    "),
                  ),
                  const Spacer(),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["manager"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("manager", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),

                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["manager"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("manager", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),

                ],
              ),

              Row(
                children: [
                  const Flexible(
                    child: Text("Area Supervisor Visit"),
                  ),
                  const Spacer(),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["super"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("super", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),

                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["super"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("super", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),

                ],
              ),

              Row(
                children: [
                  const Flexible(
                    child: Text("photos                         "),
                  ),
                  const Spacer(),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["photos"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("photos", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),

                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["photos"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("photos", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),

                ],
              ),
              Row(
                children: [
                  const Flexible(
                    child: Text("videos                         "),
                  ),
                  const Spacer(),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["videos"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("videos", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),

                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["videos"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("videos", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),

                ],
              ),
              Row(
                children: [
                  const Flexible(
                    child: Text("Investigation report received"),
                  ),
                  const Spacer(),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["invereport"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("invereport", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),

                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["invereport"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("invereport", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),

                ],
              ),
              const SizedBox(
                height: 20,
              ),

              MyFormField(
                enableSpellCheck: true,

                title: "Investigation Details",
                hint: "",
                controller: _investigationController,
              ),
              const SizedBox(
                height: 20,
              ),


              MyFormField(
                enableSpellCheck: true,

                title: "Corrective Action",
                hint: "",
                controller: _correctiveController,
              ),



              const SizedBox(
                height: 20,
              ),


              MyFormField(
                enableSpellCheck: true,

                title: "Final Conclusion",
                hint: "",
                controller: _finalController,
              ),
              const SizedBox(
                height: 20,
              ),


              MyFormField(
                enableSpellCheck: true,

                title: "Legal Action",
                hint: "",
                controller:_legalController ,
              ),
              Row(
                children: [
                  const Flexible(
                    child: Text("Vodafone equipment"),
                  ),
                  const Spacer(),
                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.Yes,
                        groupValue: state.radioSelections["vodafone"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("vodafone", value!));

                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),

                  Row(
                    children: [


                      Radio<YesNo>(
                        value: YesNo.No,
                        groupValue: state.radioSelections["vodafone"],
                        onChanged: (YesNo? value) {
                          context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("vodafone", value!));

                        },
                      ),
                      const Text("No"),
                    ],
                  ),

                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    const Flexible(
                      flex: 1,
                      child: Text("Other Competitors equipment"),
                    ),
                    const Spacer(),

                    Row(
                      children: [


                        Radio<YesNo>(
                          value: YesNo.Yes,
                          groupValue: state.radioSelections["othereq"],
                          onChanged: (YesNo? value) {
                            context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("othereq", value!));

                          },
                        ),
                        const Text("Yes"),
                      ],
                    ),

                    Row(
                      children: [


                        Radio<YesNo>(
                          value: YesNo.No,
                          groupValue: state.radioSelections["othereq"],
                          onChanged: (YesNo? value) {
                            context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("othereq", value!));

                          },
                        ),
                        const Text("No"),
                      ],
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    const Flexible(
                      child: Text("State authorities equipment"),
                    ),
                    const Spacer(),
                    Row(
                      children: [


                        Radio<YesNo>(
                          value: YesNo.Yes,
                          groupValue: state.radioSelections["authEqu"],
                          onChanged: (YesNo? value) {
                            context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("authEqu", value!));

                          },
                        ),
                        const Text("Yes"),
                      ],
                    ),

                    Row(
                      children: [


                        Radio<YesNo>(
                          value: YesNo.No,
                          groupValue: state.radioSelections["authEqu"],
                          onChanged: (YesNo? value) {
                            context.read<IncidentBloc>().add(UpdateRadioSelectionEvent("authEqu", value!));

                          },
                        ),
                        const Text("No"),
                      ],
                    ),

                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),


              MyFormField(
                validator: (value) => null,
                title: "The Guard details (Optional)",
                hint: "Name",
                controller: _nameGuardController,
              ),
              MyFormField(
                textType: TextInputType.number,

                validator: (value) => null,
                title: "",
                hint: "Contact",
                controller: _contactGuardController,
              ),
              MyFormField(
                textType: TextInputType.number,
                validator: (value) => null,
                title: "",
                hint: "National ID",
                controller: _idGuardController,
              ),
              const SizedBox(
                height: 20,
              ),
              ImagesWidget(selectedImages: _selectedImages,numberOfImage: 4,),

              const SizedBox(
                height: 10,
              ),
              //Export
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(const Color(0xFFD32F2F)),
                  ),
                  onPressed: () {
                    if(_formKey.currentState!.validate())
                      {
                        context.read<IncidentBloc>().add(ExportDocumentEvent(
                          formData: {
                            "date": _dateController.text,
                            "type": _incidentTypeController.text,
                            "time": _timeController.text,
                            "reported": _reporterController.text,
                            "siteId": _locationController.text,
                            "address": _addressController.text,
                            "detailes": _detailsController.text,
                            "location": _incidentLocationController.text,
                            "missing": _missingController.text,
                            "socAction": state.radioSelections["socAction"] == YesNo.Yes
                                ? "${state.radioSelections["socAction"].toString().substring(6)} we called the guard and the sheikh but no answer"
                                : state.radioSelections["socAction"].toString().substring(6),

                            "doorAlarm": state.radioSelections[
                            "doorAlarm"].toString().substring(6),
                            "guardExsist": state.radioSelections["guardExsist"].toString().substring(6),
                            "doorOpen": state.radioSelections["doorOpen"].toString().substring(6),
                            "cctv": state.radioSelections["cctv"].toString().substring(6),
                            "roadCctv": state.radioSelections["roadCctv"] == YesNo.Yes
                                ? "${state.radioSelections["roadCctv"].toString().substring(6)} As per The Guard"
                                : state.radioSelections["roadCctv"].toString().substring(6),                            "guardingRoom": state.radioSelections["guardingRoom"].toString().substring(6),
                            "guardAttac": state.radioSelections["guardAttac"].toString().substring(6),
                            "policere": state.radioSelections["policere"].toString().substring(6),
                            "islegal": state.radioSelections["islegal"].toString().substring(6),
                            "manager": state.radioSelections["manager"].toString().substring(6),
                            "super": state.radioSelections["super"].toString().substring(6),
                            "photos": state.radioSelections["photos"].toString().substring(6),
                            "videos": state.radioSelections["videos"].toString().substring(6),
                            "invereport": state.radioSelections["invereport"].toString().substring(6),
                            "vodafone": state.radioSelections["vodafone"].toString().substring(6),
                            "othereq": state.radioSelections["othereq"] == YesNo.Yes
                                ? "${state.radioSelections["othereq"].toString().substring(6)} OR/ET/WE"
                                : state.radioSelections["othereq"].toString().substring(6),                            "authEqu": state.radioSelections["authEqu"].toString().substring(6),
                            "concreate": state.radioSelections["concreate"].toString().substring(6),
                            "sitehis": _siteHistoryController.text,
                            "guardname": _nameGuardController.text,
                            "guardcon": _contactGuardController.text,
                            "guardid": _idGuardController.text,
                            "invdet": _investigationController.text,
                            "corective": _correctiveController.text,
                            "attackDetailes": _guardAttackDController.text,
                            "finalconc": _finalController.text,
                            "legalAction": _legalController.text,
                            "persons": _involvedController.text,
                            "policenu": _policeNuController.text,

                          },
                          imageFiles: _selectedImages,
                        ));

                      }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.import_export,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Export To Word',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
