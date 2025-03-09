import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/appBar.dart';
import '../../../../../core/widgets/button.dart';
import '../../../../../core/widgets/images_widget.dart';
import '../../../../../core/widgets/my_form_field.dart';
import '../../../data/Model/lookup_model.dart';
import '../../controller/bloc.dart';
import '../../controller/events.dart';
import '../../controller/state.dart';

class AuditScreen extends StatefulWidget {
  AuditScreen({super.key});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showLockTypeField = false;
  bool _showIndoorField = false;
  bool _showOutdoorField = false;
  bool _showCCTVField = false;
  bool _lockCageField = false;
  bool _shelterLockField = false;
  List<File> _selectedImages = [];

  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _incidentLocationController = TextEditingController();
  final _teamLeadController = TextEditingController();
  final _secTypeController = TextEditingController();
  final _siteTypeController = TextEditingController();
  final _fenceStatusController = TextEditingController();
  final _fenceTypeController = TextEditingController();
  final _guardRoomController = TextEditingController();
  final _mainGateController = TextEditingController();
  final _lockMainController = TextEditingController();
  final _lockMainTypeController = TextEditingController();
  final _shroudBoxController = TextEditingController();
  final _BarbedWireController = TextEditingController();
  final _cCTVController = TextEditingController();
  final _locationCCTVController = TextEditingController();
  final _powerController = TextEditingController();
  final _genratorOwnerController = TextEditingController();
  final _genratortypeController = TextEditingController();
  final _siteTypeOptionsController = TextEditingController();
  final _numberCabinetController = TextEditingController();
  final _cabinetTypeController = TextEditingController();
  final _cabinetCageController = TextEditingController();
  final _numberPsuController = TextEditingController();
  final _indoorNumberPsuController = TextEditingController();
  final _indoorLockTypeController = TextEditingController();
  final _numberBattryController = TextEditingController();
  final _typeBattryController = TextEditingController();
  final _battryDecController = TextEditingController();
  final _lockCageDecController = TextEditingController();
  final _lockTypeDecController = TextEditingController();
  final _lockTypeMainController = TextEditingController();
  final _shelterDoorStatusController = TextEditingController();
  final _doubleShelterController = TextEditingController();
  final _doubleShelterLockDecController = TextEditingController();
  final _numberACController = TextEditingController();
  final _typeACController = TextEditingController();
  final _numberACOutController = TextEditingController();
  final _acODCController = TextEditingController();
  final _locACController = TextEditingController();

  @override
  void initState() {
    _dateController.text = "${DateTime.now()}".split(' ')[0];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timeController.text = TimeOfDay.now().format(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IncidentBloc, IncidentState>(
        listener: (context, state) {
          if (state is IncidentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message)),
            );          }
        },
        builder: (context, state) {

          return PopScope(
            canPop: false,
            child: SafeArea(
              child: Scaffold(
                appBar: AppbarWidget(
                  context: context,
                  title: "Audit report",
                  isClear: true,
                  indoorNumberPsuController:_indoorNumberPsuController,
                  indoorLockTypeController: _indoorLockTypeController,
                  lockTypeMainController: _lockTypeMainController,
                  location1Controller: _locationController,
                  incidentLocation1Controller: _incidentLocationController,
                  teamLeadController: _teamLeadController,
                  secTypeController: _secTypeController,
                  siteTypeController: _siteTypeController,
                  fenceStatusController: _fenceStatusController,
                  fenceTypeController: _fenceTypeController,
                  guardRoomController: _guardRoomController,
                  mainGateController: _mainGateController,
                  lockMainController: _lockMainController,
                  lockMainTypeController: _lockMainTypeController,
                  shroudBoxController: _shroudBoxController,
                  BarbedWireController: _BarbedWireController,
                  cCTVController: _cCTVController,
                  locationCCTVController: _locationCCTVController,
                  powerController: _powerController,
                  genratorOwnerController: _genratorOwnerController,
                  genratortypeController: _genratortypeController,
                  siteTypeOptionsController: _siteTypeOptionsController,
                  numberCabinetController: _numberCabinetController,
                  cabinetTypeController: _cabinetTypeController,
                  cabinetCageController: _cabinetCageController,
                  numberPsuController: _numberPsuController,
                  numberBattryController: _numberBattryController,
                  typeBattryController: _typeBattryController,
                  battryDecController: _battryDecController,
                  lockCageDecController: _lockCageDecController,
                  lockTypeDecController: _lockTypeDecController,
                  shelterDoorStatusController: _shelterDoorStatusController,
                  doubleShelterController: _doubleShelterController,
                  doubleShelterLockDecController:
                      _doubleShelterLockDecController,
                  numberACController: _numberACController,
                  typeACController: _typeACController,
                  numberACOutController: _numberACOutController,
                  acODCController: _acODCController,
                  locACController: _locACController,

                ),
                body: (state is IncidentLoaded)
                    ? _buildForm(context, state)
                    : const Center(child: CircularProgressIndicator.adaptive()),
              ),
            ),
          );
        });
  }

  Widget _buildForm(BuildContext context, IncidentLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MyFormField(
                validator: (value) => null,
                controller: _dateController,
                title: 'Audit Date',
                hint: "Select date",
                isReadonly: true,
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                validator: (value) => null,
                controller: _timeController,
                title: 'Audit Time',
                hint: "Select time",
                isReadonly: true,
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                showDownMenu: true,
                controller: _locationController,
                title: 'Site ID',
                menuItems: state.lookupData.location,
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                showDownMenu: true,
                title: "Incident Location",
                controller: _incidentLocationController,
                menuItems: state.lookupData.inc_location,
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                showDownMenu: true,
                title: "Team Leader",
                controller: _teamLeadController,
                menuItems: state.lookupData.areaOwner,
              ),
              const SizedBox(
                height: 20,
              ),

              MyFormField(
                isReadonly: true,
                enableSearchSuggestions: false,
                showDownMenu: true,
                title: "Security Type",
                controller: _secTypeController,
                menuItems: [
                  LookupModel(id: 1, name: "Guarded"),
                  LookupModel(id: 2, name: "Not Guarded"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                isReadonly: true,
                enableSearchSuggestions: false,
                showDownMenu: true,
                title: "Site Type",
                controller: _siteTypeController,
                menuItems: [
                  LookupModel(id: 1, name: "Green field"),
                  LookupModel(id: 2, name: "Roof top"),
                  LookupModel(id: 3, name: "COW"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                enableSpellCheck: true,

                enableSearchSuggestions: false,
                showDownMenu: true,
                title: "Fence Status",
                controller: _fenceStatusController,
                menuItems: [
                  LookupModel(id: 1, name: "Good"),
                  LookupModel(id: 2, name: "No Fence"),
                  LookupModel(id: 3, name: "Needs Repair"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                enableSpellCheck: true,

                enableSearchSuggestions: false,
                showDownMenu: true,
                title: "Fence Type",
                controller: _fenceTypeController,
                menuItems: [
                  LookupModel(id: 1, name: "Brick wall"),
                  LookupModel(id: 2, name: "steel fence"),
                  LookupModel(id: 3, name: "Net fence"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                enableSpellCheck: true,

                enableSearchSuggestions: false,
                showDownMenu: true,
                title: "Guard Room",
                controller: _guardRoomController,
                menuItems: [
                  LookupModel(id: 1, name: "Exists"),
                  LookupModel(id: 2, name: "Doesn’t Exist"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                isReadonly: true,
                enableSearchSuggestions: false,
                showDownMenu: true,
                title: "Main Gate",
                controller: _mainGateController,
                menuItems: [
                  LookupModel(id: 1, name: "Good"),
                  LookupModel(id: 2, name: "Need Repair"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                isReadonly: true,
                enableSearchSuggestions: false,
                showDownMenu: true,
                title: "Lock of Main Gate",
                controller: _lockMainController,
                menuItems: [
                  LookupModel(id: 1, name: "Exists"),
                  LookupModel(id: 2, name: "Doesn't Exists"),
                ],
                onItemSelected: (selectedItem) {
                  setState(() {
                    _showLockTypeField = selectedItem.id == 1;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              if (_showLockTypeField)
                MyFormField(
                    isReadonly: true,
                    enableSearchSuggestions: false,
                    showDownMenu: true,
                    title: "Lock of Main Gate Type",
                    controller: _lockMainTypeController,
                    menuItems: [
                      LookupModel(id: 1, name: "special lock"),
                      LookupModel(id: 2, name: "abloy"),
                      LookupModel(id: 3, name: "smart padlock"),
                    ]),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                enableSpellCheck: true,

                enableSearchSuggestions: false,
                showDownMenu: true,
                title: "Shroud Box Of Main Gate",
                controller: _shroudBoxController,
                menuItems: [
                  LookupModel(id: 1, name: "Exists"),
                  LookupModel(id: 2, name: "Doesn’t Exists"),
                  LookupModel(id: 3, name: "Need Repair"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                isReadonly: true,
                enableSearchSuggestions: false,
                showDownMenu: true,
                title: "Barbed Wire",
                controller: _BarbedWireController,
                menuItems: [
                  LookupModel(id: 1, name: "Exists"),
                  LookupModel(id: 2, name: "Doesn’t Exists"),
                  LookupModel(id: 3, name: "Need Repair"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                isReadonly: true,
                enableSearchSuggestions: false,
                showDownMenu: true,
                title: "CCTV ",
                controller: _cCTVController,
                menuItems: [
                  LookupModel(id: 1, name: "Exists"),
                  LookupModel(id: 2, name: "Doesn’t Exists"),
                ],
                onItemSelected: (selectedItem) {
                  setState(() {
                    _showCCTVField = selectedItem.id == 1;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              if (_showCCTVField)
                MyFormField(
                  title: "Location of CCTV ",
                  controller: _locationCCTVController,
                ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                isReadonly: true,
                enableSearchSuggestions: false,
                showDownMenu: true,
                title: "Power Type",
                controller: _powerController,
                menuItems: [
                  LookupModel(id: 1, name: "Commercial"),
                  LookupModel(id: 2, name: "Generator"),
                  LookupModel(id: 3, name: "Commercial & stand by generator"),
                  LookupModel(id: 3, name: "Solar cell"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                isReadonly: true,
                enableSearchSuggestions: false,
                showDownMenu: true,
                title: "Generator ownership",
                controller: _genratorOwnerController,
                menuItems: [
                  LookupModel(id: 1, name: "Rented"),
                  LookupModel(id: 2, name: "Owned"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                isReadonly: true,
                enableSearchSuggestions: false,
                showDownMenu: true,
                title: "Generator Type",
                controller: _genratortypeController,
                menuItems: [
                  LookupModel(id: 1, name: "Build in"),
                  LookupModel(id: 2, name: "External Tanks"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MyFormField(
                isReadonly: true,
                enableSearchSuggestions: false,
                title: "Site Type (Indoor - Outdoor)",
                controller: _siteTypeOptionsController,
                showDownMenu: true,
                menuItems: [
                  LookupModel(id: 1, name: "Indoor"),
                  LookupModel(id: 2, name: "Outdoor"),
                ],
                onItemSelected: (selectedItem) {
                  setState(() {
                    _showIndoorField = selectedItem.id == 1;
                    _showOutdoorField = selectedItem.id == 2;
                  });
                },
              ),
              const SizedBox(height: 20),

              // If site type is Outdoor
              if (_showOutdoorField) ...[
                MyFormField(
                  textType: TextInputType.number,

                  enableSearchSuggestions: false,
                  controller: _numberCabinetController,
                  title: "Number of Cabinets",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "1"),
                    LookupModel(id: 2, name: "2"),
                    LookupModel(id: 3, name: "3"),
                    LookupModel(id: 4, name: "4"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  isReadonly: true,
                  enableSearchSuggestions: false,
                  controller: _cabinetTypeController,
                  title: "Existing Cabinet Type",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "PSU"),
                    LookupModel(id: 2, name: "Batteries"),
                    LookupModel(id: 3, name: "Both"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  enableSpellCheck: true,

                  enableSearchSuggestions: false,
                  controller: _cabinetCageController,
                  title: "Cabinet Cage",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "Exists"),
                    LookupModel(id: 2, name: "Doesn't Exist"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  textType: TextInputType.number,

                  enableSearchSuggestions: false,
                  controller: _numberPsuController,
                  title: "Number of PSUs",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "1"),
                    LookupModel(id: 2, name: "2"),
                    LookupModel(id: 3, name: "3"),
                    LookupModel(id: 4, name: "4"),
                    LookupModel(id: 5, name: "5"),
                    LookupModel(id: 6, name: "6"),
                    LookupModel(id: 7, name: "7"),
                    LookupModel(id: 8, name: "8"),
                    LookupModel(id: 9, name: "9"),
                    LookupModel(id: 10, name: "10"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  textType: TextInputType.number,

                  controller: _numberBattryController,
                  title: "Number of Batteries",
                  hint: "Enter number",
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  isReadonly: true,
                  enableSearchSuggestions: false,
                  controller: _typeBattryController,
                  title: "Type of Batteries",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "Lithium"),
                    LookupModel(id: 2, name: "Lead Acid"),
                    LookupModel(id: 3, name: "Solar Cell"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  enableSpellCheck: true,

                  controller: _battryDecController,
                  title: "Battery Description",
                  hint: "Enter details",
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  isReadonly: true,
                  enableSearchSuggestions: false,
                  controller: _lockCageDecController,
                  title: "Lock of Cage",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "Exists"),
                    LookupModel(id: 2, name: "Doesn't Exist"),
                  ],
                  onItemSelected: (selectedItem) {
                    // Update state based on selection
                    setState(() {
                      _lockCageField = selectedItem.id == 1;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_lockCageField) ...[
                  MyFormField(
                    isReadonly: true,
                    enableSearchSuggestions: false,
                    controller: _lockTypeDecController,
                    title: "Lock Type",
                    showDownMenu: true,
                    menuItems: [
                      LookupModel(id: 1, name: "Special Lock"),
                      LookupModel(id: 2, name: "Abloy"),
                      LookupModel(id: 2, name: "Smart Padlock"),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ],

              // If site type is Indoor
              if (_showIndoorField) ...[
                MyFormField(
                  isReadonly: true,
                  enableSearchSuggestions: false,
                  controller: _shelterDoorStatusController,
                  title: "Shelter Door Status",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "Good"),
                    LookupModel(id: 2, name: "Needs Repair"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  isReadonly: true,
                  enableSearchSuggestions: false,
                  controller: _doubleShelterController,
                  title: "Double Shutter",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "Exists"),
                    LookupModel(id: 2, name: "Doesn't Exist"),
                    LookupModel(id: 3, name: "Needs Repair"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  isReadonly: true,
                  enableSearchSuggestions: false,
                  controller: _doubleShelterLockDecController,
                  title: "Double Shutter Lock",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "Exists"),
                    LookupModel(id: 2, name: "Doesn't Exist"),
                  ],
                  onItemSelected: (selectedItem) {
                    setState(() {
                      _shelterLockField = selectedItem.id == 1;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_shelterLockField) ...[
                  MyFormField(
                    isReadonly: true,
                    enableSearchSuggestions: false,
                    controller: _indoorLockTypeController,
                    title: "Lock Type",
                    showDownMenu: true,
                    menuItems: [
                      LookupModel(id: 1, name: "Special Lock"),
                      LookupModel(id: 2, name: "Abloy"),
                      LookupModel(id: 3, name: "Smart Padlock"),
                    ],
                  ),
                ],
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  textType: TextInputType.number,

                  enableSearchSuggestions: false,
                    controller: _indoorNumberPsuController,
                    title: "Number of PSUs",
                    showDownMenu: true,
                    menuItems: [
                      LookupModel(id: 1, name: "1"),
                      LookupModel(id: 2, name: "2"),
                      LookupModel(id: 3, name: "3"),
                      LookupModel(id: 4, name: "4"),
                      LookupModel(id: 5, name: "5"),
                      LookupModel(id: 6, name: "6"),
                      LookupModel(id: 7, name: "7"),
                      LookupModel(id: 8, name: "8"),
                      LookupModel(id: 9, name: "9"),
                      LookupModel(id: 10, name: "10"),
                    ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  textType: TextInputType.number,

                  controller: _numberBattryController,
                  title: "Number of Batteries",
                  hint: "Enter number",
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  isReadonly: true,
                  enableSearchSuggestions: false,
                  controller: _typeBattryController,
                  title: "Type of Batteries",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "Lithium"),
                    LookupModel(id: 2, name: "Lead Acid"),
                    LookupModel(id: 3, name: "Solar Cell"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  enableSpellCheck: true,

                  controller: _battryDecController,
                  title: "Battery Description",
                  hint: "Enter details",
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  textType: TextInputType.number,

                  enableSearchSuggestions: false,
                  controller: _numberACController,
                  title: "Number of Indoor ACs",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "1"),
                    LookupModel(id: 2, name: "2"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  enableSpellCheck: true,

                  controller: _typeACController,
                  title: "Type of AC",
                  hint: "Enter details",
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  textType: TextInputType.number,

                  enableSearchSuggestions: false,
                  controller: _numberACOutController,
                  title: "Num of Outdoor AC Units",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "1"),
                    LookupModel(id: 2, name: "2"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  isReadonly: true,
                  enableSearchSuggestions: false,
                  controller: _acODCController,
                  title: "AC ODU Cage",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "Exists"),
                    LookupModel(id: 2, name: "Doesn't Exist"),
                    LookupModel(id: 3, name: "Needs Repair"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyFormField(
                  isReadonly: true,
                  enableSearchSuggestions: false,
                  controller: _locACController,
                  title: "Lock of AC ODU Cage",
                  showDownMenu: true,
                  menuItems: [
                    LookupModel(id: 1, name: "Special Lock"),
                    LookupModel(id: 2, name: "Abloy"),
                    LookupModel(id: 3, name: "Smart Padlock"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
              Button(  onPressed: () {
                if (!_formKey.currentState!.validate() ) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Fill required data"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
                else if (_selectedImages.length<4)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Add required photos"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
                else {
                  context
                      .read<IncidentBloc>()
                      .add(ShareReportEvent(formData: {
                    // Basic Info
                    'auditDate': _dateController.text,
                    'auditTime': _timeController.text,
                    'siteId': _locationController.text,
                    'incidentLocation':
                    _incidentLocationController.text,
                    'teamLeader': _teamLeadController.text,

                    // Site Characteristics
                    'securityType': _secTypeController.text,
                    'siteType': _siteTypeController.text,
                    'siteTypeOptions': _siteTypeOptionsController.text,

                    // Perimeter Security
                    'fenceStatus': _fenceStatusController.text,
                    'fenceType': _fenceTypeController.text,
                    'guardRoom': _guardRoomController.text,
                    'mainGate': _mainGateController.text,
                    'lockMainGate': _lockMainController.text,
                    'lockMainGateType': _showLockTypeField
                        ? _lockMainTypeController.text
                        : null,
                    'shroudBox': _shroudBoxController.text,
                    'barbedWire': _BarbedWireController.text,

                    // CCTV Details
                    'cctv': _cCTVController.text,
                    'cctvLocation': _showCCTVField
                        ? _locationCCTVController.text
                        : null,

                    // Power Supply
                    'powerType': _powerController.text,
                    'generatorOwnership': _genratorOwnerController.text,
                    'generatorType': _genratortypeController.text,

                    // Conditional fields based on indoor/outdoor
                    'numberOfCabinets': _numberCabinetController.text,
                    'cabinetType': _cabinetTypeController.text,
                    'cabinetCage': _cabinetCageController.text,
                    'numberOfPSUs': _showOutdoorField
                        ? _numberPsuController.text
                        : _indoorNumberPsuController.text,
                    'numberOfBatteries': _numberBattryController.text,
                    'batteryType': _typeBattryController.text,
                    'batteryDescription': _battryDecController.text,
                    'lockOfCage': _lockCageDecController.text,
                    'lockType': _showOutdoorField && _lockCageField
                        ? _lockTypeDecController.text
                        : (_showIndoorField && _shelterLockField
                        ? _indoorLockTypeController.text
                        : null),

                    // Indoor specific
                    'shelterDoorStatus':
                    _shelterDoorStatusController.text,
                    'doubleShutter': _doubleShelterController.text,
                    'doubleShutterLock':
                    _doubleShelterLockDecController.text,
                    'numberOfIndoorACs': _numberACController.text,
                    'acType': _typeACController.text,
                    'numberOfOutdoorACs': _numberACOutController.text,
                    'acOduCage': _acODCController.text,
                    'lockOfAcOduCage': _locACController.text,

                    // For email subject
                    'locationName': _locationController.text,
                  },      images: _selectedImages, // Add the images here
                  ));

                }
              }, title:  'Send to Email', icon:  Icons.email,),
              ImagesWidget(
                selectedImages: _selectedImages,
                numberOfImage: 10,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
