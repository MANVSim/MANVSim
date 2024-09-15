import 'package:flutter/material.dart';

import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class BaseListScreenItem {
  final String name;
  final int id;

  BaseListScreenItem(this.name, this.id);
}

typedef BaseListScreenItems = List<BaseListScreenItem>;

class BaseListScreen extends StatefulWidget {
  final String title;
  final IconData icon;
  final Future<BaseListScreenItems> Function() fetchFutureItemList;
  final Function(BuildContext context, BaseListScreenItem item) onItemTap;
  final String Function(int id) nameFromId;

  const BaseListScreen(
      {super.key, required this.title, required this.fetchFutureItemList, required this.onItemTap, required this.icon, required this.nameFromId});

  @override
  State<BaseListScreen> createState() => _BaseListScreenState();
}

class _BaseListScreenState extends State<BaseListScreen> {
  late Future<BaseListScreenItems> futureItemList;
  final List<bool> _selectedShowAs = [true, false];

  @override
  void initState() {
    futureItemList = widget.fetchFutureItemList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> showAs = [
      AppLocalizations.of(context)!.locationListScreenTypeName,
      AppLocalizations.of(context)!.locationListScreenTypeId,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(children: [
        const SizedBox(height: 4),
        ToggleButtons(
          onPressed: (int index) {
            setState(() {
              // The button that is tapped is set to true, and the others to false.
              for (int i = 0; i < _selectedShowAs.length; i++) {
                _selectedShowAs[i] = i == index;
              }
            });
          },
          borderRadius: BorderRadius.circular(2),
          isSelected: _selectedShowAs,
          constraints: BoxConstraints(
              minWidth: (MediaQuery.of(context).size.width - 8) / 2),
          children: [
            Text(showAs[0]),
            Text(showAs[1]),
          ],
        ),
        Expanded(
            child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              futureItemList = widget.fetchFutureItemList();
            });
            return futureItemList;
          },
          child: ApiFutureBuilder<BaseListScreenItems>(
              future: futureItemList,
              builder: (context, listItems) => ListView.builder(
                  itemCount: listItems.length,
                  itemBuilder: (context, index) => Card(
                      child: ListTile(
                          leading: Icon(widget.icon),
                          title: Text(_selectedShowAs[0]
                              ? listItems[index].name
                              : widget.nameFromId(listItems[index].id)),
                          onTap: () => widget.onItemTap(context, listItems[index]))))),
        ))
      ]),
    );
  }
}
