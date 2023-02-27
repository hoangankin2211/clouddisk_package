import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../localization/app_localization.dart';

class FolderNameDialog extends StatelessWidget {
  FolderNameDialog({
    super.key,
  });

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Enter the Folder Name",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TextField(
              autocorrect: false,
              autofocus: true,
              maxLines: 1,
              controller: controller,
              expands: false,
              inputFormatters: [
                FilteringTextInputFormatter(FolderNamePattern(), allow: true),
              ],
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                hintText: "Folder Name",
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Colors.blueGrey.shade200,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalization.of(context)?.translate("cancel") ??
                        "Cancel",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(controller.text),
                  child: Text(
                    AppLocalization.of(context)?.translate("ok") ?? "OK",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FolderNamePattern implements Pattern {
  final RegExp _regexp = RegExp(r'^[a-zA-Z0-9_-]+$');

  @override
  Match? matchAsPrefix(String string, [int start = 0]) {
    return _regexp.matchAsPrefix(string, start);
  }

  @override
  Iterable<Match> allMatches(String string, [int start = 0]) {
    return _regexp.allMatches(string, start);
  }

  @override
  String toString() => _regexp.toString();
}
