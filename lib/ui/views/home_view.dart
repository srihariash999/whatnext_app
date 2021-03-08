import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/models/movie.dart';
import 'package:whatnext/ui/shared/shared_styles.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
          if (kIsWeb) {
            return Container(
              child: Scaffold(
                body: Column(
                  children: [
                    verticalSpaceMedium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            model.navigateToWatchList();
                          },
                          child: Container(
                            child: Text(
                              'Watchlist',
                              style: namesTextStyle.copyWith(
                                  fontSize: 20.0, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        horizontalSpaceMedium,
                        InkWell(
                          onTap: () {
                            model.navigateToFriends();
                          },
                          child: Container(
                            child: Text(
                              'Friends',
                              style: namesTextStyle.copyWith(
                                  fontSize: 20.0, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        horizontalSpaceMedium,
                        InkWell(
                          onTap: () {
                            model.navigateToProfile();
                          },
                          child: Container(
                            child: Text(
                              'Profile',
                              style: namesTextStyle.copyWith(
                                  fontSize: 20.0, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        horizontalSpaceMedium,
                        InkWell(
                          onTap: model.logout,
                          child: Container(
                            child: Text(
                              'Logout',
                              style: namesTextStyle.copyWith(
                                  fontSize: 20.0, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        horizontalSpaceMedium,
                      ],
                    ),
                    verticalSpaceMedium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            model.changeTab(0);
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Popular Movies',
                                style: namesTextStyle.copyWith(
                                    decoration: model.currentTab == 0
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                    decorationThickness:
                                        model.currentTab == 0 ? 2.0 : 0.0,
                                    decorationColor: model.currentTab == 0
                                        ? Colors.red[400]
                                        : Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        horizontalSpaceMedium,
                        InkWell(
                          onTap: () {
                            model.changeTab(1);
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Top Rated Movies',
                                style: namesTextStyle.copyWith(
                                    decoration: model.currentTab == 1
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                    decorationThickness:
                                        model.currentTab == 1 ? 2.0 : 0.0,
                                    decorationColor: model.currentTab == 1
                                        ? Colors.red[400]
                                        : Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          verticalSpaceSmall,
                          Builder(
                            builder: (context) => MaterialButton(
                              child: Container(
                                color: Colors.grey[200],
                                padding:
                                    EdgeInsets.only(top: 12.0, bottom: 12.0),
                                width: 300.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text('Search'),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: Icon(Icons.search),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () => showSearch(
                                context: context,
                                delegate: CustomSearchDelegate(),
                              ),
                            ),
                          ),
                          verticalSpaceSmall,
                          Expanded(
                            child: Container(
                              child: model.currentTab == 0
                                  ? MovieGridWidget(
                                      moviesList: model.popularMoviesList,
                                      onMovieTap: model.onMovieTap,
                                      loadMore: model.loadMorePopularMovies,
                                    )
                                  : Container(
                                      child: MovieGridWidget(
                                        moviesList: model.topRatedMoviesList,
                                        onMovieTap: model.onMovieTap,
                                        loadMore: model.loadMoreTopRatedMovies,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              // key: locator<SnackbarService>().scaffoldKey,
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                actions: [
                  Container(
                    padding: EdgeInsets.all(4.0),
                    child: Image.asset('assets/whatnext_logo.png'),
                  )
                ],
                elevation: 0.0,
              ),

              drawer: DrawerWidget(),
              body: ListView(
                children: [
                  verticalSpaceSmall,
                  Builder(
                    builder: (context) => MaterialButton(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                        width: 300.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text('Search'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(Icons.search),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () => showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  Container(
                    padding: EdgeInsets.only(left: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Popular Movies",
                      style: Theme.of(context).primaryTextTheme.headline2,
                    ),
                  ),
                  verticalSpaceSmall,
                  Container(
                    height: 300,
                    width: 200.0,
                    child: MovieListWidget(
                      moviesList: model.popularMoviesList,
                      onMovieTap: model.onMovieTap,
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
                      style: Theme.of(context).primaryTextTheme.headline2,
                    ),
                  ),
                  verticalSpaceSmall,
                  Container(
                    height: 300,
                    child: MovieListWidget(
                      moviesList: model.topRatedMoviesList,
                      direction: Axis.horizontal,
                      onMovieTap: model.onMovieTap,
                      loadMore: model.loadMoreTopRatedMovies,
                    ),
                  ),
                ],
              ),
            );
          }
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
                          onTap: model.navigateToFriends,
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
              onMovieTap(moviesList[ind].id);
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

class MovieGridWidget extends StatelessWidget {
  final List moviesList;
  final Function onMovieTap;
  final Function loadMore;

  const MovieGridWidget({
    @required this.moviesList,
    @required this.onMovieTap,
    @required this.loadMore,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      itemCount: moviesList.length + 1,
      itemBuilder: (context, ind) {
        if (ind < moviesList.length) {
          Movie popMovie = moviesList[ind];
          return InkWell(
            onTap: () {
              print(" tapped on ${moviesList[ind].id} ");
              onMovieTap(moviesList[ind].id);
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
                      style: namesTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            child: IconButton(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.arrow_right), Text("Load More")],
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
                    children: model.searchResults
                        .map(
                          (Movie result) => Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0, left: 12.0),
                              child: ListTile(
                                onTap: () {
                                  model.onMovieTap(result.id);
                                },
                                title: Text(
                                  result.title,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline3
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text(
                                  '${formatter.format(DateTime.parse(result.releaseDate))}',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline5,
                                ),
                                trailing: Container(
                                  height: 180.0,
                                  width: 150.0,
                                  child: result.posterPath != null
                                      ? Image.network(
                                          "https://image.tmdb.org/t/p/w500${result.posterPath}",
                                          fit: BoxFit.contain,
                                        )
                                      : Container(
                                          child: Icon(
                                            Icons.not_interested,
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            size: 22.0,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
