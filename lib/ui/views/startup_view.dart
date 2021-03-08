import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/viewmodels/startup_view_model.dart';

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartUpViewModel>.withConsumer(
      viewModelBuilder: () => StartUpViewModel(),
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Loading ... ",
                  style: Theme.of(context).primaryTextTheme.headline1,
                ),
              ),
              Container(
                height: 28.0,
                width: 28.0,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).primaryColorLight),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
