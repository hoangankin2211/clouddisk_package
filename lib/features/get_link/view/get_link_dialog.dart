import 'dart:convert';
import 'dart:math';

import 'package:clouddisk/clouddisk.dart';
import 'package:clouddisk/constant/root_path.dart';
import 'package:clouddisk/localization/app_localization.dart';
import 'package:clouddisk/model/get_link_response.dart';
import 'package:clouddisk/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../model/item.dart';
import '../../../utils/url_launcher_service.dart';
import '../bloc/get_link_bloc.dart';
import '../bloc/get_link_event.dart';
import '../bloc/get_link_state.dart';

class GetlinkDialog extends StatefulWidget {
  const GetlinkDialog({
    super.key,
    required this.items,
  });
  final List<Item> items;
  @override
  State<GetlinkDialog> createState() => _GetlinkDialogState();
}

class _GetlinkDialogState extends State<GetlinkDialog> {
  final TextEditingController countController =
      TextEditingController(text: "100");

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetlinkBloc(),
      child: Builder(builder: (context) {
        return Dialog(
          alignment: Alignment.center,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: BlocBuilder<GetlinkBloc, GetlinkState>(
            builder: (context, state) => state is ExposeLinkState
                ? SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Column(
                      children: [
                        ...ListTile.divideTiles(
                          context: context,
                          tiles: state.linkResponse
                              .map(
                                (link) => ListTile(
                                  onTap: () =>
                                      OpenUrlService.openUrl(link.link),
                                  leading: const CircleAvatar(
                                      child: Icon(Icons.file_copy,
                                          color: Colors.white)),
                                  title: Text(
                                    link.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  subtitle: Text(
                                    link.link,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: Colors.blueGrey),
                                  ),
                                ),
                              )
                              .toList(),
                        ).toList(),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).popUntil((route) {
                                if (route.settings.name == RootPath.root) {
                                  (route.settings.arguments as Map)["result"] =
                                      state.linkResponse;

                                  return true;
                                }
                                return false;
                              });
                            },
                            child: Text(
                              AppLocalization.of(context)
                                      ?.translate("back_to_hanbrio") ??
                                  'Back to Hanbiro',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                      ],
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    padding: const EdgeInsets.all(15.0),
                    child: state is GettingShareLink
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CloudDisk",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                AppLocalization.of(context)
                                        ?.translate('expried_date') ??
                                    "Expired Date (NOT less than current date)",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              InkWell(
                                onTap: () => showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030),
                                ).then((value) {
                                  if (value != null) {
                                    context
                                        .read<GetlinkBloc>()
                                        .add(SelectDateTime(value));
                                  }
                                }),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat().add_yMMMd().format(
                                            state is SelectTimeState
                                                ? state.selectedDateTime
                                                : DateTime.now()),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                      const Icon(
                                        Icons.calendar_month_outlined,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                AppLocalization.of(context)
                                        ?.translate("download_count") ??
                                    "Download count (greater than 0)",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              SizedBox(
                                height: 20,
                                child: TextField(
                                  controller: countController,
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: Navigator.of(context).pop,
                                    child: Text(
                                      AppLocalization.of(context)
                                              ?.translate("cancel") ??
                                          "CANCEL",
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  TextButton(
                                    onPressed: () => context
                                        .read<GetlinkBloc>()
                                        .add(ShareLinkEvent(
                                            items: widget.items,
                                            selectedDateTime: state
                                                    is SelectTimeState
                                                ? state.selectedDateTime
                                                : DateTime.now().add(
                                                    const Duration(minutes: 15),
                                                  ),
                                            downCount: int.parse(
                                                countController.text))),
                                    child: Text(
                                      AppLocalization.of(context)
                                              ?.translate("ok") ??
                                          "OK",
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                  ),
          ),
        );
      }),
    );
  }
}
