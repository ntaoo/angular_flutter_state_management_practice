import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:model/hero.dart' as model;
import 'package:provider/provider.dart';

import 'route_name.dart';

class HeroListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _heroService = Provider.of<model.HeroService>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Heros'),
        ),
        body: StreamBuilder<UnmodifiableListView<model.Hero>>(
          stream: _heroService.allHeroes,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                final hero = snapshot.data[index];
                return ListTile(
                  leading: Text(hero.id.toString()),
                  title: Text(hero.name),
                  subtitle: Text(''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _heroService.delete(hero.id);
                    },
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.hero,
                        arguments: hero);
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteName.heroAdding);
          },
          tooltip: 'Add your hero.',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
