import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_hero/src/hero_search.dart';
import 'package:flutter_hero/src/route_name.dart';
import 'package:model/hero.dart' as model;
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndexForBottomNavigationBar = 0;
  model.HeroService _heroService;

  @override
  void didChangeDependencies() {
    _heroService = Provider.of<model.HeroService>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tour of Heroes'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final hero = await showSearch<model.Hero>(
                context: context,
                delegate: HeroSearch(
                  Provider.of<model.HeroSearchService>(context),
                ),
              );
              if (hero != null) {
                Navigator.pushNamed(context, RouteName.hero, arguments: hero);
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<UnmodifiableListView<model.Hero>>(
          stream: _heroService.topHeroes,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Top Heroes',
                        style: Theme.of(context).textTheme.headline),
                  );
                }
                final hero = snapshot.data[index - 1];
                return ListTile(
                  title: Text(hero.name),
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.hero,
                        arguments: hero);
                  },
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteName.heroAdding);
        },
        tooltip: 'Add your hero.',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Heros'),
          ),
        ],
        currentIndex: _selectedIndexForBottomNavigationBar,
        selectedItemColor: Colors.indigo[700],
        onTap: _onBottomNavigationBarItemTapped,
      ),
    );
  }

  void _onBottomNavigationBarItemTapped(int index) {
    if (index == 0) {
      return;
    } else if (index == 1) {
      Navigator.pushNamed(context, RouteName.heroes);
    } else {
      throw ArgumentError();
    }
  }
}
