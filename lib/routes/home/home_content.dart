import 'package:flutter/material.dart';
import 'package:riba/utils/constants.dart';
import 'package:riba/utils/theme.dart' show TextColor;
import 'package:riba/widgets/horizontal_manga_list.dart';
import 'package:riba/widgets/manga_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [HorizontalMangaList(title: "Seasonal")],
        ),
      ),
    );
  }
}
