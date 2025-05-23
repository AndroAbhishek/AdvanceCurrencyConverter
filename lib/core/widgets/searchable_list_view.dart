import 'package:advance_currency_convertor/core/widgets/custom_icon.dart';
import 'package:advance_currency_convertor/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class SearchableListView<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemLabel;
  final Widget Function(BuildContext, T) itemBuilder;
  final String hintText;

  const SearchableListView({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.itemBuilder,
    this.hintText = 'Search...',
  });

  @override
  State<SearchableListView<T>> createState() => _SearchableListViewState<T>();
}

class _SearchableListViewState<T> extends State<SearchableListView<T>> {
  late List<T> filteredItems;
  String query = '';

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void updateSearch(String value) {
    setState(() {
      query = value;
      filteredItems =
          widget.items
              .where(
                (item) => widget
                    .itemLabel(item)
                    .toLowerCase()
                    .contains(value.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomTextfield(
            hintText: widget.hintText,
            onChanged: updateSearch,
            prefixIcon: const CustomIcon(icon: Icons.search),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return widget.itemBuilder(context, filteredItems[index]);
            },
          ),
        ),
      ],
    );
  }
}
