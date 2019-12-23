import 'dart:async';
import 'dart:collection';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:model/hero.dart';
import 'route_paths.dart';

@Component(
  selector: 'hero-search',
  templateUrl: 'hero_search_component.html',
  styleUrls: ['hero_search_component.css'],
  directives: [coreDirectives],
  providers: [ClassProvider(HeroSearchService)],
  pipes: [commonPipes],
)
class HeroSearchComponent {
  HeroSearchService heroSearchService;
  Router _router;

  UnmodifiableListView<Hero> heroes;

  HeroSearchComponent(this.heroSearchService, this._router);

  void search(String term) => heroSearchService.searchQuery.add(term);

  String _heroUrl(int id) =>
      RoutePaths.hero.toUrl(parameters: {idParam: '$id'});

  Future<NavigationResult> gotoDetail(Hero hero) =>
      _router.navigate(_heroUrl(hero.id));
}
