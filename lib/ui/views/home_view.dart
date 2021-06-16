import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tcard/tcard.dart';

import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/ui/widgets/feed_card.dart';
import 'package:whatnext/ui/widgets/feed_list_card.dart';
import 'package:whatnext/ui/widgets/movies_list_widget.dart';
import 'package:whatnext/ui/widgets/tv_shows_list_widget.dart';
import 'package:whatnext/viewmodels/feed_view_model.dart';
// import 'package:whatnext/ui/views/movie_details_view.dart';

import 'package:whatnext/viewmodels/home_view_model.dart';

import '../shared/ui_helpers.dart';

var formatter = DateFormat.yMMMd('en_US');

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.onInit(),
      builder: (context, model, child) {
        if (model.busy) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ViewModelProvider<FeedViewModel>.withConsumer(
            viewModelBuilder: () => FeedViewModel(),
            onModelReady: (model) => model.onInit(),
            builder: (context, model2, child) {
              if (model2.busy) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Scaffold(
                  // key: locator<SnackbarService>().scaffoldKey,
                  backgroundColor: Theme.of(context).backgroundColor,
                  bottomNavigationBar: BottomNavigationBar(
                    backgroundColor: Theme.of(context).backgroundColor,
                    onTap: (int i) {
                      model.switchPages(i);
                    },
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    currentIndex: model.bottomIndex,
                    unselectedItemColor: Colors.grey[200],
                    selectedItemColor: Colors.red[400],
                    items: [
                      BottomNavigationBarItem(
                        icon: Column(
                          children: [
                            Text(
                              'Explore 🧭',
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                            verticalSpaceTiny,
                            AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInCirc,
                              height: 2.5,
                              width: MediaQuery.of(context).size.width * 0.40,
                              color: model.bottomIndex == 0
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).backgroundColor,
                            ),
                          ],
                        ),
                        label: 'Explore',
                      ),
                      BottomNavigationBarItem(
                        icon: Column(
                          children: [
                            Text(
                              'Feed 🍴',
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                            verticalSpaceTiny,
                            AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInCirc,
                              height: 2.5,
                              width: MediaQuery.of(context).size.width * 0.40,
                              color: model.bottomIndex == 1
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).backgroundColor,
                            ),
                          ],
                        ),
                        label: 'Feed',
                      ),
                    ],
                  ),
                  body: model.bottomIndex == 0
                      ? ExplorePageWidget(
                          model: model,
                        )
                      : FeedPageWidget(
                          model: model2,
                        ),
                );
              }
            },
          );
        }
      },
    );
  }
}

class FeedPageWidget extends StatefulWidget {
  final FeedViewModel model;
  const FeedPageWidget({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  _FeedPageWidgetState createState() => _FeedPageWidgetState();
}

class _FeedPageWidgetState extends State<FeedPageWidget>
    with AutomaticKeepAliveClientMixin<FeedPageWidget> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
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
            icon: Icon(
              widget.model.viewType == 'card'
                  ? Icons.view_list_rounded
                  : Icons.clear_all_rounded,
              color: Theme.of(context).primaryColorLight,
            ),
            onPressed: () {
              widget.model.switchView();
            },
          )
        ],
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorLight,
        onPressed: () {
          widget.model.navigateToNewPost();
        },
        child: Icon(
          Icons.post_add_outlined,
          color: Theme.of(context).backgroundColor,
        ),
      ),
      drawer: DrawerWidget(),
      body: Container(
        child: widget.model.viewType == 'list'
            ? RefreshIndicator(
                color: Theme.of(context).primaryColorLight,
                backgroundColor: Theme.of(context).backgroundColor,
                onRefresh: widget.model.refresh,
                child: ListView(
                  children: widget.model.feedList.length > 0
                      ? widget.model.feedList
                          .map(
                            (feedItem) => InkWell(
                              onTap: () {
                                widget.model
                                    .onItemTap(feedItem.id, feedItem.type);
                              },
                              child: FeedListCardWidget(feed: feedItem),
                            ),
                          )
                          .toList()
                      : [
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.70,
                              alignment: Alignment.center,
                              child: Text(
                                "No feed to show",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline3
                                    .copyWith(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                          )
                        ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          widget.model.moveBack();
                        },
                        child: Icon(Icons.arrow_back_ios,
                            color: Theme.of(context).primaryColorLight),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.model.reset();
                        },
                        child: Icon(Icons.home,
                            color: Theme.of(context).primaryColorLight),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.model.refresh();
                        },
                        child: Icon(Icons.refresh,
                            color: Theme.of(context).primaryColorLight),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.model.moveForward();
                        },
                        child: Icon(Icons.arrow_forward_ios,
                            color: Theme.of(context).primaryColorLight),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  widget.model.feedList.length > 0
                      ? TCard(
                          cards: widget.model.feedList
                              .map(
                                (feedItem) => InkWell(
                                  onTap: () {
                                    widget.model
                                        .onItemTap(feedItem.id, feedItem.type);
                                  },
                                  child: FeedCardWidget(feed: feedItem),
                                ),
                              )
                              .toList(),
                          size: Size(360, 480),
                          controller: widget.model.controller,
                          // onForward: (index, info) {
                          //   print(index);
                          // },
                          // onBack: (index, info) {
                          //   print(index);
                          // },
                          onEnd: () {
                            widget.model.reachedEnd();
                          },
                        )
                      : Container(
                          height: 300.0,
                          width: 400.0,
                          color: Theme.of(context).primaryColorLight,
                          alignment: Alignment.center,
                          child: Text(
                            "No feed to show",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline3
                                .copyWith(
                                    color: Theme.of(context).backgroundColor,
                                    fontWeight: FontWeight.w400),
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}

class ExplorePageWidget extends StatelessWidget {
  final model;
  const ExplorePageWidget({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon:
                Icon(Icons.search, color: Theme.of(context).primaryColorLight),
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      model.tabType == 'movie'
                          ? Text(
                              'Movies',
                              style:
                                  Theme.of(context).primaryTextTheme.headline1,
                            )
                          : Text(
                              'Movies',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline1
                                  .copyWith(color: Colors.grey),
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
              ),
              InkWell(
                onTap: () {
                  model.switchTabs('tv');
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      model.tabType == 'tv'
                          ? Text(
                              'TV Shows',
                              style:
                                  Theme.of(context).primaryTextTheme.headline1,
                            )
                          : Text(
                              'TV Shows',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline1
                                  .copyWith(color: Colors.grey),
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
              ),
            ],
          ),
          verticalSpaceMedium,
          Expanded(
            child: AnimatedCrossFade(
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
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Popular Movies",
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                            InkWell(
                              onTap: () {
                                model.navigateToVerticalMovieView(
                                    "Popular Movies");
                              },
                              child: Text(
                                "See all",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline2
                                    .copyWith(
                                      fontSize: 14.0,
                                      color: Theme.of(context)
                                          .primaryColorLight
                                          .withOpacity(0.70),
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
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
                          height: 300.0,
                          width: 200.0,
                          showLoadMore: true,
                        ),
                      ),
                      verticalSpaceSmall,
                      Container(
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Top Rated Movies",
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                            InkWell(
                              onTap: () {
                                model.navigateToVerticalMovieView(
                                    "Top Rated Movies");
                              },
                              child: Text(
                                "See all",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline2
                                    .copyWith(
                                      fontSize: 14.0,
                                      color: Theme.of(context)
                                          .primaryColorLight
                                          .withOpacity(0.70),
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
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
                          height: 300.0,
                          width: 200.0,
                          showLoadMore: true,
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
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Popular Tv Shows",
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                            InkWell(
                              onTap: () {
                                model.navigateToVerticalTvShowView(
                                    "Popular Tv Shows");
                              },
                              child: Text(
                                "See all",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline2
                                    .copyWith(
                                      fontSize: 14.0,
                                      color: Theme.of(context)
                                          .primaryColorLight
                                          .withOpacity(0.70),
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
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
                          height: 300.0,
                          width: 200.0,
                          showLoadMore: true,
                        ),
                      ),
                      verticalSpaceSmall,
                      Container(
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Top Rated Tv Shows",
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                            InkWell(
                              onTap: () {
                                model.navigateToVerticalTvShowView(
                                    "Top Rated Tv Shows");
                              },
                              child: Text(
                                "See all",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline2
                                    .copyWith(
                                      fontSize: 14.0,
                                      color: Theme.of(context)
                                          .primaryColorLight
                                          .withOpacity(0.70),
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSpaceSmall,
                      Container(
                        height: 300,
                        child: TvShowListWidget(
                          tvShowsList: model.topRatedTvShowsList,
                          direction: Axis.horizontal,
                          onTvShowTap: model.onItemTap,
                          loadMore: model.loadMoreTopRatedTvShows,
                          height: 300.0,
                          width: 200.0,
                          showLoadMore: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
          return SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.80,
              child: Drawer(
                child: Container(
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            model.navigateToProfile();
                          },
                          child: Container(
                            color: Theme.of(context).primaryColor,
                            padding: EdgeInsets.all(12.0),
                            child: Row(
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
                                Container(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.arrow_right_rounded,
                                    color: Theme.of(context).primaryColorLight,
                                    size: 36.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      verticalSpaceMedium,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: model.navigateToFriends,
                          child: Row(
                            children: [
                              horizontalSpaceSmall,
                              Icon(Icons.people_alt_outlined,
                                  color: Theme.of(context).primaryColorLight),
                              horizontalSpaceMedium,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Find People",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline4
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "Search for other users and follow them.",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline5
                                        .copyWith(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: model.navigateToTheme,
                          child: Row(
                            children: [
                              horizontalSpaceSmall,
                              Icon(Icons.color_lens_sharp,
                                  color: Theme.of(context).primaryColorLight),
                              horizontalSpaceMedium,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Themes",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline4
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "Change the appearance of the app.",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline5
                                        .copyWith(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: model.navigateToWatchList,
                          child: Row(
                            children: [
                              horizontalSpaceSmall,
                              Icon(Icons.movie_creation_outlined,
                                  color: Theme.of(context).primaryColorLight),
                              horizontalSpaceMedium,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Watchlist",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline4
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "View and change your watchlist.",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline5
                                        .copyWith(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: model.navigateToAboutApp,
                          child: Row(
                            children: [
                              horizontalSpaceSmall,
                              Icon(Icons.info_outlined,
                                  color: Theme.of(context).primaryColorLight),
                              horizontalSpaceMedium,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "About Whatnext?",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline4
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "Deatils about app & authors",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline5
                                        .copyWith(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: model.logout,
                          child: Row(
                            children: [
                              horizontalSpaceSmall,
                              Icon(Icons.exit_to_app,
                                  color: Theme.of(context).primaryColorLight),
                              horizontalSpaceMedium,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Logout",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline4
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "Logout from this account.",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline5
                                        .copyWith(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
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
              : model.searchResults.length == 0
                  ? Container(
                      alignment: Alignment.center,
                      child: Text(
                        " Search for a movie / TV Show",
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: model.searchResults
                            .map((Map<String, dynamic> result) {
                          String date;
                          if (result['media_type'] == 'movie') {
                            if (result['item'].releaseDate.toString() !=
                                    "null" &&
                                result['item'].releaseDate.toString() != "") {
                              date = result['item'].releaseDate;
                            } else {
                              date = "${DateTime.now()}";
                            }
                          } else {
                            if (result['item'].firstAirDate.toString() !=
                                    "null" &&
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
                                      : result['item'].name,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline3
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text(
                                  '${formatter.format(DateTime.parse(date))}',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline5,
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
                                            color: Theme.of(context)
                                                .primaryColorLight,
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
