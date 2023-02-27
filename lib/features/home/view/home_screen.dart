import 'dart:async';
import 'package:clouddisk/clouddisk.dart';
import 'package:clouddisk/features/home/view/widget/custom_list_title.dart';
import 'package:clouddisk/features/home/view/widget/folder_name_dialog.dart';
import 'package:clouddisk/features/home/view/widget/list_item.dart';
import 'package:clouddisk/features/home/view/widget/sort_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../localization/app_localization.dart';
import '../../../model/item.dart';
import '../../../utils/shared_preferences.dart';
import '../../get_link/view/get_link_dialog.dart';
import '../../locale/bloc/locale_bloc.dart';
import '../bloc/create_upload/cre_up_bloc.dart';
import '../bloc/cubit/navigate_page_cubit.dart';
import '../bloc/cubit/select_file_cubit.dart';
import '../bloc/cubit/select_order_cubit.dart';
import '../bloc/cubit/select_sort_cubit.dart';
import '../bloc/open/item_bloc.dart';
import '../bloc/open/item_event.dart';
import '../bloc/open/item_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static final homepageNavigatorKey = GlobalKey<NavigatorState>();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ItemBloc()),
        BlocProvider(create: (context) => ListFileCubit()),
        BlocProvider(create: (context) => CreateUploadBloc()),
        BlocProvider(create: (context) => NavigatePageCubit()),
      ],
      child: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static List<Item> root = [];
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Locale locale;
  List<Item> routeName = [
    Item(
      id: "/",
      name: "..",
      size: 0,
      createDate: DateTime(2023),
      icon: Icons.folder,
      type: "dir",
    ),
  ];
  late Stream<List<String>> streamFolder;
  StreamController<List<String>> currentFolder = StreamController();
  @override
  void initState() {
    streamFolder = currentFolder.stream.asBroadcastStream();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    context.read<ItemBloc>().add(OpenMainFolderEvent());
    locale = context.read<LocaleBloc>().state.locale;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      body: BlocListener<NavigatePageCubit, NavigateState>(
        listener: _handleListener,
        child: BlocBuilder<ItemBloc, ItemState>(
          buildWhen: (previous, current) =>
              current.currentFolder == routeName.first.id,
          builder: (context, state) {
            if (state is LoadingItem || state is InitState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LoadListItemState) {
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
                //Save root folder (my,clouddisk,company,share)
                HomePage.root.addAll(state.listItems);
                if (context.isLargeScreen) {
                  routeName.replaceRange(
                      1, routeName.length, [state.listItems.first]);
                  currentFolder
                      .add(routeName.map((route) => route.name).toList());
                  return HomePageLargeScreen(
                    streamFolder: streamFolder,
                    isFolderEmpty: state.inFolderEmpty,
                    listItems: state.listItems,
                  );
                } else {
                  return HomePageSmallScreen(streamFolder: streamFolder);
                }
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
    );
  }

  void _handleListener(BuildContext context, NavigateState state) {
    if (state is PopState) {
      HomeScreen.homepageNavigatorKey.currentState!.pop();
      routeName.removeLast();
    } else if (state is PushAndRemoveUntilState) {
      HomeScreen.homepageNavigatorKey.currentState!.pushNamedAndRemoveUntil(
        "/listItem",
        (route) => false,
        arguments: {"item": state.item},
      );
      routeName.replaceRange(1, routeName.length, [state.item]);
    } else if (state is PushState) {
      HomeScreen.homepageNavigatorKey.currentState!.pushNamed(
        "/listItem",
        arguments: {"item": state.item},
      );
      routeName.add(state.item);
    } else if (state is PopUntil) {
      HomeScreen.homepageNavigatorKey.currentState!.popUntil(
        (route) {
          if (route.settings.arguments != null) {
            if (route.settings.arguments is Map<String, dynamic>) {
              return ((route.settings.arguments as Map)["item"] as Item).name ==
                  state.item;
            }
          }
          return true;
        },
      );
      routeName.removeRange(
          routeName.indexWhere((element) => element.name == state.item) + 1,
          routeName.length);
    }
    currentFolder.add(routeName.map((route) => route.name).toList());
  }

  void _showSortDialog(String folderId, Locale locale) {
    showDialog(
      context: context,
      builder: (appContext) => Localizations.override(
        context: appContext,
        locale: locale,
        child: SortDialog(
          onPressedSaveButton: (sortType, order, {isPressedDefaultButton}) =>
              _onPressedSaveButton(
            folderId,
            sortType,
            order,
            isPressedDefaultButton: isPressedDefaultButton,
          ),
        ),
      ),
    );
  }

  void _onPressedSaveButton(String folderId, SortType sortType, Order order,
      {bool? isPressedDefaultButton}) {
    if (isPressedDefaultButton != null && isPressedDefaultButton) {
      SharedPreferencesUtils.sharedPreferences!
          .setString("SortType", sortType.id);
      SharedPreferencesUtils.sharedPreferences!.setString("Order", order.id);
    }
    context.read<ItemBloc>().add(SortItemEvent(folderId, order, sortType));
  }

  Future<dynamic> showGetLinkDialog(List<Item> stateListFile, Locale locale) {
    return showDialog(
      context: context,
      builder: (appContext) => Localizations.override(
        locale: locale,
        context: context,
        child: GetlinkDialog(items: stateListFile),
      ),
    );
  }

  AppBar get myAppBar {
    return AppBar(
      bottom: !context.isLargeScreen
          ? PreferredSize(
              preferredSize: const Size.square(0),
              child: actionButton(context),
            )
          : null,
      backgroundColor: const Color.fromARGB(255, 68, 167, 162),
      toolbarHeight: 80,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_outlined),
        onPressed: () {
          if (routeName.length > 1) {
            context.read<NavigatePageCubit>().pop();
          } else {
            showDialog(
              context: context,
              builder: (context) => Localizations.override(
                context: context,
                locale: locale,
                child: Dialog(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        AppLocalization.of(context)
                                ?.translate("back_to_hanbrio") ??
                            "Back to Hanbiro ?",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.red[400]),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              AppLocalization.of(context)
                                      ?.translate("cancel") ??
                                  "Cancel",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              AppLocalization.of(context)?.translate("ok") ??
                                  "OK",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
      actions: [
        if (context.isLargeScreen) actionButton(context),
        BlocBuilder<ListFileCubit, List<Item>>(
          builder: (context, stateListFile) => IconButton(
            onPressed: () => showGetLinkDialog(stateListFile, locale),
            icon: const Icon(Icons.send_outlined, color: Colors.white),
          ),
        ),
        StreamBuilder<List<String>>(
            stream: streamFolder,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.requireData.length > 1) {
                  return PopupMenuButton(
                    iconSize: 20,
                    onSelected: (value) {
                      if (value == "Sort") {
                        _showSortDialog(routeName.last.id, locale);
                      }
                    },
                    icon: const Icon(Icons.more_vert_outlined),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        height: 10,
                        value: "Sort",
                        child: Text(
                            AppLocalization.of(context)?.translate("sort") ??
                                "NULL"),
                      ),
                    ],
                  );
                }
              }
              return const SizedBox();
            })
      ],
      title: BlocBuilder<ListFileCubit, List<Item>>(
        builder: (context, stateListFile) => RichText(
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
      ),
    );
  }

  Widget actionButton(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: streamFolder,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.requireData.length > 1) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 5),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    // fixedSize: const Size.fromWidth(130),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    side: const BorderSide(
                      width: 0.5,
                      color: Colors.blueGrey,
                    ),
                  ),
                  onPressed: () {
                    FilePicker.platform.pickFiles(allowMultiple: true).then(
                      (result) {
                        if (result != null) {
                          context.read<CreateUploadBloc>().add(
                                UploadFileEvent(
                                  parentId: routeName.last.id,
                                  file: result.files,
                                ),
                              );
                        }
                      },
                    );
                  },
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: Text("Upload",
                      style: Theme.of(context).textTheme.displaySmall),
                ),
                const SizedBox(width: 10),
                TextButton.icon(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      backgroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      side: const BorderSide(
                        width: 0.5,
                        color: Colors.blueGrey,
                      )),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => FolderNameDialog()).then(
                      (value) {
                        if (value is String) {
                          context.read<CreateUploadBloc>().add(
                                CreateFolderEvent(
                                  force: "1",
                                  name: value,
                                  parentId: routeName.last.id,
                                ),
                              );
                        }
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.folder,
                    color: Colors.yellow,
                  ),
                  label: Text(
                    "Create Folder",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class HomePageSmallScreen extends StatelessWidget {
  const HomePageSmallScreen({
    required this.streamFolder,
    super.key,
  });
  final Stream<List<String>> streamFolder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        RoutePathControl(
          streamFolder: streamFolder,
        ),
        const Expanded(
          child: ListFolderTree(),
        ),
      ],
    );
  }
}

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

class ListFolderTree extends StatelessWidget {
  const ListFolderTree({
    super.key,
    this.initRoute,
  });
  final Item? initRoute;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: HomeScreen.homepageNavigatorKey,
      onGenerateRoute: (settings) {
        Widget currentPage = ListItem(folderId: initRoute?.id ?? "/");
        if (settings.arguments != null) {
          var item =
              (settings.arguments as Map<String, dynamic>)["item"] as Item?;
          if (item != null && settings.name == "/listItem") {
            currentPage = ListItem(folderId: item.id);
          }
          return PageRouteBuilder(
            settings: settings,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
            pageBuilder: (context, animation, secondaryAnimation) =>
                currentPage,
          );
        } else {
          return PageRouteBuilder(
            settings: initRoute != null
                ? RouteSettings(
                    name: settings.name, arguments: {"item": initRoute})
                : const RouteSettings(name: "/"),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
            pageBuilder: (context, animation, secondaryAnimation) =>
                currentPage,
          );
        }
      },
    );
  }
}

class RoutePathControl extends StatelessWidget {
  const RoutePathControl({
    super.key,
    required this.streamFolder,
  });
  final Stream<List<String>> streamFolder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: 30,
      decoration: BoxDecoration(color: Colors.blue[50]),
      alignment: Alignment.centerLeft,
      child: StreamBuilder<List<String>>(
          stream: streamFolder,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<String> data = snapshot.requireData;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10);
                },
                itemBuilder: (context, index) {
                  if ((data.elementAt(index) != "..")) {
                    return TextButton(
                      onPressed: () {
                        if (index == data.length - 1) {
                          return;
                        } else if (data.length < 2) {
                          return;
                        } else if (index == data.length - 2) {
                          context.read<NavigatePageCubit>().pop();
                        } else {
                          context
                              .read<NavigatePageCubit>()
                              .popUntil(data.elementAt(index));
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              const BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: Text(
                        data.elementAt(index),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              );
            }
            return const SizedBox();
          }),
    );
  }
}
