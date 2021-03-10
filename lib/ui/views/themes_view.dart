import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/viewmodels/theme_view_model.dart';

class ThemesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ThemesViewModel>.withConsumer(
      viewModelBuilder: () => ThemesViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () {
                  model.setTheme(0, context);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      " Light Theme",
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  model.setTheme(1, context);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      " Dark Theme",
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  model.setTheme(2, context);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      " Mint Forest Theme",
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
