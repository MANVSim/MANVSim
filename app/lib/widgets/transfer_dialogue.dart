import 'package:flutter/material.dart';
import 'package:manvsim/services/player_service.dart';

import '../models/location.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TransferDialogueType { put, take }

class TransferDialogue extends StatefulWidget {
  final Location baseLocation;
  final List<Location>? inventoryPath;
  final List<Location>? locationPath;
  final TransferDialogueType operation;

  const TransferDialogue(
      {super.key,
      this.inventoryPath,
      this.locationPath,
      required this.operation,
      required this.baseLocation});

  @override
  State<StatefulWidget> createState() => TransferDialogueState();
}

class TransferDialogueState extends State<TransferDialogue> {

  bool _confirmed = false;
  String? _errorMessage;

  List<String> get _selectedInventoryPathNames {
    String inventoryName =
        AppLocalizations.of(context)!.locationScreenInventory;
    return widget.inventoryPath != null
        ? [inventoryName, ...widget.inventoryPath!.map((e) => e.name)]
        : [inventoryName];
  }

  List<String> get _selectedLocationPathNames => widget.locationPath != null
      ? [widget.baseLocation.name, ...widget.locationPath!.map((e) => e.name)]
      : [widget.baseLocation.name];


  void _onError(String? message) {
    setState(() {
      _errorMessage = message?? "Error";
    });
  }
  
  Widget _confirmationDialogue(BuildContext context) {
    final Location transferLocation =
        widget.operation == TransferDialogueType.put
            ? widget.inventoryPath!.last
            : widget.locationPath!.last;

    final IconData fromIcon = widget.operation == TransferDialogueType.put
        ? Icons.inventory_2_outlined
        : Icons.location_on_outlined;

    final IconData toIcon = widget.operation == TransferDialogueType.put
        ? Icons.location_on_outlined
        : Icons.inventory_2_outlined;

    final fromText = widget.operation == TransferDialogueType.put
        ? _selectedInventoryPathNames.join(" -> ")
        : _selectedLocationPathNames.join(" -> ");

    final toText = widget.operation == TransferDialogueType.put
        ? _selectedLocationPathNames.join(" -> ")
        : _selectedInventoryPathNames.join(" -> ");

    return AlertDialog(
      title: Text(widget.operation == TransferDialogueType.put
          ? AppLocalizations.of(context)!.transferDialoguePutTitle
          : AppLocalizations.of(context)!.transferDialogueTakeTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(fromIcon, size: 32),
                ),
              ),
              const Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.arrow_forward, size: 32),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(toIcon, size: 32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Table(
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: FixedColumnWidth(6.0),
              2: FlexColumnWidth(),
            },
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(AppLocalizations.of(context)!.transferDialogueTransferObject,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(transferLocation.name),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(AppLocalizations.of(context)!.transferDialogueFromLocation,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(fromText),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(AppLocalizations.of(context)!.transferDialogueToLocation,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(toText),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.transferDialogueCancel)),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _confirmed = true;
              });
            },
            child: Text(AppLocalizations.of(context)!.transferDialogueConfirm))
      ],
    );
  }

  Widget _executionDialogue(BuildContext context) {
    Future<void> waitFuture = (widget.operation == TransferDialogueType.put)
        ? PlayerService.putItem(widget.baseLocation, widget.inventoryPath, widget.locationPath)
        : PlayerService.takeItem(widget.baseLocation, widget.inventoryPath, widget.locationPath);

    waitFuture
        .then((value) => Navigator.of(context).pop())
        .onError((error, stackTrace) =>_onError(error.toString()));

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.transferDialogueTransferTitle),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _errorDialogue(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    if (!_confirmed) {
      return _confirmationDialogue(context);
    } else if (_errorMessage != null) {
      return _errorDialogue(context);
    } else {
      return _executionDialogue(context);
    }
  }
}
