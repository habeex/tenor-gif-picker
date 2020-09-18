import 'package:flutter/material.dart';
import 'package:tenor_picker/src/model/tenor_repository.dart';
import 'package:tenor_picker/src/widgets/tenor_context.dart';
import 'package:tenor_picker/src/widgets/tenor_preview_page.dart';

import 'package:tenor_picker/src/widgets/tenor_thumbnail.dart';

class TenorThumbnailGrid extends StatelessWidget {
  final TenorRepository repo;
  final ScrollController scrollController;
  final Widget title;
  final IconThemeData actionsIconTheme;
  final IconThemeData iconTheme;
  final Brightness brightness;

  const TenorThumbnailGrid(
      {Key key,
      @required this.repo,
      @required this.title,
      this.actionsIconTheme,
      this.iconTheme,
      this.brightness,
      this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        controller: scrollController,
        itemCount: repo.totalCount,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
            child: GiphyThumbnail(key: Key('$index'), repo: repo, index: index),
            onTap: () async {
              // display preview page
              final giphy = TenorContext.of(context);
              final gif = await repo.get(index);
              if (giphy.showPreviewPage) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => TenorPreviewPage(
                      gif: gif,
                      onSelected: giphy.onSelected,
                      title: title,
                      actionsIconTheme: actionsIconTheme,
                      iconTheme: iconTheme,
                      brightness: brightness,
                    ),
                  ),
                );
              } else {
                giphy.onSelected(gif);
              }
            }),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
            childAspectRatio: 1.6,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5));
  }
}
