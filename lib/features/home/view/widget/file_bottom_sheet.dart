import 'package:clouddisk/localization/app_localization.dart';
import 'package:flutter/material.dart';

class FailBottomSheet extends StatelessWidget {
  const FailBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Error !!! Some thing happened !!!",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalization.of(context)?.translate("ok") ?? "OK",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
