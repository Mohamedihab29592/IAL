import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../../core/constants/enum.dart';

abstract class IncidentEvent extends Equatable {}

class LoadInitialDataEvent extends IncidentEvent {
  @override
  List<Object> get props => [];
}


class GetSiteDetailsEvent extends IncidentEvent {
  final int siteId;

   GetSiteDetailsEvent(this.siteId);

  @override
  List<Object> get props => [siteId];
}










class UpdateRadioSelectionEvent extends IncidentEvent {
  final String key;
  final YesNo value;

  UpdateRadioSelectionEvent(this.key, this.value);
  @override
  List<Object> get props => [key,value];
}


class ExportDocumentEvent extends IncidentEvent {
  final Map<String, dynamic> formData;
  final  List<File> ? imageFiles;
  ExportDocumentEvent({required this.formData, this.imageFiles});
  @override
  List<Object> get props => [formData,imageFiles!];
}

class ShareReportEvent extends IncidentEvent {
  final Map<String, dynamic> formData;
  final List<File> images;

  ShareReportEvent({required this.formData,required this.images});
  @override
  List<Object> get props => [formData,images];
}

class SendReportEvent extends IncidentEvent {
  final Map<String, dynamic> formData;
  final List<File> images;

  SendReportEvent({required this.formData,required this.images});
  @override
  List<Object> get props => [formData,images];
}


