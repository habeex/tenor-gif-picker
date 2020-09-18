import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giphy_picker/src/model/tenor_repository.dart';
import 'package:giphy_picker/src/widgets/tenor_context.dart';
import 'package:giphy_picker/src/widgets/tenor_thumbnail_grid.dart';

/// Provides the UI for searching Giphy gif images.
class TenorSearchView extends StatefulWidget {
  @override
  _TenorSearchViewState createState() => _TenorSearchViewState();
}

class _TenorSearchViewState extends State<TenorSearchView> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _repoController = StreamController<TenorRepository>();

  @override
  void initState() {
    // initiate search on next frame (we need context)
    Future.delayed(Duration.zero, () {
      final giphy = TenorContext.of(context);
      _search(giphy);
    });
    super.initState();
  }

  @override
  void dispose() {
    _repoController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final giphy = TenorContext.of(context);

    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: _textController,
          decoration: InputDecoration(hintText: giphy.searchText),
          onChanged: (value) => _delayedSearch(giphy, value),
        ),
      ),
      Expanded(
          child: StreamBuilder(
              stream: _repoController.stream,
              builder: (BuildContext context, AsyncSnapshot<TenorRepository> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.totalCount > 0
                      ? NotificationListener(
                          child: RefreshIndicator(
                              child: TenorThumbnailGrid(
                                  key: Key('${snapshot.data.hashCode}'),
                                  repo: snapshot.data,
                                  scrollController: _scrollController),
                              onRefresh: () => _search(giphy, term: _textController.text)),
                          onNotification: (n) {
                            // hide keyboard when scrolling
                            if (n is UserScrollNotification) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              return true;
                            }
                            return false;
                          },
                        )
                      : Center(child: Text('No results'));
                } else if (snapshot.hasError) {
                  return Center(child: Text('An error occurred'));
                }
                return Center(child: CircularProgressIndicator());
              }))
    ]);
  }

  void _delayedSearch(TenorContext giphy, String term) =>
      Future.delayed(Duration(milliseconds: 500), () => _search(giphy, term: term));

  Future _search(TenorContext giphy, {String term = ''}) async {
    // skip search if term does not match current search text
    if (term != _textController.text) {
      return;
    }

    try {
      // search, or trending when term is empty
      final repo = await (term.isEmpty
          ? TenorRepository.trending(apiKey: giphy.apiKey, onError: giphy.onError)
          : TenorRepository.search(apiKey: giphy.apiKey, query: term, onError: giphy.onError));

      // scroll up
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      _repoController.add(repo);
    } catch (error) {
      _repoController.addError(error);
      giphy.onError(error);
    }
  }
}