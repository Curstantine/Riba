import "package:flutter/material.dart";

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String? title;
  final Icon? leading;
  final Icon? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      style: ListTileStyle.list,
      textColor: theme.colorScheme.onSurfaceVariant,
      iconColor: theme.colorScheme.onSurfaceVariant,
      title: title == null ? null : Text(title!, style: theme.textTheme.bodyLarge),
      leading: leading,
      onTap: onTap,
    );
  }
}
