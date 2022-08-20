import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/providers/startup_provider.dart';

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartUpProvider>.withConsumer(
      viewModelBuilder: () => StartUpProvider(),
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
              Lottie.asset(
                'assets/lightning.json',
                height: 100.0,
                width: 100.0,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
