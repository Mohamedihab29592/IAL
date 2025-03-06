import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/widgets/appBar.dart';
import '../../../../../core/widgets/my_form_field.dart';
import '../../../data/Model/site_model.dart';
import '../../controller/bloc.dart';
import '../../controller/events.dart';
import '../../controller/state.dart';

class LocationsScreen extends StatelessWidget {
  LocationsScreen({super.key});

  final _locationController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IncidentBloc, IncidentState>(
        listener: (context, state) async {
      if (state is IncidentError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
      if (state is IncidentLoaded) {
        final siteDetails = state.formData['siteDetails'] as SiteDetailModel?;
        if (siteDetails != null) {
          _latController.text = siteDetails.latitude ?? "No Location Found";
          _longController.text = siteDetails.longitude ?? "No Location Found";
        }
      }

    }, builder: (context, state) {
      return PopScope(
        canPop: false,
        child: SafeArea(
          child: Scaffold(
            appBar: AppbarWidget(
              context: context,
              title: "Locations",
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
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
            const SizedBox(
              height: 20,
            ),
            MyFormField(
              isReadonly: true,
              title: "Latitude",
              controller: _latController,
            ),
            const SizedBox(
              height: 20,
            ),
            MyFormField(
              isReadonly: true,
              title: "Longitude",
              controller: _longController,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(const Color(0xFFD32F2F)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final String lat = _latController.text;
                    final String long = _longController.text;

                    // Create proper URI
                    final Uri googleMapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$long');

                    if (await canLaunchUrl(googleMapsUri)) {
                      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Could not open maps. URL: ${googleMapsUri.toString()}'),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill required data"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Get Location',
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
    );
  }
}
