import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model/hero.dart' as model;
import 'package:provider/provider.dart';

import 'route_name.dart';

class HeroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model.Hero _hero = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_hero.name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('id: ${_hero.id}', style: Theme.of(context).textTheme.title),
              _HeroForm(_hero),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroForm extends StatefulWidget {
  final model.Hero _hero;

  _HeroForm(this._hero);

  @override
  _HeroFormState createState() => _HeroFormState();
}

class _HeroFormState extends State<_HeroForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            initialValue: widget._hero.name,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter hero name';
              }
              return null;
            },
            onSaved: (value) {
              Provider.of<model.HeroService>(context)
                  .update(widget._hero..name = value);
              Navigator.pushNamed(context, RouteName.dashboard);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
