import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/models/movie_credit.dart';
import 'package:whatnext/ui/widgets/genre_card.dart';
import 'package:whatnext/models/movie_details.dart';
import 'package:whatnext/ui/shared/shared_styles.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/ui/widgets/expansion_list.dart';
import 'package:whatnext/ui/widgets/movies_list_widget.dart';
import 'package:whatnext/viewmodels/movie_details_view_model.dart';

var formatter = DateFormat.yMMMd('en_US');

class MovieDetailsView extends StatelessWidget {
  final int id;
  MovieDetailsView({@required this.id});
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MovieDetailsViewModel>.withConsumer(
      viewModelBuilder: () => MovieDetailsViewModel(),
      onModelReady: (model) => model.onInit(id),
      builder: (context, model, child) {
        MovieDetails _md = model.movieDetails;
        // print(" &&&  ${_md.backdropPath.toString()}");
        return Scaffold(
          key: _scaffoldKey,
          body: model.busy
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 350.0,
                          width: double.maxFinite,
                          decoration: BoxDecoration(),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            children: [
                              Container(
                                height: 350.0,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(25.0),
                                    bottomRight: Radius.circular(25.0),
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                    _md.backdropPath.toString() != "null"
                                        ? "https://image.tmdb.org/t/p/w780" +
                                            _md.backdropPath
                                        : "https://image.tmdb.org/t/p/w500" +
                                            _md.posterPath,
                                    fit: BoxFit.cover),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(top: 16.0, left: 8.0),
                                child: Container(
                                  height: 36.0,
                                  width: 36.0,
                                  padding: EdgeInsets.only(left: 4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back_ios,
                                          size: 20.0, color: Colors.black),
                                      onPressed: () {
                                        model.onBackTap();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                padding: EdgeInsets.only(top: 16.0, right: 8.0),
                                child: model.isBeingAdded
                                    ? Container(
                                        height: 40.0,
                                        width: 70.0,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(14.0)),
                                        child: Lottie.asset(
                                          'assets/load_black.json',
                                          width: 60,
                                          height: 30,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 36.0,
                                            width: 42.0,
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: IconButton(
                                                onPressed: () {
                                                  model.onShareTap();
                                                },
                                                icon: Icon(Icons.share),
                                              ),
                                            ),
                                          ),
                                          horizontalSpaceMedium,
                                          Container(
                                            height: 36.0,
                                            width: 36.0,
                                            padding:
                                                EdgeInsets.only(right: 4.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: IconButton(
                                                icon: Icon(
                                                    model.isMovieAdded
                                                        ? Icons.check
                                                        : Icons.add,
                                                    size: 20.0,
                                                    color: Colors.black),
                                                onPressed: () {
                                                  _scaffoldKey.currentState
                                                      .showBottomSheet(
                                                    (context) => Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.5)),
                                                      child: model.isMovieAdded
                                                          ? Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                verticalSpaceSmall,
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          5.0,
                                                                      width:
                                                                          16.0,
                                                                      color: Colors
                                                                          .black54,
                                                                    )
                                                                  ],
                                                                ),
                                                                verticalSpaceMedium,
                                                                TextButton(
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            Colors.red[300]),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            24.0,
                                                                        right:
                                                                            24.0,
                                                                        top:
                                                                            8.0,
                                                                        bottom:
                                                                            8.0),
                                                                    child: Text(
                                                                      "Remove from watchlist",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    model
                                                                        .onAddTap();
                                                                  },
                                                                ),
                                                                verticalSpaceMedium,
                                                              ],
                                                            )
                                                          : Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                verticalSpaceSmall,
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          5.0,
                                                                      width:
                                                                          16.0,
                                                                      color: Colors
                                                                          .black54,
                                                                    )
                                                                  ],
                                                                ),
                                                                verticalSpaceMedium,
                                                                Text(
                                                                  "Add this movie to watchlist",
                                                                  style: sideHeadingTextStyle
                                                                      .copyWith(
                                                                          fontSize:
                                                                              20.0),
                                                                ),
                                                                verticalSpaceMedium,
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Text(
                                                                      "Select a status ",
                                                                      style: namesTextStyle.copyWith(
                                                                          fontSize:
                                                                              18.0,
                                                                          fontWeight:
                                                                              FontWeight.w300),
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          150.0,
                                                                      child: ExpansionList<
                                                                          String>(
                                                                        items: [
                                                                          "Watching",
                                                                          "Watched",
                                                                          "Want to watch"
                                                                        ],
                                                                        title: model
                                                                            .choice,
                                                                        onItemSelected:
                                                                            model.changeChoice,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                verticalSpaceMedium,
                                                                TextButton(
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            Colors.blue[300]),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            24.0,
                                                                        right:
                                                                            24.0,
                                                                        top:
                                                                            8.0,
                                                                        bottom:
                                                                            8.0),
                                                                    child: Text(
                                                                      "Add to watchlist",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    model
                                                                        .onAddTap();
                                                                  },
                                                                ),
                                                                verticalSpaceMedium,
                                                              ],
                                                            ),
                                                    ),
                                                  );
                                                  // model.onAddTap(context);
                                                },
                                              ),
                                            ),
                                          ),
                                          horizontalSpaceSmall,
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                        verticalSpaceMedium,
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                _md.title,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline1,
                              ),
                              verticalSpaceTiny,
                              Container(
                                height: 20.0,
                                child: Text(
                                  _md.tagline,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline4,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: kDefaultPadding / 2),
                                child: SizedBox(
                                    height: 36,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: _md.genres
                                            .map(
                                              (genre) => GenreCard(
                                                genre: genre.name,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    )),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${formatter.format(DateTime.parse(_md.releaseDate))}',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline5,
                                    ),
                                    SizedBox(width: kDefaultPadding),
                                    _md.adult
                                        ? Text(
                                            "A +",
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .headline5,
                                          )
                                        : Text(
                                            "PG-13",
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .headline5,
                                          ),
                                    SizedBox(width: kDefaultPadding),
                                    Text(_md.runtime.toString() + " min",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline5),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        model.video != null ? verticalSpaceMedium : Container(),
                        model.video != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          width: 0.5),
                                    ),
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .backgroundColor),
                                      ),
                                      onPressed: () {
                                        model.navigateToVideoPlayer();
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Watch Trailer',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .headline4
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                          horizontalSpaceMedium,
                                          Icon(
                                            Icons.forward_outlined,
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        verticalSpaceMedium,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'OverView',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline3
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _md.overview,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline4,
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceMedium,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Images',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline3
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: model.pictures
                                      .map(
                                        (pic) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Container(
                                            height: 240.0,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.0)),
                                            child: Image.network(
                                                "https://image.tmdb.org/t/p/w780/${pic.filePath}",
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceMedium,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Cast and Credits',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline3
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              height: 160.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: model.creditList
                                      .map(
                                        (credit) => MovieCreditWidget(
                                          credit: credit,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceMedium,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Recommended Movies',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline3
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              height: 180.0,
                              child: model.recommendedMovies.length > 0
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MovieListWidget(
                                        height: 180.0,
                                        width: 140.0,
                                        moviesList: model.recommendedMovies,
                                        loadMore: () {},
                                        direction: Axis.horizontal,
                                        onMovieTap: model.onMovieTap,
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'No recommended movies found',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline4
                                            .copyWith(
                                                fontWeight: FontWeight.w300),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        verticalSpaceMedium,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Similar Movies',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline3
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              height: 180.0,
                              child: model.similarMovies.length > 0
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MovieListWidget(
                                        height: 180.0,
                                        width: 140.0,
                                        moviesList: model.similarMovies,
                                        loadMore: () {},
                                        direction: Axis.horizontal,
                                        onMovieTap: model.onMovieTap,
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'No similar movies found',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline4
                                            .copyWith(
                                                fontWeight: FontWeight.w300),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        verticalSpaceMedium,
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class MovieCreditWidget extends StatelessWidget {
  final MovieCredit credit;
  const MovieCreditWidget({Key key, @required this.credit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125.0,
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              "https://image.tmdb.org/t/p/w185/${credit.profilePath}",
              fit: BoxFit.cover,
            ),
          ),
          Text(
            credit.name,
            style: Theme.of(context).primaryTextTheme.headline5,
          ),
          Text(
            "as",
            style: Theme.of(context).primaryTextTheme.headline5,
          ),
          Text(
            credit.character,
            style: Theme.of(context).primaryTextTheme.headline5,
          ),
        ],
      ),
    );
  }
}
