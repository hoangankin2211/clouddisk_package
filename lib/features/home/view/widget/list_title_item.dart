import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../model/item.dart';
import '../../bloc/cubit/select_file_cubit.dart';

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
