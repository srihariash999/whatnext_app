import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/providers/about_app_provider.dart';

// import 'package:whatnext/ui/widgets/expansion_list.dart';

class AboutAppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AboutAppProvider>.withConsumer(
      viewModelBuilder: () => AboutAppProvider(),
      onModelReady: (model) => model.requestAboutApp(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "About App",
            style: Theme.of(context).primaryTextTheme.headline3,
          ),
          elevation: 0.0,
          actions: [
            InkWell(
              onTap: () {
                if (!model.busy) {
                  model.onRatetap();
                }
              },
              child: Row(
                children: [
                  Text(
                    'Rate ',
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                  Icon(
                    FeatherIcons.star,
                    size: 18.0,
                  ),
                  horizontalSpaceTiny,
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: model.busy
              ? Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: 80.0,
                          width: 180.0,
                          padding: EdgeInsets.all(4.0),
                          child: Image.asset('assets/whatnext_logo.png'),
                        ),
                      ),
                      Text(
                        "${model.aboutApp.version}",
                        style: Theme.of(context).primaryTextTheme.bodyText1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Text(
                          "${model.aboutApp.description}",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline4
                              .copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Divider(
                        color: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(0.50),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          "People : ",
                          style: Theme.of(context).primaryTextTheme.headline2,
                        ),
                      ),
                      verticalSpaceSmall,
                      Column(
                        children: model.aboutApp.contributors
                            .map(
                              (contributor) => Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                padding: EdgeInsets.all(8.0),
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    verticalSpaceTiny,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 4.0,
                                            ),
                                            Icon(
                                              FeatherIcons.user,
                                              size: 18.0,
                                              color: Theme.of(context)
                                                  .primaryColorLight
                                                  .withOpacity(0.70),
                                            ),
                                            horizontalSpaceSmall,
                                            Text(
                                              contributor.name,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .headline4,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          contributor.role,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline4
                                              .copyWith(
                                                color: Colors.orange[600],
                                              ),
                                        ),
                                      ],
                                    ),
                                    verticalSpaceTiny,
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            model.onUrlTap(contributor.github);
                                          },
                                          icon: Icon(
                                            FeatherIcons.github,
                                            color: Theme.of(context)
                                                .primaryColorLight
                                                .withOpacity(0.70),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            model.onUrlTap(contributor.twitter);
                                          },
                                          icon: Icon(FeatherIcons.twitter),
                                          color: Theme.of(context)
                                              .primaryColorLight
                                              .withOpacity(0.70),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      verticalSpaceMedium,
                      Divider(
                        color: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(0.50),
                      ),
                      InkWell(
                        onTap: () {
                          model.onUrlTap(model.aboutApp.githubLink);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, top: 8.0, bottom: 8.0),
                                child: Text(
                                  "'What next?' is an open source app, if you want to check out how it's made or want to change something for yourself, visit our github repository. If you find a bug, please open an issue.",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline5,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Icon(
                                FeatherIcons.github,
                                size: 30.0,
                                color: Theme.of(context)
                                    .primaryColorLight
                                    .withOpacity(0.70),
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSpaceSmall,
                      Divider(
                        color: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(0.50),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "'What next?' is powered by  ",
                            style: Theme.of(context).primaryTextTheme.headline4,
                          ),
                          InkWell(
                            onTap: model.onTmdbtap,
                            child: Image.network(
                              "https://firebasestorage.googleapis.com/v0/b/whatnext-e7c13.appspot.com/o/tmdb.png?alt=media&token=fa0d6ffa-143c-4bc3-bb5c-3a8a42fa742d",
                              height: 50.0,
                              width: 120.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "** This product uses the TMDb API but is not endorsed or certified by TMDb.",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            .copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                      verticalSpaceSmall,
                      Divider(
                        color: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(0.50),
                      ),
                      verticalSpaceSmall,
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
