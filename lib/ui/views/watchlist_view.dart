import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:whatnext/ui/shared/shared_styles.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/viewmodels/watchlist_view_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
                      color: Colors.yellow[200],
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
                      color: Colors.orange[200],
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
                      color: Colors.green[200],
                    )
                  ],
                ),
              ],
            ),
            verticalSpaceMedium,
            kIsWeb
                ? Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5),
                      itemCount: model.currentUserWatchlist.length,
                      itemBuilder: (context, ind) {
                        var popMovie = model.currentUserWatchlist[ind];
                        return InkWell(
                          onTap: () {
                            print(
                                " tapped on ${model.currentUserWatchlist[ind].id} ");
                            model.onMovieSelect(
                                model.currentUserWatchlist[ind].id);
                          },
                          child: Container(
                            height: 300.0,
                            width: 200.0,
                            padding: EdgeInsets.only(left: 12.5, right: 12.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 260.0,
                                    width: 200.0,
                                    child: Image.network(
                                      "https://image.tmdb.org/t/p/w500${model.currentUserWatchlist[ind]['poster']}",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    popMovie.title,
                                    textAlign: TextAlign.justify,
                                    style: namesTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: model.onInit,
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 0.70),
                        children: model.currentUserWatchlist.map((movie) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 4.0, right: 4.0, top: 4.0, bottom: 4.0),
                            child: InkWell(
                              onTap: () {
                                model.onMovieSelect(movie['movieId']);
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 6.0,
                                    bottom: 6.0,
                                    left: 6.0,
                                    right: 6.0),
                                decoration: BoxDecoration(
                                    color: model.getColor(
                                      movie['status'].toString(),
                                    ),
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  alignment: Alignment.center,
                                  child: Image.network(
                                    "https://image.tmdb.org/t/p/w500${movie['poster']}",
                                    fit: BoxFit.contain,
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
