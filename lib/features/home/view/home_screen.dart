import 'package:clouddisk/features/home/view/widget/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cubit/select_file_cubit.dart';
import '../bloc/open/item_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ItemBloc()),
        BlocProvider(create: (context) => ListFileCubit()),
      ],
      child: Scaffold(
        body: Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) =>
                  const ListItem(routePath: '../', folderId: "/"),
            );
          },
        ),
      ),
    );
  }
}
