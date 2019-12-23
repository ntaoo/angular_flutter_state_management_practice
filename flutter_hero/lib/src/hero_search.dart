import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hero/src/route_name.dart';
import 'package:model/hero.dart' as model;

class HeroSearch extends SearchDelegate<model.Hero> {
  final model.HeroSearchService _heroSearchService;

  HeroSearch(this._heroSearchService);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _heroSearchService.searchQuery.add(query);

    return StreamBuilder<UnmodifiableListView<model.Hero>>(
        stream: _heroSearchService.searchResult,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          return ListView(
            children: snapshot.data.map<ListTile>(
              (hero) {
                return ListTile(
                  title: Text(
                    hero.name,
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontSize: 16.0),
                  ),
                  leading: Icon(Icons.book),
                  onTap: () async {
                    close(context, hero);
                  },
                );
              },
            ).toList(),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _heroSearchService.searchQuery.add(query);

    return StreamBuilder<UnmodifiableListView<model.Hero>>(
        stream: _heroSearchService.searchResult,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          return ListView(
            children: snapshot.data
                .map<ListTile>((h) => ListTile(
                      title: Text(h.name,
                          style: Theme.of(context).textTheme.subhead.copyWith(
                                fontSize: 16.0,
                                color: Colors.blue,
                              )),
                      onTap: () {
                        close(context, h);
                      },
                    ))
                .toList(),
          );
        });
  }
}
