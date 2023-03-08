import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  final SvgPicture icon;
  final Widget? trailingIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;

    return ListTile(
      contentPadding: EdgeInsets.only(left: customWidth * 0.05, right: 5),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      subtitle: Text(
        description,
        style: TextStyle(
            fontSize: 14, color: Theme.of(context).colorScheme.shadow),
      ),
      leading: SizedBox(
        height: 24,
        width: 24,
        child: icon,
      ),
      trailing: trailingIcon,
      horizontalTitleGap: 10,
      onTap: onTap,
    );
  }
}
