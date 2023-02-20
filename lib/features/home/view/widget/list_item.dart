import 'package:clouddisk/features/home/view/widget/sort_dialog.dart';
import 'package:clouddisk/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../constant/api_info.dart';
import '../../../../model/item.dart';
import '../../../../utils/shared_preferences.dart';
import '../../../get_link/view/get_link_dialog.dart';
import '../../../locale/bloc/locale_bloc.dart';
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
  late final Locale locale;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  Future _loadItem([int start = 0, List<Item> currentList = const []]) async {
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
    locale = context.read<LocaleBloc>().state.locale;
    print(locale.languageCode);
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

  void _showSortDialog(BuildContext context, Locale locale) {
    showDialog(
      context: context,
      builder: (context) => Localizations.override(
          context: context,
          locale: locale,
          child: SortDialog(onPressedSaveButton: onPressedSaveButton)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListFileCubit, List<Item>>(
      builder: (context, stateListFile) => Scaffold(
        appBar: myAppBar(context, stateListFile),
        body: SafeArea(
          child: BlocBuilder<ItemBloc, ItemState>(builder: (context, state) {
            if (state is LoadListItemState) {
              start = state.listItems.length;
              currentList = state.listItems;
              if (state.listItems.isEmpty) {
                return Center(
                  child: Text(
                    AppLocalization.of(context)?.translate("no_data") ??
                        "No Data",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 20),
                  ),
                );
              } else {
                return CustomListTile(
                  onRefesh: _loadItem,
                  isFolderEmpty: state.inFolderEmpty,
                  listItems: state.listItems,
                  stateListFile: stateListFile,
                  routeName: widget.routePath,
                  scrollController: _scrollController,
                );
              }
            } else if (state is InitState || state is LoadingItem) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Center(
                child: Text(
                  AppLocalization.of(context)?.translate(
                          "can_not_open_file_in_this_application") ??
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

  AppBar myAppBar(BuildContext appContext, List<Item> stateListFile) {
    return AppBar(
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
          onPressed: () => showGetLinkDialog(appContext, stateListFile, locale),
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
                onTap: () => _showSortDialog(context, locale),
                value: "Sort",
                child: Text(
                    AppLocalization.of(context)?.translate("sort") ?? "NULL"),
              ),
            ],
          ),
      ],
      title: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.titleLarge,
          children: [
            const TextSpan(text: "CloudDisk"),
            if (stateListFile.isNotEmpty)
              TextSpan(
                style: TextStyle(color: Colors.yellow[300], fontSize: 17),
                text: "(${stateListFile.length.toString()})",
              )
          ],
        ),
      ),
    );
  }

  Future<dynamic> showGetLinkDialog(
      BuildContext context, List<Item> stateListFile, Locale locale) {
    return showDialog(
      context: context,
      builder: (context) => Localizations.override(
          locale: locale,
          context: context,
          child: GetlinkDialog(items: stateListFile)),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.onRefesh,
    required this.isFolderEmpty,
    required this.listItems,
    required this.stateListFile,
    required this.routeName,
    required this.scrollController,
  });
  final Future Function() onRefesh;
  final bool isFolderEmpty;
  final List<Item> listItems;
  final List<Item> stateListFile;
  final String routeName;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefesh,
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
                    stateListFile.any((element) => element.id == item.id),
                onTap: () {
                  if (item.type == "dir") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => ItemBloc(),
                          child: ListItem(
                            routePath: "$routeName${item.name}/",
                            folderId: item.id,
                          ),
                        ),
                      ),
                    );
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

class ListTileItem extends StatelessWidget {
  const ListTileItem({
    super.key,
    required this.item,
    required this.checkBoxValue,
    required this.onTap,
  });

  final Item item;
  final bool checkBoxValue;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: item.color,
        child: Icon(item.icon, color: Colors.white),
      ),
      subtitle: item.type == "dir"
          ? null
          : Text(
              "${item.size.round()}KB ${DateFormat().add_yMd().format(item.createDate)}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
      title: Text(
        item.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: item.type == "dir"
          ? null
          : Checkbox(
              onChanged: (value) {
                if (value != null) {
                  if (value) {
                    context.read<ListFileCubit>().addNewItem(item);
                  } else {
                    context.read<ListFileCubit>().removeItem(item);
                  }
                }
              },
              value: checkBoxValue,
            ),
    );
  }
}
