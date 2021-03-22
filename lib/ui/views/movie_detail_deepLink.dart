import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/models/movie_credit.dart';
import 'package:whatnext/models/movie_details.dart';
import 'package:whatnext/ui/shared/shared_styles.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/ui/widgets/expansion_list.dart';
import 'package:whatnext/viewmodels/movie_details_view_model.dart';

var formatter = DateFormat.yMMMd('en_US');

class MovieDetailsDeepLink extends StatelessWidget {
  final int id;
  MovieDetailsDeepLink({@required this.id});
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
          backgroundColor: Color(0xFF1B1929),
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
                                    : Container(
                                        height: 36.0,
                                        width: 36.0,
                                        padding: EdgeInsets.only(right: 4.0),
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
                                                              MainAxisSize.min,
                                                          children: [
                                                            verticalSpaceSmall,
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  height: 5.0,
                                                                  width: 16.0,
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
                                                                        Colors.red[
                                                                            300]),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 24.0,
                                                                    right: 24.0,
                                                                    top: 8.0,
                                                                    bottom:
                                                                        8.0),
                                                                child: Text(
                                                                  "Remove from watchlist",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                model
                                                                    .onAddTap();
                                                              },
                                                            ),
                                                            verticalSpaceMedium,
                                                          ],
                                                        )
                                                      : Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            verticalSpaceSmall,
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  height: 5.0,
                                                                  width: 16.0,
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
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                                Container(
                                                                  width: 150.0,
                                                                  child:
                                                                      ExpansionList<
                                                                          String>(
                                                                    items: [
                                                                      "Watching",
                                                                      "Watched",
                                                                      "Want to watch"
                                                                    ],
                                                                    title: model
                                                                        .choice,
                                                                    onItemSelected:
                                                                        model
                                                                            .changeChoice,
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
                                                                        Colors.blue[
                                                                            300]),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 24.0,
                                                                    right: 24.0,
                                                                    top: 8.0,
                                                                    bottom:
                                                                        8.0),
                                                                child: Text(
                                                                  "Add to watchlist",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              onPressed: () {
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
                                style: TextStyle(
                                  color: Color(0xFFf2e9e4),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24.0,
                                ),
                              ),
                              verticalSpaceTiny,
                              Container(
                                height: 20.0,
                                child: Text(
                                  _md.tagline,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFFf2e9e4),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16.0,
                                  ),
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
                                              (genre) => Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                    left: kDefaultPadding),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: kDefaultPadding,
                                                  vertical: kDefaultPadding /
                                                      4, // 5 padding top and bottom
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.blueGrey),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  genre.name,
                                                  style: TextStyle(
                                                    color: Color(0xFFf2e9e4),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
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
                                      style: TextStyle(
                                        color: Color(0xFFf2e9e4),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    SizedBox(width: kDefaultPadding),
                                    _md.adult
                                        ? Text(
                                            "A +",
                                            style: TextStyle(
                                              color: Color(0xFFf2e9e4),
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14.0,
                                            ),
                                          )
                                        : Text(
                                            "PG-13",
                                            style: TextStyle(
                                              color: Color(0xFFf2e9e4),
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                    SizedBox(width: kDefaultPadding),
                                    Text(
                                      _md.runtime.toString() + " min",
                                      style: TextStyle(
                                        color: Color(0xFFf2e9e4),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14.0,
                                      ),
                                    ),
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
                                          color: Color(0xFFf2e9e4), width: 0.5),
                                    ),
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color(0xFF1B1929)),
                                      ),
                                      onPressed: () {
                                        model.navigateToVideoPlayer();
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Watch Trailer',
                                            style: TextStyle(
                                              color: Color(0xFFf2e9e4),
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16.0,
                                            ).copyWith(
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          horizontalSpaceMedium,
                                          Icon(
                                            Icons.forward_outlined,
                                            color: Color(0xFFf2e9e4),
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
                                style: TextStyle(
                                  color: Color(0xFFf2e9e4),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18.0,
                                ).copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _md.overview,
                                style: TextStyle(
                                  color: Color(0xFFf2e9e4),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16.0,
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
                                'Images',
                                style: TextStyle(
                                  color: Color(0xFFf2e9e4),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18.0,
                                ).copyWith(fontWeight: FontWeight.w500),
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
                                style: TextStyle(
                                  color: Color(0xFFf2e9e4),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18.0,
                                ).copyWith(fontWeight: FontWeight.w500),
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
            style: TextStyle(
              color: Color(0xFFf2e9e4),
              fontWeight: FontWeight.w300,
              fontSize: 14.0,
            ),
          ),
          Text(
            "as",
            style: TextStyle(
              color: Color(0xFFf2e9e4),
              fontWeight: FontWeight.w300,
              fontSize: 14.0,
            ),
          ),
          Text(
            credit.character,
            style: TextStyle(
              color: Color(0xFFf2e9e4),
              fontWeight: FontWeight.w300,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
