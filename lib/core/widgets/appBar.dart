import 'package:flutter/material.dart';

AppBar AppbarWidget({
  String title ='',
  bool isIRG = false,
  bool isClear = false,
   BuildContext ?context,
    typeController,
    incidentTypeController,
    locationController,
    reporterController,
    detailsController,
    addressController,
    dateController,
    timeController,
    policeNuController,
    guardAttackDController,
    missingController,
    siteHistoryController,
    involvedController,
    incidentLocationController,
    investigationController,
    correctiveController,
    finalController,
    legalController,
    nameGuardController,
    contactGuardController,
    idGuardController,
 location1Controller ,
 incidentLocation1Controller ,
 teamLeadController ,
 secTypeController ,
 siteTypeController ,
 fenceStatusController ,
 fenceTypeController ,
 guardRoomController ,
 mainGateController ,
 lockMainController ,
 shroudBoxController ,
 BarbedWireController ,
 cCTVController ,
 locationCCTVController ,
 powerController ,
 genratorOwnerController ,
 genratortypeController ,
  siteTypeOptionsController ,
  numberCabinetController ,
  cabinetTypeController ,
  cabinetCageController ,
  numberPsuController ,
  numberBattryController ,
  typeBattryController ,
  battryDecController ,
  lockCageDecController ,
  lockTypeDecController ,
  shelterDoorStatusController ,
  doubleShelterController ,
  doubleShelterLockDecController ,
  numberACController ,
  typeACController ,
  numberACOutController ,
  acODCController ,
  locACController,
  lockTypeMainController,   lockMainTypeController, indoorNumberPsuController,   indoorLockTypeController,
}) {
  return AppBar(
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: 40,
            child: Image.asset(
              "assets/vf logo.png",
            )),
        const SizedBox(
          width: 5,
        ),
         Text(title),
      ],
    ),
    actions: [
      if(isClear)
      TextButton(
          onPressed: () async {
           if(isIRG)
             {
               typeController!.clear();
               locationController!.clear();
               reporterController!.clear();
               incidentLocationController!.clear();
               detailsController!.clear();
               incidentTypeController!.clear();
               addressController!.clear();
               missingController!.clear();
               siteHistoryController!.clear();
               involvedController!.clear();
               investigationController!.clear();
               correctiveController!.clear();
               finalController!.clear();
               legalController!.clear();
               nameGuardController!.clear();
               contactGuardController!.clear();
               idGuardController!.clear();
               dateController!.clear();
               timeController!.clear();
               policeNuController!.clear();
               guardAttackDController!.clear();
             }
           else {
             indoorNumberPsuController!.clear();  indoorLockTypeController!.clear();
             lockMainTypeController!.clear();
             lockTypeMainController!.clear();
            location1Controller !.clear() ;
            incidentLocation1Controller !.clear() ;
teamLeadController !.clear() ;
            secTypeController !.clear() ;
        siteTypeController !.clear() ;
          fenceStatusController !.clear() ;
           fenceTypeController !.clear() ;
           guardRoomController !.clear() ;
             mainGateController !.clear();
                 lockMainController !.clear();
             shroudBoxController !.clear();
             BarbedWireController !.clear();
             cCTVController !.clear();
             locationCCTVController !.clear();
             powerController !.clear();
             genratorOwnerController !.clear();
             genratortypeController !.clear();
              siteTypeOptionsController !.clear();
              numberCabinetController !.clear();
              cabinetTypeController !.clear();
              cabinetCageController !.clear();
              numberPsuController !.clear();
              numberBattryController !.clear();
              typeBattryController !.clear();
              battryDecController !.clear();
              lockCageDecController !.clear();
              lockTypeDecController !.clear();
              shelterDoorStatusController !.clear();
              doubleShelterController !.clear();
              doubleShelterLockDecController !.clear();
              numberACController !.clear();
              typeACController !.clear();
              numberACOutController !.clear();
              acODCController !.clear();
              locACController !.clear();

           }

          },
          child: const Text(
            "Clear",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ))
    ],
  );
}
