import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../model/item.dart';
import '../home_screen.dart';
import 'custom_list_title.dart';

class HomePageLargeScreen extends StatelessWidget {
  const HomePageLargeScreen({
    super.key,
    required this.streamFolder,
    required this.isFolderEmpty,
    required this.listItems,
  });
  final Stream<List<String>> streamFolder;
  final bool isFolderEmpty;
  final List<Item> listItems;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: CustomListTile(
              onRefresh: () async {},
              isFolderEmpty: isFolderEmpty,
              listItems: listItems,
            ),
          ),
          const VerticalDivider(color: Colors.grey, thickness: 0.3),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                RoutePathControl(streamFolder: streamFolder),
                Expanded(
                  child: ListFolderTree(
                    initRoute: HomePage.root.first,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
