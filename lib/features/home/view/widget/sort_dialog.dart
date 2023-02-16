import 'package:clouddisk/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cubit/select_order_cubit.dart';
import '../../bloc/cubit/select_sort_cubit.dart';

class SortDialog extends StatefulWidget {
  const SortDialog({super.key, required this.onPressedSaveButton});
  final Function(SortType sortType, Order order, {bool? isPressedDefaultButton})
      onPressedSaveButton;

  @override
  State<SortDialog> createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          String? sortType =
              SharedPreferencesUtils.sharedPreferences!.getString("SortType");
          if (sortType == "name") {
            return SelectSortCubit(SortType.fileName);
          } else if (sortType == "date") {
            return SelectSortCubit(SortType.date);
          } else {
            return SelectSortCubit(SortType.size);
          }
        }),
        BlocProvider(create: (context) {
          String? order =
              SharedPreferencesUtils.sharedPreferences!.getString("Order");
          if (order == "desc") {
            return SelectOrderCubit(Order.descending);
          } else {
            return SelectOrderCubit(Order.ascending);
          }
        }),
      ],
      child: Builder(builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sort Type",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    InkWell(
                      onTap: Navigator.of(context).pop,
                      child: const Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                BlocBuilder<SelectSortCubit, SortType>(
                  builder: (context, state) => Column(
                    children: [
                      Row(
                        children: [
                          Radio<SortType>(
                            value: SortType.size,
                            groupValue: state,
                            onChanged: (value) {
                              if (value != null) {
                                context
                                    .read<SelectSortCubit>()
                                    .onSelected(value);
                              }
                            },
                          ),
                          Text(
                            "Size",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<SortType>(
                              value: SortType.fileName,
                              groupValue: state,
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<SelectSortCubit>()
                                      .onSelected(value);
                                }
                              }),
                          Text(
                            "Filename",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<SortType>(
                              value: SortType.date,
                              groupValue: state,
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<SelectSortCubit>()
                                      .onSelected(value);
                                }
                              }),
                          Text(
                            "Date",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  "Order",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                BlocBuilder<SelectOrderCubit, Order>(
                  builder: (context, state) => Column(
                    children: [
                      Row(
                        children: [
                          Radio<Order>(
                            value: Order.ascending,
                            groupValue: state,
                            onChanged: (value) {
                              if (value != null) {
                                context
                                    .read<SelectOrderCubit>()
                                    .onSelected(value);
                              }
                            },
                          ),
                          Text(
                            "Ascending",
                            style: Theme.of(context).textTheme.displaySmall,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Radio<Order>(
                              value: Order.descending,
                              groupValue: state,
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<SelectOrderCubit>()
                                      .onSelected(value);
                                }
                              }),
                          Text(
                            "Descending",
                            style: Theme.of(context).textTheme.displaySmall,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300]),
                        onPressed: () {
                          widget.onPressedSaveButton(
                            context.read<SelectSortCubit>().state,
                            context.read<SelectOrderCubit>().state,
                            isPressedDefaultButton: true,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Save As Default",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300]),
                        onPressed: () {
                          widget.onPressedSaveButton(
                            context.read<SelectSortCubit>().state,
                            context.read<SelectOrderCubit>().state,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Save",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
