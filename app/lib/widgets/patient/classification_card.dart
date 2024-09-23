import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/services/patient_service.dart';

class ClassificationCard extends StatefulWidget {
  final Patient patient;
  final bool changeable;
  final Function() onClassificationChanged;
  const ClassificationCard(
      {required this.patient, this.changeable = false, required this.onClassificationChanged, super.key});

  @override
  State<ClassificationCard> createState() => _ClassificationCardState();
}

class _ClassificationCardState extends State<ClassificationCard> {

  @override
  void initState() {
    super.initState();
  }

  void showClassificationSelectionDialog(
      BuildContext context, Patient patient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)!.patientScreenClassificationTitle),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: PatientClass.values
                  .where((classification) =>
                      classification != PatientClass.notClassified)
                  .map((classification) => buildColorTile(
                      context: context,
                      classification: classification,
                      onTap: () {
                        PatientService.classifyPatient(
                            classification, patient).then((value) {
                          widget.onClassificationChanged();
                            },);
                        Navigator.of(context).pop();
                      }))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget buildColorTile(
      {required BuildContext context,
      required PatientClass classification,
      Function()? onTap}) {
    Widget tileContent;

    if (classification.isPre) {
      tileContent = Row(
        children: [
          Expanded(
            child: Container(
              color: classification.color,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      tileContent = Container(
        color: classification.color,
      );
    }

    Widget colorContainer = Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: tileContent,
    );

    return onTap != null
        ? GestureDetector(onTap: onTap, child: colorContainer)
        : colorContainer;
  }

  Widget _buildClassificationAction(PatientClass classification) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text(
                  AppLocalizations.of(context)!
                      .patientScreenClassificationTitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                ElevatedButton(
                    onPressed: () => showClassificationSelectionDialog(
                        context, widget.patient),
                    child: Text(classification == PatientClass.notClassified
                        ? AppLocalizations.of(context)!.select
                        : AppLocalizations.of(context)!.change)),
                if (classification != PatientClass.notClassified)
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: buildColorTile(
                          context: context, classification: classification))
              ])
            ])));
  }

  Widget _buildClassification(PatientClass classification) {
    if (classification == PatientClass.notClassified) {
      return Card(
          child: SizedBox(
              width: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(AppLocalizations.of(context)!
                      .patientScreenNoClassification))));
    } else {
      return Card(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Text(
                    AppLocalizations.of(context)!
                        .patientScreenClassificationTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: buildColorTile(
                          context: context, classification: classification))
                ])
              ])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return  widget.changeable
            ? _buildClassificationAction(widget.patient.classification)
            : _buildClassification(widget.patient.classification);
  }
}
