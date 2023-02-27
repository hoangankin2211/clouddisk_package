import 'package:flutter/material.dart';
import '../home_screen.dart';

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
