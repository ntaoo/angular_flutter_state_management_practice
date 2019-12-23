import 'package:flutter/material.dart';
import 'package:flutter_hero/src/hero_adding_page.dart';
import 'package:flutter_hero/src/hero_list_page.dart';
import 'package:flutter_hero/src/hero_page.dart';
import 'package:http/http.dart' as http;
import 'package:model/hero.dart' as model;
import 'package:model/in_memory_data_service.dart';
import 'package:provider/provider.dart';

import 'src/dashboard_page.dart';
import 'src/route_name.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<InMemoryDataService>.value(
      value: InMemoryDataService(),
      child: ProxyProvider<InMemoryDataService, model.HeroService>(
        update: (context, inMemoryDataService, _) {
          return model.HeroService(inMemoryDataService);
        },
        child: MaterialApp(
          title: 'Tour of Heroes',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            RouteName.dashboard: (context) {
              return Provider<model.HeroSearchService>(
                create: (context) {
                  final httpClient = Provider.of<http.Client>(context);
                  return model.HeroSearchService(httpClient);
                },
                dispose: (context, self) {
                  self.dispose();
                },
                child: DashboardPage(),
              );
            },
            RouteName.heroes: (context) => HeroListPage(),
            RouteName.hero: (context) => HeroPage(),
            RouteName.heroAdding: (context) => HeroAddingPage(),
          },
        ),
      ),
    );
  }
}
