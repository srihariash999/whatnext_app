import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/models/genre_card.dart';
import 'package:whatnext/models/movie_details.dart';
import 'package:whatnext/ui/shared/app_colors.dart';
import 'package:whatnext/ui/shared/shared_styles.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:whatnext/ui/widgets/expansion_list.dart';
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
        print(" &&&  ${_md.backdropPath.toString()}");
        return Scaffold(
          key: _scaffoldKey,
          body: model.busy
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: kIsWeb ? 550.0 : 350.0,
                          width: double.maxFinite,
                          decoration: BoxDecoration(),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            children: [
                              Container(
                                height: kIsWeb ? 550.0 : 350.0,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(100.0),
                                    bottomRight: Radius.circular(100.0),
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                    _md.backdropPath.toString() != "null"
                                        ? "https://image.tmdb.org/t/p/w780" +
                                            _md.backdropPath
                                        : "https://image.tmdb.org/t/p/w500" +
                                            _md.posterPath,
                                    fit:
                                        kIsWeb ? BoxFit.contain : BoxFit.cover),
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
                                child: Container(
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
                                                border: Border.all(width: 0.5)),
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
                                                            color:
                                                                Colors.black54,
                                                          )
                                                        ],
                                                      ),
                                                      verticalSpaceMedium,
                                                      TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                          .red[
                                                                      300]),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 24.0,
                                                                  right: 24.0,
                                                                  top: 8.0,
                                                                  bottom: 8.0),
                                                          child: Text(
                                                            "Remove from watchlist",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          model.onAddTap();
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
                                                            color:
                                                                Colors.black54,
                                                          )
                                                        ],
                                                      ),
                                                      verticalSpaceMedium,
                                                      Text(
                                                        "Add this movie to watchlist",
                                                        style:
                                                            sideHeadingTextStyle
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
                                                            style: namesTextStyle
                                                                .copyWith(
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
                                                              title:
                                                                  model.choice,
                                                              onItemSelected: model
                                                                  .changeChoice,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      verticalSpaceMedium,
                                                      TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                          .blue[
                                                                      300]),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 24.0,
                                                                  right: 24.0,
                                                                  top: 8.0,
                                                                  bottom: 8.0),
                                                          child: Text(
                                                            "Add to watchlist",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          model.onAddTap();
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
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _md.genres.length,
                                    itemBuilder: (context, index) => GenreCard(
                                      genre: _md.genres[index].name,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${formatter.format(DateTime.parse(_md.releaseDate))}',
                                      style: TextStyle(color: kTextLightColor),
                                    ),
                                    SizedBox(width: kDefaultPadding),
                                    _md.adult
                                        ? Text(
                                            "A +",
                                            style: TextStyle(
                                                color: kTextLightColor),
                                          )
                                        : Text(
                                            "PG-13",
                                            style: TextStyle(
                                                color: kTextLightColor),
                                          ),
                                    SizedBox(width: kDefaultPadding),
                                    Text(
                                      _md.runtime.toString() + " min",
                                      style: TextStyle(color: kTextLightColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalSpaceMedium,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'OverView',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline3
                                  .copyWith(fontWeight: FontWeight.w500),
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
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
