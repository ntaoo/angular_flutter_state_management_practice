import 'dart:async';
import 'dart:collection';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'hero_component.dart';
import 'package:model/hero.dart';
import 'route_paths.dart';

@Component(
  selector: 'my-heroes',
  templateUrl: 'hero_list_component.html',
  styleUrls: ['hero_list_component.css'],
  directives: [coreDirectives, HeroComponent],
  pipes: [commonPipes],
)
class HeroListComponent implements OnInit, OnDestroy {
  final HeroService _heroService;
  final Router _router;
  List<StreamSubscription> _subscriptions = [];
  UnmodifiableListView<Hero> heroes;
  Hero selected;

  HeroListComponent(this._heroService, this._router);

  void _getHeroes() {
    _subscriptions.add(_heroService.allHeroes.listen((list) => heroes = list));
  }

  Future<void> add(String name) async {
    name = name.trim();
    if (name.isEmpty) return null;
    await _heroService.create(name);
    selected = null;
  }

  Future<void> delete(Hero hero) async {
    await _heroService.delete(hero.id);
    if (selected == hero) selected = null;
  }

  void ngOnInit() => _getHeroes();

  void ngOnDestroy() {
    _subscriptions.forEach((s) => s.cancel());
  }

  void onSelect(Hero hero) => selected = hero;

  String _heroUrl(int id) =>
      RoutePaths.hero.toUrl(parameters: {idParam: '$id'});

  Future<NavigationResult> gotoDetail() =>
      _router.navigate(_heroUrl(selected.id));
}
