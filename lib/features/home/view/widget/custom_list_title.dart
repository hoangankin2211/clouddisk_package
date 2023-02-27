import 'package:clouddisk/clouddisk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api/api_info.dart';
import '../../../../model/item.dart';
import '../../bloc/cubit/navigate_page_cubit.dart';
import '../home_screen.dart';
import 'list_title_item.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.onRefresh,
    required this.isFolderEmpty,
    required this.listItems,
    this.stateListFile,
    this.scrollController,
  });
  final Future Function() onRefresh;
  final bool isFolderEmpty;
  final List<Item> listItems;
  final List<Item>? stateListFile;
  final ScrollController? scrollController;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NotificationListener<ScrollNotification>(
          child: ListView.builder(
            controller: scrollController,
            itemCount: isFolderEmpty ||
                    listItems.length <= ApiParam.defaultItemLengthLimit
                ? listItems.length
                : listItems.length + 1,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index >= listItems.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final item = listItems.elementAt(index);
              return ListTileItem(
                item: item,
                checkBoxValue:
                    stateListFile?.any((element) => element.id == item.id) ??
                        false,
                onTap: () {
                  if (item.type == "dir") {
                    if (HomePage.root.map((e) => e.id).contains(item.id) &&
                        context.isLargeScreen) {
                      context
                          .read<NavigatePageCubit>()
                          .pushAndRemoveUntil(item);
                    } else {
                      context.read<NavigatePageCubit>().push(item);
                    }
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
