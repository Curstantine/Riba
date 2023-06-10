import "package:flutter/material.dart";
import "package:riba/repositories/mangadex/models/user.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/theme.dart";

import "root_action_popup_button.dart";

class RootActionBar extends StatelessWidget implements PreferredSizeWidget {
	const RootActionBar({super.key});

	@override
	Size get preferredSize => const Size.fromHeight(64);
	
	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final media = MediaQuery.of(context);
		final text = theme.textTheme;

		return Container(
			height: 64,
			padding: Edges.horizontalSmall,
			margin: EdgeInsets.only(top: media.padding.top),
			child: Row(children: [
				IconButton(onPressed: () => {}, icon: const Icon(Icons.person)),
				Column(
					mainAxisAlignment: MainAxisAlignment.center,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text("Guest", style: text.titleMedium?.copyWith(height: 0)),
						Text(UserRole.member.asHumanReadable(),
							style: text.bodySmall?.withColorOpacity(0.5).copyWith(letterSpacing: 0, height: 0))
					],
				),
				const Spacer(),
				const RootActionPopupButton(),
			]),
		);
	}
}
