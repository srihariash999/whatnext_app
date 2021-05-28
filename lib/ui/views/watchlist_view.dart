import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/viewmodels/watchlist_view_model.dart';

class WatchlistView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<WatchlistViewModel>.withConsumer(
      viewModelBuilder: () => WatchlistViewModel(),
      onModelReady: (model) => model.onInit(),
      builder: (context, model, child) => Scaffold(
        // key: locator<SnackbarService>().scaffoldKey,

        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0),
              child: Text("Your Watchlist",
                  style: Theme.of(context).primaryTextTheme.headline1),
            )
          ],
          elevation: 0.0,
        ),
        body: Column(
          children: [
            verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text("Want to watch",
                        style: Theme.of(context).primaryTextTheme.headline5),
                    horizontalSpaceSmall,
                    Container(
                      height: 16.0,
                      width: 16.0,
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text("Watching",
                        style: Theme.of(context).primaryTextTheme.headline5),
                    horizontalSpaceSmall,
                    Container(
                      height: 16.0,
                      width: 16.0,
                      decoration: BoxDecoration(
                        color: Colors.yellow[600],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text("Watched",
                        style: Theme.of(context).primaryTextTheme.headline5),
                    horizontalSpaceSmall,
                    Container(
                      height: 16.0,
                      width: 16.0,
                      decoration: BoxDecoration(
                        color: Colors.green[600],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    )
                  ],
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        _reviewsFilterDailogue(context: context, model: model);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 8.0,
                          left: 8.0,
                          right: 12.0,
                        ),
                        child: Icon(
                          Icons.sort,
                          size: 24,
                        ),
                      ),
                    )),
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

  _reviewsFilterDailogue({
    BuildContext context,
    WatchlistViewModel model,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort movies by',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.70),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        model.onMovieFilter("Want to watch");
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("Want to watch",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline5),
                            horizontalSpaceSmall,
                            Container(
                              height: 16.0,
                              width: 16.0,
                              decoration: BoxDecoration(
                                color: Colors.red[600],
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        model.onMovieFilter("Watching");
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("Watching",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline5),
                            horizontalSpaceSmall,
                            Container(
                              height: 16.0,
                              width: 16.0,
                              decoration: BoxDecoration(
                                color: Colors.yellow[600],
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        model.onMovieFilter("Watched");
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("Watched",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline5),
                            horizontalSpaceSmall,
                            Container(
                              height: 16.0,
                              width: 16.0,
                              decoration: BoxDecoration(
                                color: Colors.green[600],
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
