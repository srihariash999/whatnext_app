import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/providers/theme_provider.dart';

class ThemesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ThemesProvider>.withConsumer(
      viewModelBuilder: () => ThemesProvider(),
      onModelReady: (model) => model.getSavedTheme(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              verticalSpaceLarge,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () {
                      model.setTheme(0, context);
                    },
                    child: ThemeCard(
                      name: "Light Theme",
                      subText: " Bright, light and glowy !",
                      showCheck: model.themeIndex == 0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              verticalSpaceMedium,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () {
                      model.setTheme(1, context);
                    },
                    child: ThemeCard(
                      name: "Dark Theme",
                      subText: " Dark, dim and beautiful !",
                      showCheck: model.themeIndex == 1,
                      color: Color(0xFF1B1929),
                    ),
                  ),
                ),
              ),
              verticalSpaceMedium,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () {
                      model.setTheme(2, context);
                    },
                    child: ThemeCard(
                      name: "Mint Forest Theme",
                      subText: " Greener than thou !",
                      showCheck: model.themeIndex == 2,
                      color: Color(0xFFA3EBB1),
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

class ThemeCard extends StatelessWidget {
  final String name;
  final String subText;
  final Color color;
  final bool showCheck;

  const ThemeCard({
    Key key,
    @required this.name,
    @required this.subText,
    @required this.color,
    @required this.showCheck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name",
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ),
                    Text(
                      subText,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline3
                          .copyWith(fontSize: 10.0),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 28.0,
                  width: 28.0,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Text(''),
                ),
                horizontalSpaceMedium,
                showCheck
                    ? Container(
                        width: 30.0,
                        child: Icon(
                          Icons.check_box_outlined,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      )
                    : Container(
                        width: 30.0,
                        child: Text(''),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
