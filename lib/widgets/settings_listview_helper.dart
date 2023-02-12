import 'package:flutter/material.dart';

class SettingsListViewHelper extends StatelessWidget {
  final String option;

  const SettingsListViewHelper({required this.option, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 15, 10, 15),
      child: Row(
        children: [
          Text(
            option,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          Icon(
            Icons.keyboard_arrow_right_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
