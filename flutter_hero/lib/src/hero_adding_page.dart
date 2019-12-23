import 'package:flutter/material.dart';
import 'package:model/hero.dart' as model;
import 'package:provider/provider.dart';

import 'route_name.dart';

class HeroAddingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Your Hero'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _HeroAddingForm(),
        ),
      ),
    );
  }
}

class _HeroAddingForm extends StatefulWidget {
  _HeroAddingForm();

  @override
  _HeroAddingFormState createState() => _HeroAddingFormState();
}

class _HeroAddingFormState extends State<_HeroAddingForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(hintText: "Please enter hero name"),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter hero name';
              }
              return null;
            },
            onSaved: (value) {
              Provider.of<model.HeroService>(context).create(value);
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
              child: Text('Add'),
            ),
          ),
        ],
      ),
    );
  }
}
