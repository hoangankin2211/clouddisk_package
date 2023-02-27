import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../localization/app_localization.dart';
import '../../../../model/item.dart';

import '../../bloc/create_upload/cre_up_bloc.dart';
import '../../bloc/cubit/select_file_cubit.dart';

import '../../bloc/open/item_bloc.dart';
import '../../bloc/open/item_event.dart';
import '../../bloc/open/item_state.dart';
import '../home_screen.dart';
import 'custom_list_title.dart';
import 'file_bottom_sheet.dart';

class ListItem extends StatefulWidget {
  const ListItem({
    super.key,
    required this.folderId,
  });
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

  Future _loadItem([int start = 0, List<Item> currentList = const []]) async {
    if (widget.folderId == "/") {
      currentList = HomePage.root;
    } else {
      context.read<ItemBloc>().add(
            OpenFolder(
                id: widget.folderId, start: start, currentList: currentList),
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateUploadBloc, CreateUploadState>(
      listenWhen: (previous, current) =>
          current.status == CreateUploadStatus.success ||
          current.status == CreateUploadStatus.fail,
      listener: (context, state) {
        if (state.status == CreateUploadStatus.success) {
          _loadItem();
        } else if (state.status == CreateUploadStatus.fail) {
          showBottomSheet(
            context: context,
            builder: (context) => const FailBottomSheet(),
          );
        }
      },
      builder: (context, createState) => createState.status ==
              CreateUploadStatus.handling
          ? const Center(child: CircularProgressIndicator())
          : BlocBuilder<ListFileCubit, List<Item>>(
              builder: (context, stateListFile) => Scaffold(
                body: SafeArea(
                  child: BlocBuilder<ItemBloc, ItemState>(
                    buildWhen: (previous, current) {
                      return current.currentFolder == widget.folderId;
                    },
                    builder: (context, state) {
                      if (state is LoadingItem || state is InitState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LoadListItemState) {
                        start = state.listItems.length;
                        currentList = state.listItems;
                        if (state.listItems.isEmpty || currentList.isEmpty) {
                          return Center(
                            child: Text(
                              AppLocalization.of(context)
                                      ?.translate("no_data") ??
                                  "No Data",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontSize: 20),
                            ),
                          );
                        } else {
                          return CustomListTile(
                            onRefresh: _loadItem,
                            isFolderEmpty: state.inFolderEmpty,
                            listItems: currentList,
                            stateListFile: stateListFile,
                            scrollController: _scrollController,
                          );
                        }
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
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
