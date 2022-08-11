import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/providers/watchlist_provider.dart';

class WatchlistView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<WatchlistProvider>.withConsumer(
      viewModelBuilder: () => WatchlistProvider(),
      onModelReady: (model) => model.onInit(),
      builder: (context, model, child) => Scaffold(
        // key: locator<SnackbarService>().scaffoldKey,

        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Your Watchlist",
              style: Theme.of(context).primaryTextTheme.headline1),
          elevation: 0.0,
        ),
        body: Column(
          children: [
            verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    model.onMovieFilter("Want to watch");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    padding: EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        Text("Want to watch",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline5
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                )),
                        Text(" : ${model.wantToWatchCount}",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline5
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                )),
                      ],
                    ),
                  ),
                ),
                horizontalSpaceSmall,
                InkWell(
                  onTap: () {
                    model.onMovieFilter("Watching");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow[600],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    padding: EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        Text("Watching",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline5
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                )),
                        Text(" : ${model.watchingCount}",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline5
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                )),
                      ],
                    ),
                  ),
                ),
                horizontalSpaceSmall,
                InkWell(
                  onTap: () {
                    model.onMovieFilter("Watched");
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      children: [
                        Text("Watched",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline5
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                )),
                        Text(" : ${model.watchedCount}",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline5
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            verticalSpaceMedium,
            Expanded(
              child: RefreshIndicator(
                onRefresh: model.onInit,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 0.70),
                  children: model.currentUserWatchlist.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
                      child: InkWell(
                        onTap: () {
                          model.onMovieSelect(item['id'], item['type']);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    color: model.getColor(
                                      item['status'].toString(),
                                    ),
                                    width: 5.0),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Image.network(
                              "https://image.tmdb.org/t/p/w500${item['poster']}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
