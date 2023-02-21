import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MoreScreenListTile extends StatelessWidget {
  const MoreScreenListTile({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    required this.trailingIcon,
    required this.onTap,
  });

  final String name;
  final String description;
  final IconData icon;
  final Widget? trailingIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      subtitle: Text(
        description,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      leading: FaIcon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      trailing: trailingIcon,
      horizontalTitleGap: 10,
      onTap: onTap,
    );
  }
}
