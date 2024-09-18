import "package:flutter/material.dart";

/// Contains [EdgeInsets] constants with `all`, `top`, `right`, `bottom`, `left` variants.
///
/// Can be paired with [Radius] to create [BorderRadius] constants.
///
/// Uses [Shape Tokens](https://m3.material.io/styles/shape/shape-scale-tokens)
class Edges {
	/// 28 dp
	static const double extraLarge = 28;

	/// 16 dp
	static const double large = 16;

	/// 12 dp
	static const double medium = 12;

	/// 8 dp
	static const double small = 8;

	/// 4 dp
	static const double extraSmall = 4;

	/// 0 dp
	static const double none = 0;

	/// 28 dp all sides
	static const EdgeInsets allExtraLarge = EdgeInsets.all(extraLarge);

	/// 16 dp all sides
	static const EdgeInsets allLarge = EdgeInsets.all(large);

	/// 12 dp all sides
	static const EdgeInsets allMedium = EdgeInsets.all(medium);

	/// 8 dp all sides
	static const EdgeInsets allSmall = EdgeInsets.all(small);

	/// 4 dp all sides
	static const EdgeInsets allExtraSmall = EdgeInsets.all(extraSmall);

	/// 0 dp all sides
	static const EdgeInsets allNone = EdgeInsets.all(none);

	/// 28 dp top
	static const EdgeInsets topExtraLarge = EdgeInsets.only(top: extraLarge);

	/// 16 dp top
	static const EdgeInsets topLarge = EdgeInsets.only(top: large);

	/// 12 dp top
	static const EdgeInsets topMedium = EdgeInsets.only(top: medium);

	/// 8 dp top
	static const EdgeInsets topSmall = EdgeInsets.only(top: small);

	/// 4 dp top
	static const EdgeInsets topExtraSmall = EdgeInsets.only(top: extraSmall);

	/// 0 dp top
	static const EdgeInsets topNone = EdgeInsets.only(top: none);

	/// 28 dp bottom
	static const EdgeInsets bottomExtraLarge = EdgeInsets.only(bottom: extraLarge);

	/// 16 dp bottom
	static const EdgeInsets bottomLarge = EdgeInsets.only(bottom: large);

	/// 12 dp bottom
	static const EdgeInsets bottomMedium = EdgeInsets.only(bottom: medium);

	/// 8 dp bottom
	static const EdgeInsets bottomSmall = EdgeInsets.only(bottom: small);

	/// 4 dp bottom
	static const EdgeInsets bottomExtraSmall = EdgeInsets.only(bottom: extraSmall);

	/// 0 dp bottom
	static const EdgeInsets bottomNone = EdgeInsets.only(bottom: none);

	/// 28 dp left
	static const EdgeInsets leftExtraLarge = EdgeInsets.only(left: extraLarge);

	/// 16 dp left
	static const EdgeInsets leftLarge = EdgeInsets.only(left: large);

	/// 12 dp left
	static const EdgeInsets leftMedium = EdgeInsets.only(left: medium);

	/// 8 dp left
	static const EdgeInsets leftSmall = EdgeInsets.only(left: small);

	/// 4 dp left
	static const EdgeInsets leftExtraSmall = EdgeInsets.only(left: extraSmall);

	/// 0 dp left
	static const EdgeInsets leftNone = EdgeInsets.only(left: none);

	/// 28 dp right
	static const EdgeInsets rightExtraLarge = EdgeInsets.only(right: extraLarge);

	/// 16 dp right
	static const EdgeInsets rightLarge = EdgeInsets.only(right: large);

	/// 12 dp right
	static const EdgeInsets rightMedium = EdgeInsets.only(right: medium);

	///  8 dp right
	static const EdgeInsets rightSmall = EdgeInsets.only(right: small);

	/// 4 dp right
	static const EdgeInsets rightExtraSmall = EdgeInsets.only(right: extraSmall);

	/// 0 dp right
	static const EdgeInsets rightNone = EdgeInsets.only(right: none);

	/// 28 dp horizontal
	static const EdgeInsets horizontalExtraLarge = EdgeInsets.symmetric(horizontal: extraLarge);

	/// 16 dp horizontal
	static const EdgeInsets horizontalLarge = EdgeInsets.symmetric(horizontal: large);

	/// 12 dp horizontal
	static const EdgeInsets horizontalMedium = EdgeInsets.symmetric(horizontal: medium);

	/// 8 dp horizontal
	static const EdgeInsets horizontalSmall = EdgeInsets.symmetric(horizontal: small);

	/// 4 dp horizontal
	static const EdgeInsets horizontalExtraSmall = EdgeInsets.symmetric(horizontal: extraSmall);

	/// 0 dp horizontal
	static const EdgeInsets horizontalNone = EdgeInsets.symmetric(horizontal: none);

	/// 28 dp vertical
	static const EdgeInsets verticalExtraLarge = EdgeInsets.symmetric(vertical: extraLarge);

	/// 16 dp vertical
	static const EdgeInsets verticalLarge = EdgeInsets.symmetric(vertical: large);

	/// 12 dp vertical
	static const EdgeInsets verticalMedium = EdgeInsets.symmetric(vertical: medium);

	/// 8 dp vertical
	static const EdgeInsets verticalSmall = EdgeInsets.symmetric(vertical: small);

	/// 4 dp vertical
	static const EdgeInsets verticalExtraSmall = EdgeInsets.symmetric(vertical: extraSmall);

	/// 0 dp vertical
	static const EdgeInsets verticalNone = EdgeInsets.symmetric(vertical: none);
}

class Corners {
	/// Fully rounded corners
	static const full = Radius.circular(100);

	/// 28 dp
	static const extraLarge = Radius.circular(Edges.extraLarge);

	/// 16 dp
	static const large = Radius.circular(Edges.large);

	/// 12 dp
	static const medium = Radius.circular(Edges.medium);

	/// 8 dp
	static const small = Radius.circular(Edges.small);

	/// 4 dp
	static const extraSmall = Radius.circular(Edges.extraSmall);

	/// 0 dp
	static const none = Radius.zero;

	/// All corners fully rounded
	static const allFull = BorderRadius.all(full);

	/// 28 dp all corners
	static const allExtraLarge = BorderRadius.all(extraLarge);

	/// 16 dp all corners
	static const allLarge = BorderRadius.all(large);

	/// 12 dp all corners
	static const allMedium = BorderRadius.all(medium);

	/// 8 dp all corners
	static const allSmall = BorderRadius.all(small);

	/// 4 dp all corners
	static const allExtraSmall = BorderRadius.all(extraSmall);

	/// 0 dp all corners
	static const allNone = BorderRadius.all(none);

	/// Fully rounded top left and top right
	static const topFull = BorderRadius.only(
		topRight: full,
		topLeft: full,
	);

	/// 28 dp top left and top right
	static const topExtraLarge = BorderRadius.only(
		topRight: extraLarge,
		topLeft: extraLarge,
	);

	/// 16 dp top left and top right
	static const topLarge = BorderRadius.only(topRight: large, topLeft: large);

	/// 12 dp top left and top right
	static const topMedium = BorderRadius.only(topRight: medium, topLeft: medium);

	/// 8 dp top left and top right
	static const topSmall = BorderRadius.only(topRight: small, topLeft: small);

	/// 4 dp top left and top right
	static const topExtraSmall = BorderRadius.only(
		topRight: extraSmall,
		topLeft: extraSmall,
	);

	/// 0 dp top left and top right
	static const topNone = BorderRadius.only(topRight: none, topLeft: none);

	/// Fully rounded bottom left and bottom right
	static const bottomFull = BorderRadius.only(
		bottomRight: full,
		bottomLeft: full,
	);

	/// 28 dp bottom left and bottom right
	static const bottomExtraLarge = BorderRadius.only(
		bottomRight: extraLarge,
		bottomLeft: extraLarge,
	);

	/// 16 dp bottom left and bottom right
	static const bottomLarge = BorderRadius.only(bottomRight: large, bottomLeft: large);

	/// 12 dp bottom left and bottom right
	static const bottomMedium = BorderRadius.only(
		bottomRight: medium,
		bottomLeft: medium,
	);

	/// 8 dp bottom left and bottom right
	static const bottomSmall = BorderRadius.only(bottomRight: small, bottomLeft: small);

	/// 4 dp bottom left and bottom right
	static const bottomExtraSmall = BorderRadius.only(
		bottomRight: extraSmall,
		bottomLeft: extraSmall,
	);

	/// 0 dp bottom left and bottom right
	static const bottomNone = BorderRadius.only(bottomRight: none, bottomLeft: none);

	/// Fully rounded top left and bottom left
	static const BorderRadius leftFull = BorderRadius.only(
		topLeft: full,
		bottomLeft: full,
	);

	/// 28 dp top left and bottom left
	static const BorderRadius leftExtraLarge = BorderRadius.only(
		topLeft: extraLarge,
		bottomLeft: extraLarge,
	);

	/// 16 dp top left and bottom left
	static const BorderRadius leftLarge = BorderRadius.only(topLeft: large, bottomLeft: large);

	/// 12 dp top left and bottom left
	static const BorderRadius leftMedium = BorderRadius.only(topLeft: medium, bottomLeft: medium);

	/// 8 dp top left and bottom left
	static const BorderRadius leftSmall = BorderRadius.only(topLeft: small, bottomLeft: small);

	/// 4 dp top left and bottom left
	static const BorderRadius leftExtraSmall = BorderRadius.only(
		topLeft: extraSmall,
		bottomLeft: extraSmall,
	);

	/// 0 dp top left and bottom left
	static const BorderRadius leftNone = BorderRadius.only(topLeft: none, bottomLeft: none);

	/// Fully rounded top right and bottom right
	static const BorderRadius rightFull = BorderRadius.only(
		topRight: full,
		bottomRight: full,
	);

	/// 28 dp top right and bottom right
	static const BorderRadius rightExtraLarge = BorderRadius.only(
		topRight: extraLarge,
		bottomRight: extraLarge
	);

	/// 16 dp top right and bottom right
	static const BorderRadius rightLarge = BorderRadius.only(topRight: large, bottomRight: large);

	/// 12 dp top right and bottom right
	static const BorderRadius rightMedium = BorderRadius.only(topRight: medium, bottomRight: medium);

	/// 8 dp top right and bottom right
	static const BorderRadius rightSmall = BorderRadius.only(topRight: small, bottomRight: small);

	/// 4 dp top right and bottom right
	static const BorderRadius rightExtraSmall = BorderRadius.only(
		topRight: extraSmall,
		bottomRight: extraSmall,
	);

	/// 0 dp top right and bottom right
	static const BorderRadius rightNone = BorderRadius.only(topRight: none, bottomRight: none);
}

extension EscapePadding on EdgeInsets {
	withFloatingEscape() => copyWith(bottom: bottom + 72);

	EdgeInsets copyWithSelf(EdgeInsets other) {
		return EdgeInsets.only(
			top: top != 0 ? top : other.top,
			right: right != 0 ? right : other.right,
			bottom: bottom != 0 ? bottom : other.bottom,
			left: left != 0 ? left : other.left,
		);
	}
}

class Shapes {
	static const none = RoundedRectangleBorder(
		side: BorderSide.none,
		borderRadius: Corners.allNone,
	);

	static outlinedCard(ThemeData theme) => RoundedRectangleBorder(
		side: BorderSide(color: theme.colorScheme.outline),
		borderRadius: Corners.allMedium,
	);

	static get bottomSheetCard => const RoundedRectangleBorder(
		side: BorderSide.none,
		borderRadius: Corners.topMedium,
	);
}

class IconButtonStyles {
	static filledIcon(ColorScheme colors) => IconButton.styleFrom(
		foregroundColor: colors.onPrimary,
		backgroundColor: colors.primary,
		disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
		hoverColor: colors.onPrimary.withOpacity(0.08),
		focusColor: colors.onPrimary.withOpacity(0.12),
		highlightColor: colors.onPrimary.withOpacity(0.12),
	);
}

class LocalDurations {
	static const Duration standard = Duration(milliseconds: 300);
	static const Duration emphasized = Duration(milliseconds: 500);
	static const Duration long = Duration(seconds: 1);
}

class LocalEasing {
	static const Curve standard = Cubic(0.2, 0.0, 0, 1.0);
	static const Curve emphasized = Curves.easeInOutCubicEmphasized;
}