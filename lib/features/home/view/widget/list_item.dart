import 'package:clouddisk/features/home/view/widget/sort_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../constant/api_info.dart';
import '../../../../model/item.dart';
import '../../../../utils/shared_preferences.dart';
import '../../../get_link/view/get_link_dialog.dart';
import '../../bloc/cubit/select_file_cubit.dart';
import '../../bloc/cubit/select_order_cubit.dart';
import '../../bloc/cubit/select_sort_cubit.dart';
import '../../bloc/open/item_bloc.dart';
import '../../bloc/open/item_event.dart';
import '../../bloc/open/item_state.dart';

class ListItem extends StatefulWidget {
  const ListItem({
    super.key,
    required this.routePath,
    required this.folderId,
  });
  final String routePath;
  final String folderId;
  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  int start = 0;
  List<Item> currentList = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _loadItem([int start = 0, List<Item> currentList = const []]) async {
    if (widget.folderId == "/") {
      context.read<ItemBloc>().add(OpenMainFolderEvent());
    } else {
      context.read<ItemBloc>().add(
            OpenFolder(
              id: widget.folderId,
              start: start,
              currentList: currentList,
            ),
          );
    }
  }

  void _onScroll() {
    if (_isBottom) _loadItem(start, currentList);
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void didChangeDependencies() {
    _loadItem();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onPressedSaveButton(SortType sortType, Order order,
      {bool? isPressedDefaultButton}) {
    if (isPressedDefaultButton != null && isPressedDefaultButton) {
      SharedPreferencesUtils.sharedPreferences!
          .setString("SortType", sortType.id);
      SharedPreferencesUtils.sharedPreferences!.setString("Order", order.id);
    }
    context
        .read<ItemBloc>()
        .add(SortItemEvent(widget.folderId, order, sortType));
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          SortDialog(onPressedSaveButton: onPressedSaveButton),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListFileCubit, List<Item>>(
      builder: (context, stateListFile) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 68, 167, 162),
          bottom: widget.routePath == "../"
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(25),
                  child: Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(color: Colors.blue[50]),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.routePath,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ),
                ),
          actions: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => GetlinkDialog(items: stateListFile),
              ),
              icon: const Icon(
                Icons.send_outlined,
                color: Colors.white,
              ),
            ),
            if (widget.routePath != "../")
              PopupMenuButton(
                icon: const Icon(Icons.more_vert_outlined),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    height: 10,
                    onTap: () => _showSortDialog(context),
                    value: "Sort",
                    child: const Text("Sort"),
                  ),
                ],
              ),
          ],
          title: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.titleLarge,
              children: [
                const TextSpan(text: "CloudDisk "),
                if (stateListFile.isNotEmpty)
                  TextSpan(
                    style: TextStyle(color: Colors.yellow[300], fontSize: 17),
                    text: "(${stateListFile.length.toString()})",
                  )
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<ItemBloc, ItemState>(builder: (context, state) {
            if (state is LoadListItemState) {
              start = state.listItems.length;
              currentList = state.listItems;
              return state.listItems.isEmpty
                  ? Center(
                      child: Text(
                        "No Data",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 20),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        _loadItem();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NotificationListener<ScrollNotification>(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: state.inFolderEmpty ||
                                    state.listItems.length <=
                                        ApiParam.defaultItemLengthLimit
                                ? state.listItems.length
                                : state.listItems.length + 1,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (index >= state.listItems.length) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final item = state.listItems.elementAt(index);
                              return ListTile(
                                onTap: () {
                                  if (item.type == "dir") {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) => ItemBloc(),
                                          child: ListItem(
                                            routePath:
                                                "${widget.routePath}${item.name}/",
                                            folderId: item.id,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                leading: CircleAvatar(
                                  backgroundColor: item.color,
                                  child: Icon(item.icon, color: Colors.white),
                                ),
                                subtitle: item.type == "dir"
                                    ? null
                                    : Text(
                                        "${item.size.round()}KB ${DateFormat().add_yMd().format(item.createDate)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                title: Text(
                                  item.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                trailing: item.type == "dir"
                                    ? null
                                    : Checkbox(
                                        onChanged: (value) {
                                          if (value != null) {
                                            if (value) {
                                              context
                                                  .read<ListFileCubit>()
                                                  .addNewItem(item);
                                            } else {
                                              context
                                                  .read<ListFileCubit>()
                                                  .removeItem(item);
                                            }
                                          }
                                        },
                                        value: stateListFile.any(
                                            (element) => element.id == item.id),
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
            } else if (state is InitState || state is LoadingItem) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Center(
                child: Text(
                  "Can not open file in this application",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
