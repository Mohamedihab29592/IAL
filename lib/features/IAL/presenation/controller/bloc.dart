import 'dart:io';
import 'package:docx_template/docx_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:incident_audit_location/features/IAL/presenation/controller/state.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/enum.dart';
import '../../domain/repo.dart';
import 'events.dart';

class IncidentBloc extends Bloc<IncidentEvent, IncidentState> {
  final IncidentRepository repository;

  IncidentBloc({required this.repository}) : super(IncidentInitial()) {
    on<LoadInitialDataEvent>(_onLoadInitialData);
    on<GetSiteDetailsEvent>(_onGetSiteDetails);
    on<UpdateRadioSelectionEvent>(_onUpdateRadioSelection);
    on<ExportDocumentEvent>(_onExportDocument);
    on<ShareReportEvent>(_onShareReport);
  }
 Map<String, dynamic> incidentType = {};
  Future<void> _onLoadInitialData(
      LoadInitialDataEvent event,
      Emitter<IncidentState> emit,
      ) async {
    emit(IncidentLoading());
    try {
      final result = await repository.getAllLookupData();
      result.fold(
            (error) {emit(IncidentError(error));
              if (kDebugMode) {
                print(error.toString());
              }} ,
            (data) => emit(IncidentLoaded(
          lookupData: data,
          formData: const {},
          radioSelections: _getDefaultRadioSelections(),
          locationFilterItems: data.location,
        )),
      );
    } catch (e) {
      emit(IncidentError('Failed to load initial data: $e'));
    }
  }

  Future<void> _onGetSiteDetails(
      GetSiteDetailsEvent event, Emitter<IncidentState> emit) async {
    final currentState = state;
    if (currentState is IncidentLoaded) {

      final result = await repository.getSiteDetails(event.siteId);
      result.fold(
            (error) => emit(IncidentError(error)),
            (siteDetails) {
          // Update formData with all site details including address
          final updatedFormData = {
            ...currentState.formData,
            'siteDetails': siteDetails,
            'address': siteDetails.address,
            'latitude': siteDetails.latitude,
            'longitude': siteDetails.longitude
          };

          emit(currentState.copyWith(formData: updatedFormData));
        },
      );
    }
  }




  Map<String, YesNo> _getDefaultRadioSelections() {
    return {
      'socAction': YesNo.No,
      'doorAlarm': YesNo.No,
      'guardExsist': YesNo.No,
      'islegal': YesNo.No,
      'doorOpen': YesNo.No,
      'cctv': YesNo.No,
      'roadCctv': YesNo.No,
      'guardingRoom': YesNo.No,
      'guardAttac': YesNo.No,
      'policere': YesNo.No,
      'concreate': YesNo.No,
      'isLegal': YesNo.No,
      'manager': YesNo.No,
      'super': YesNo.No,
      'photos': YesNo.No,
      'videos': YesNo.No,
      'invereport': YesNo.No,
      'vodafone': YesNo.No,
      'othereq': YesNo.No,
      'authEqu': YesNo.No,
    };
  }



  void _onUpdateRadioSelection(
      UpdateRadioSelectionEvent event,
      Emitter<IncidentState> emit,
      ) {
    if (state is IncidentLoaded) {
      final currentState = state as IncidentLoaded;
      final newSelections = Map<String, YesNo>.from(currentState.radioSelections)
        ..[event.key] = event.value;
      emit(currentState.copyWith(radioSelections: newSelections));
    }
  }

  Future<void> _onExportDocument(
      ExportDocumentEvent event,
      Emitter<IncidentState> emit,
      ) async {
    try {
      final previousState = state;
      if (previousState is! IncidentLoaded) return;
      final data = await rootBundle.load('assets/Incident report.docx');
      final bytes = data.buffer.asUint8List();

      // Save the template to a writable directory
      final directory = await getApplicationDocumentsDirectory();
      final fileDoc = File('${directory.path}/Document.docx');
      await fileDoc.writeAsBytes(bytes);

      // Load the document for modification
      final docx = await DocxTemplate.fromBytes(await fileDoc.readAsBytes());

      // Prepare content
      final content = _prepareDocumentContent(event.formData, event.imageFiles!);

      // Generate document
      final generatedDoc = await docx.generate(content);
      if (generatedDoc == null) {
        throw Exception("Failed to generate document");
      }

      // Save to Documents folder
      final outputDir = Directory('/storage/emulated/0/Documents');
      if (!outputDir.existsSync()) {
        outputDir.createSync(recursive: true);
      }

      final outputFile = File(
          '${outputDir.path}/Incident report - (${event.formData['siteId']} - ${event.formData['location']}).docx'
      );
      await outputFile.writeAsBytes(generatedDoc);

      emit(DocumentExported(outputFile.path));
      emit(previousState);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(IncidentError('Failed to export document: $e'));
    }
  }

  Content _prepareDocumentContent(Map<String, dynamic> formData, List<File>  imageFiles) {

    Content content = Content()
      ..add(TextContent('date', formData['date']))
      ..add(TextContent('type', formData['type']))
      ..add(TextContent('time', formData['time']))
      ..add(TextContent('reported', formData['reported']))
      ..add(TextContent('location', formData['location']))
      ..add(TextContent('address', formData['address']))
      ..add(TextContent('detailes', formData['detailes']))
      ..add(TextContent('siteId', formData['siteId']))
      ..add(TextContent('missing', formData['missing']))
      ..add(TextContent('customer id', formData['customerId']))
      ..add(TextContent('socAction', '${formData['socAction']}'))
      ..add(TextContent('doorAlarm', formData['doorAlarm']))
      ..add(TextContent('guardExsist', formData['guardExsist']))
      ..add(TextContent('doorOpen', formData['doorOpen']))
      ..add(TextContent('cctv', formData['cctv']))
      ..add(TextContent('roadCctv', formData['roadCctv']))
      ..add(TextContent('guardingRoom', formData['guardingRoom']))
      ..add(TextContent('guardAttac', formData['guardAttac']))
      ..add(TextContent('policere', formData['policere']))
      ..add(TextContent('islegal', formData['islegal']))
      ..add(TextContent('manager', formData['manager']))
      ..add(TextContent('super', formData['super']))
      ..add(TextContent('photos', formData['photos']))
      ..add(TextContent('videos', formData['videos']))
      ..add(TextContent('othereq', formData['othereq']))
      ..add(TextContent('authEqu', formData['authEqu']))
      ..add(TextContent('concreate', formData['concreate']))
      ..add(TextContent('sitehis', formData['sitehis']))
      ..add(TextContent('guardname', formData['guardname']))
      ..add(TextContent('guardcon', formData['guardcon']))
      ..add(TextContent('guardid', formData['guardid']))
      ..add(TextContent('invdet', formData['invdet']))
      ..add(TextContent('corective', formData['corective']))
      ..add(TextContent('attackDetailes', formData['attackDetailes']))
      ..add(TextContent('finalconc', formData['finalconc']))
      ..add(TextContent('legalAction', formData['legalAction']))
      ..add(TextContent('persons', formData['persons']))
      ..add(TextContent('policenu', formData['policenu']))
      ..add(TextContent('invereport', formData['invereport']))
      ..add(TextContent('vodafone', formData['vodafone']));




    // Add image if available
    for (int i = 0; i < imageFiles.length; i++) {
      File imageFile = imageFiles[i];
      if (imageFile.existsSync()) {
        final imageBytes = imageFile.readAsBytesSync();
        if (imageBytes.isNotEmpty) {
          final tag = i == 0 ? 'image' : 'image$i';
          content.add(ImageContent(tag, imageBytes));
        }
      }
    }


    return content;
  }

  Future<void> _onShareReport(
      ShareReportEvent event,
      Emitter<IncidentState> emit,
      ) async {
    try {
      final emailContent = _generateAuditEmailContent(event.formData);
      await _sendViaOutlook(
        subject: 'Audit Report: ${event.formData['locationName']}',
        body: emailContent,
        recipients: [],
        attachments: event.images,
      );
    } catch (e) {
      emit(IncidentError('Failed to share audit report via Outlook: $e'));
    }
  }

  String _generateAuditEmailContent(Map<String, dynamic> formData) {
    final buffer = StringBuffer();

    // Format audit date and time
    buffer.writeln('Audit Date: ${formData['auditDate']}');
    buffer.writeln('Audit Time: ${formData['auditTime']}');
    buffer.writeln();

    // Basic site information
    buffer.writeln('Site ID: ${formData['siteId']}');
    buffer.writeln('Incident Location: ${formData['incidentLocation']}');
    buffer.writeln('Team Leader: ${formData['teamLeader']}');
    buffer.writeln();

    // Site characteristics
    buffer.writeln('SITE CHARACTERISTICS:');
    buffer.writeln('Security Type: ${formData['securityType']}');
    buffer.writeln('Site Type: ${formData['siteType']}');
    buffer.writeln('Site Indoor/Outdoor: ${formData['siteTypeOptions']}');
    buffer.writeln();

    // Fence and perimeter details
    buffer.writeln('PERIMETER SECURITY:');
    buffer.writeln('Fence Status: ${formData['fenceStatus']}');
    buffer.writeln('Fence Type: ${formData['fenceType']}');
    buffer.writeln('Guard Room: ${formData['guardRoom']}');
    buffer.writeln('Main Gate: ${formData['mainGate']}');
    buffer.writeln('Lock of Main Gate: ${formData['lockMainGate']}');

    if (formData['lockMainGateType'] != null) {
      buffer.writeln('Lock of Main Gate Type: ${formData['lockMainGateType']}');
    }

    buffer.writeln('Shroud Box Of Main Gate: ${formData['shroudBox']}');
    buffer.writeln('Barbed Wire: ${formData['barbedWire']}');
    buffer.writeln();

    // CCTV details
    buffer.writeln('CCTV DETAILS:');
    buffer.writeln('CCTV: ${formData['cctv']}');

    if (formData['cctvLocation'] != null) {
      buffer.writeln('CCTV Location: ${formData['cctvLocation']}');
    }
    buffer.writeln();

    // Power details
    buffer.writeln('POWER SUPPLY:');
    buffer.writeln('Power Type: ${formData['powerType']}');
    buffer.writeln('Generator Ownership: ${formData['generatorOwnership']}');
    buffer.writeln('Generator Type: ${formData['generatorType']}');
    buffer.writeln();

    // Site type specific information
    if (formData['siteTypeOptions'] == 'Outdoor') {
      buffer.writeln('OUTDOOR SITE DETAILS:');
      buffer.writeln('Number of Cabinets: ${formData['numberOfCabinets']}');
      buffer.writeln('Existing Cabinet Type: ${formData['cabinetType']}');
      buffer.writeln('Cabinet Cage: ${formData['cabinetCage']}');
      buffer.writeln('Number of PSUs: ${formData['numberOfPSUs']}');
      buffer.writeln('Number of Batteries: ${formData['numberOfBatteries']}');
      buffer.writeln('Type of Batteries: ${formData['batteryType']}');
      buffer.writeln('Battery Description: ${formData['batteryDescription']}');
      buffer.writeln('Lock of Cage: ${formData['lockOfCage']}');

      if (formData['lockType'] != null) {
        buffer.writeln('Lock Type: ${formData['lockType']}');
      }
      buffer.writeln();
    } else if (formData['siteTypeOptions'] == 'Indoor') {
      buffer.writeln('INDOOR SITE DETAILS:');
      buffer.writeln('Shelter Door Status: ${formData['shelterDoorStatus']}');
      buffer.writeln('Double Shutter: ${formData['doubleShutter']}');
      buffer.writeln('Double Shutter Lock: ${formData['doubleShutterLock']}');

      if (formData['lockType'] != null) {
        buffer.writeln('Lock Type: ${formData['lockType']}');
      }

      buffer.writeln('Number of PSUs: ${formData['numberOfPSUs']}');
      buffer.writeln('Number of Batteries: ${formData['numberOfBatteries']}');
      buffer.writeln('Type of Batteries: ${formData['batteryType']}');
      buffer.writeln('Battery Description: ${formData['batteryDescription']}');
      buffer.writeln('Number of Indoor ACs: ${formData['numberOfIndoorACs']}');
      buffer.writeln('Type of AC: ${formData['acType']}');
      buffer.writeln('Number of Outdoor AC Units: ${formData['numberOfOutdoorACs']}');
      buffer.writeln('AC ODU Cage: ${formData['acOduCage']}');
      buffer.writeln('Lock of AC ODU Cage: ${formData['lockOfAcOduCage']}');
      buffer.writeln();
    }

    return buffer.toString();
  }

  Future<void> _sendViaOutlook({
    required String subject,
    required String body,
    required List<String> recipients,
    List<File>? attachments,
  }) async {
    try {
      final Email email = Email(
        body: body,
        subject: subject,
        recipients: recipients,
        attachmentPaths: attachments?.map((file) => file.path).toList() ?? [],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
    } catch (e) {
      throw Exception('Failed to send email: $e');
    }
  }

// Helper function for encoding query parameters
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}