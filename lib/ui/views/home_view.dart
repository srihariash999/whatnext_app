import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/models/movie.dart';
import 'package:whatnext/models/tv_show.dart';

import 'package:whatnext/ui/shared/ui_helpers.dart';
// import 'package:whatnext/ui/views/movie_details_view.dart';

import 'package:whatnext/viewmodels/home_view_model.dart';

var formatter = DateFormat.yMMMd('en_US');

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).backgroundColor);
    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.onInit(),
      builder: (context, model, child) {
        if (model.busy) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            // key: locator<SnackbarService>().scaffoldKey,
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Container(
                height: 60.0,
                width: 140.0,
                padding: EdgeInsets.all(4.0),
                child: Image.asset('assets/whatnext_logo.png'),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search,
                      color: Theme.of(context).primaryColorLight),
                  onPressed: () => showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  ),
                )
              ],
              elevation: 0.0,
            ),

            drawer: DrawerWidget(),
            body: Column(
              children: [
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        model.switchTabs('movie');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Movies',
                            style: Theme.of(context).primaryTextTheme.headline1,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInCirc,
                            height: 4.0,
                            width: 35.0,
                            color: model.tabType == 'movie'
                                ? Theme.of(context).primaryColorLight
                                : Theme.of(context).backgroundColor,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        model.switchTabs('tv');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Tv Shows',
                            style: Theme.of(context).primaryTextTheme.headline1,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInCirc,
                            height: 4.0,
                            width: 35.0,
                            color: model.tabType == 'tv'
                                ? Theme.of(context).primaryColorLight
                                : Theme.of(context).backgroundColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                AnimatedCrossFade(
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                  crossFadeState: model.tabType == 'movie'
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstCurve: Curves.easeInCirc,
                  secondCurve: Curves.easeInCirc,
                  firstChild: RefreshIndicator(
                    onRefresh: model.onInit,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.76,
                      child: ListView(
                        children: [
                          verticalSpaceSmall,
                          Container(
                            padding: EdgeInsets.only(left: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Popular Movies",
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                          ),
                          verticalSpaceSmall,
                          Container(
                            height: 300,
                            width: 200.0,
                            child: MovieListWidget(
                              moviesList: model.popularMoviesList,
                              onMovieTap: model.onItemTap,
                              loadMore: model.loadMorePopularMovies,
                              direction: Axis.horizontal,
                            ),
                          ),
                          verticalSpaceSmall,
                          Container(
                            padding: EdgeInsets.only(left: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Top Rated Movies",
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                          ),
                          verticalSpaceSmall,
                          Container(
                            height: 300,
                            child: MovieListWidget(
                              moviesList: model.topRatedMoviesList,
                              direction: Axis.horizontal,
                              onMovieTap: model.onItemTap,
                              loadMore: model.loadMoreTopRatedMovies,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  secondChild: RefreshIndicator(
                    onRefresh: model.onInit,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.76,
                      child: ListView(
                        children: [
                          verticalSpaceSmall,
                          Container(
                            padding: EdgeInsets.only(left: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Popular Tv Shows",
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                          ),
                          verticalSpaceSmall,
                          Container(
                            height: 300,
                            width: 200.0,
                            child: TvShowListWidget(
                              tvShowsList: model.popularTvShowsList,
                              onTvShowTap: model.onItemTap,
                              loadMore: model.loadMorePopularTvShows,
                              direction: Axis.horizontal,
                            ),
                          ),
                          verticalSpaceSmall,
                          Container(
                            padding: EdgeInsets.only(left: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Top Rated Tv Shows",
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                          ),
                          verticalSpaceSmall,
                          Container(
                            height: 300,
                            child: TvShowListWidget(
                                tvShowsList: model.topRatedTvShowsList,
                                direction: Axis.horizontal,
                                onTvShowTap: model.onItemTap,
                                loadMore: model.loadMoreTopRatedTvShows),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
        viewModelBuilder: () => HomeViewModel(),
        onModelReady: (model) => model.getUserName(),
        builder: (context, model, child) {
          return Drawer(
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: [
                  DrawerHeader(
                    child: InkWell(
                      onTap: () {
                        model.navigateToProfile();
                      },
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person),
                              ),
                            ),
                            Container(
                              child: Text(
                                model.userName,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: model.navigateToTheme,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Find People",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline2,
                              ),
                              horizontalSpaceMedium,
                              Icon(Icons.people_alt_outlined,
                                  color: Theme.of(context).primaryColorLight),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: model.navigateToFriends,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Themes",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline2,
                              ),
                              horizontalSpaceMedium,
                              Icon(Icons.color_lens,
                                  color: Theme.of(context).primaryColorLight),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: model.navigateToWatchList,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "WatchList",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline2,
                              ),
                              horizontalSpaceMedium,
                              Icon(Icons.movie_creation_outlined,
                                  color: Theme.of(context).primaryColorLight),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: model.logout,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Logout",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline2,
                              ),
                              horizontalSpaceMedium,
                              Icon(Icons.exit_to_app,
                                  color: Theme.of(context).primaryColorLight),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

class MovieListWidget extends StatelessWidget {
  final List moviesList;
  final Function onMovieTap;
  final Function loadMore;
  final Axis direction;
  const MovieListWidget({
    @required this.moviesList,
    @required this.onMovieTap,
    @required this.loadMore,
    @required this.direction,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: direction,
      itemCount: moviesList.length + 1,
      itemBuilder: (context, ind) {
        if (ind < moviesList.length) {
          Movie popMovie = moviesList[ind];
          return InkWell(
            onTap: () {
              print(" tapped on ${moviesList[ind].id} ");
              onMovieTap(moviesList[ind].id, 'movie');
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
                        "https://image.tmdb.org/t/p/w500${popMovie.posterPath}",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      popMovie.title,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).primaryTextTheme.headline4,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            height: 260.0,
            width: 150.0,
            child: IconButton(
              icon: Row(
                children: [
                  Icon(Icons.arrow_right,
                      color: Theme.of(context).primaryColorLight),
                  Text(
                    "Load More",
                    style: Theme.of(context).primaryTextTheme.headline5,
                  )
                ],
              ),
              onPressed: () {
                loadMore();
              },
            ),
          );
        }
      },
    );
  }
}

class TvShowListWidget extends StatelessWidget {
  final List tvShowsList;
  final Function onTvShowTap;
  final Function loadMore;
  final Axis direction;
  const TvShowListWidget({
    @required this.tvShowsList,
    @required this.onTvShowTap,
    @required this.loadMore,
    @required this.direction,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: direction,
      itemCount: tvShowsList.length + 1,
      itemBuilder: (context, ind) {
        if (ind < tvShowsList.length) {
          TvShow popTvShow = tvShowsList[ind];
          return InkWell(
            onTap: () {
              print(" tapped on ${tvShowsList[ind].id} ");
              onTvShowTap(tvShowsList[ind].id, 'tv');
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
                        "https://image.tmdb.org/t/p/w500${popTvShow.posterPath}",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      popTvShow.originalName,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).primaryTextTheme.headline4,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            height: 260.0,
            width: 150.0,
            child: IconButton(
              icon: Row(
                children: [
                  Icon(Icons.arrow_right,
                      color: Theme.of(context).primaryColorLight),
                  Text(
                    "Load More",
                    style: Theme.of(context).primaryTextTheme.headline5,
                  )
                ],
              ),
              onPressed: () {
                loadMore();
              },
            ),
          );
        }
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) => [];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      );

  @override
  Widget buildResults(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
        viewModelBuilder: () => HomeViewModel(),
        builder: (context, model, child) {
          if (query.length > 1) {
            model.fetchSearchReults(query);
          }
          print(" query: $query");
          return model.searchResultLoading
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children:
                        model.searchResults.map((Map<String, dynamic> result) {
                      String date;
                      if (result['media_type'] == 'movie') {
                        if (result['item'].releaseDate.toString() != "null" &&
                            result['item'].releaseDate.toString() != "") {
                          date = result['item'].releaseDate;
                        } else {
                          date = "${DateTime.now()}";
                        }
                      } else {
                        if (result['item'].firstAirDate.toString() != "null" &&
                            result['item'].firstAirDate.toString() != "") {
                          date = result['item'].firstAirDate;
                        } else {
                          date = "${DateTime.now()}";
                        }
                      }

                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, bottom: 12.0, left: 12.0),
                          child: ListTile(
                            onTap: () {
                              model.onItemTap(
                                result['item'].id,
                                result['media_type'],
                              );
                            },
                            title: Text(
                              result['media_type'] == 'movie'
                                  ? result['item'].title
                                  : result['item'].originalName,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline3
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                            subtitle: Text(
                              '${formatter.format(DateTime.parse(date))}',
                              style:
                                  Theme.of(context).primaryTextTheme.headline5,
                            ),
                            trailing: Container(
                              height: 180.0,
                              width: 150.0,
                              child: result['item'].posterPath != null
                                  ? Image.network(
                                      "https://image.tmdb.org/t/p/w500${result['item'].posterPath}",
                                      fit: BoxFit.contain,
                                    )
                                  : Container(
                                      child: Icon(
                                        Icons.not_interested,
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        size: 22.0,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
