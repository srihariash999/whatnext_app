import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/models/tv_credit.dart';
import 'package:whatnext/models/tv_show_details.dart';
import 'package:whatnext/ui/shared/shared_styles.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';

import 'package:whatnext/ui/widgets/expansion_list.dart';
import 'package:whatnext/ui/widgets/genre_card.dart';
import 'package:whatnext/ui/widgets/tv_shows_list_widget.dart';
import 'package:whatnext/viewmodels/tv_show_details_view_model.dart';

var formatter = DateFormat.yMMMd('en_US');

class TvShowDetailsView extends StatelessWidget {
  final int id;
  TvShowDetailsView({@required this.id});
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<TvShowDetailsViewModel>.withConsumer(
      viewModelBuilder: () => TvShowDetailsViewModel(),
      onModelReady: (model) => model.onInit(id),
      builder: (context, model, child) {
        TvShowDetails _tvd = model.movieDetails;

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
                                    _tvd.backdropPath.toString() != "null"
                                        ? "https://image.tmdb.org/t/p/w780" +
                                            _tvd.backdropPath
                                        : "https://image.tmdb.org/t/p/w500" +
                                            _tvd.posterPath,
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
                                                                  "Add this tv show to watchlist",
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
                                _tvd.name,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline1,
                              ),
                              Container(
                                height: 20.0,
                                child: Text(
                                  _tvd.tagline,
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
                                      children: _tvd.genres
                                          .map(
                                            (genre) => GenreCard(
                                              genre: genre.name,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${formatter.format(DateTime.parse(_tvd.firstAirDate))}',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline5,
                                    ),
                                    SizedBox(width: kDefaultPadding),
                                    Text(
                                        _tvd.numberOfSeasons > 1
                                            ? _tvd.numberOfSeasons.toString() +
                                                " Seasons"
                                            : _tvd.numberOfSeasons.toString() +
                                                " Season",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline5),
                                    SizedBox(width: kDefaultPadding),
                                    Text(
                                        _tvd.numberOfEpisodes > 1
                                            ? _tvd.numberOfEpisodes.toString() +
                                                " Episodes"
                                            : _tvd.numberOfSeasons.toString() +
                                                " Episode",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline5),
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
                                _tvd.overview,
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
                            model.pictures.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: model.pictures
                                            .map(
                                              (pic) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'No pictures to show',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline4
                                          .copyWith(
                                              fontWeight: FontWeight.w300),
                                    ),
                                  ),
                          ],
                        ),
                        verticalSpaceMedium,
                        // Container(
                        //   height: 30.0,
                        //   child: Row(
                        //     children: [
                        //       Text(
                        //         "Languages",
                        //         style: Theme.of(context)
                        //             .primaryTextTheme
                        //             .headline3
                        //             .copyWith(fontWeight: FontWeight.w500),
                        //       ),
                        //       horizontalSpaceMedium,
                        //       Expanded(
                        //         child: ListView.builder(
                        //           scrollDirection: Axis.horizontal,
                        //           itemCount: _tvd.languages.length,
                        //           itemBuilder: (context, index) =>
                        //               GenreCard(
                        //             genre: _tvd.languages[index],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // verticalSpaceMedium,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cast and Credits',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline3
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            Container(
                              height: 160.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: model.creditList
                                      .map(
                                        (credit) => TvShowCreditWidget(
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
                            Text(
                              'Recommended TV Shows',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline3
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            Container(
                              height: 180.0,
                              child: model.recommendedTvShows.length > 0
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TvShowListWidget(
                                        height: 180.0,
                                        width: 140.0,
                                        tvShowsList: model.recommendedTvShows,
                                        loadMore: () {},
                                        direction: Axis.horizontal,
                                        onTvShowTap: model.onTvShowTap,
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'No recommended TV Shows found',
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
                            Text(
                              'Similar TV Shows',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline3
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            Container(
                              height: 180.0,
                              child: model.similarTvShows.length > 0
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TvShowListWidget(
                                        height: 180.0,
                                        width: 140.0,
                                        tvShowsList: model.similarTvShows,
                                        loadMore: () {},
                                        direction: Axis.horizontal,
                                        onTvShowTap: model.onTvShowTap,
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'No similar TV Shows found',
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

class TvShowCreditWidget extends StatelessWidget {
  final TvCredit credit;
  const TvShowCreditWidget({Key key, @required this.credit}) : super(key: key);

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
