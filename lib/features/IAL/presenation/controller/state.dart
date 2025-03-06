import 'package:equatable/equatable.dart';

import '../../../../core/constants/enum.dart';
import '../../data/Model/lookup_data_model.dart';

abstract class IncidentState extends Equatable{}

class IncidentInitial extends IncidentState {
  @override
  List<Object> get props => [];
}

class IncidentLoading extends IncidentState {
  @override
  List<Object> get props => [];
}

class IncidentLoaded extends IncidentState {
  final LookupDataModel lookupData;
  final Map<String, dynamic> formData;
  final Map<String, YesNo> radioSelections;
  final List<dynamic> locationFilterItems;
  @override
  List<Object> get props => [lookupData,formData,radioSelections,locationFilterItems];

  IncidentLoaded({
    required this.lookupData,
    required this.formData,
    required this.radioSelections,
    required this.locationFilterItems,
  });

  IncidentLoaded copyWith({
    LookupDataModel? lookupData,
    Map<String, dynamic>? formData,
    Map<String, YesNo>? radioSelections,
    List<dynamic>? locationFilterItems,
  }) {
    return IncidentLoaded(
      lookupData: lookupData ?? this.lookupData,
      formData: formData ?? this.formData,
      radioSelections: radioSelections ?? this.radioSelections,
      locationFilterItems: locationFilterItems ?? this.locationFilterItems,
    );
  }
}

class IncidentError extends IncidentState {
  final String message;
  IncidentError(this.message);
  @override
  List<Object> get props => [message];
}

class DocumentExported extends IncidentState {
  final String path;
  DocumentExported(this.path);
  @override
  List<Object> get props => [path];
}

