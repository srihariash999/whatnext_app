import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatnext/models/feed.dart';

var formatter = DateFormat.yMMMd('en_US');

class FeedListCardWidget extends StatelessWidget {
  // Feed object to use the data from. 
  final Feed feed;

  const FeedListCardWidget({Key key, @required this.feed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "@${feed.userName}",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline4
                            .copyWith(
                              color: Theme.of(context).backgroundColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                            ),
                      ),
                      Text(
                        " updated their watchlist ",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline4
                            .copyWith(
                              color: Theme.of(context).backgroundColor,
                              fontWeight: FontWeight.w300,
                              fontSize: 12.0,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      '${formatter.format(DateTime.parse(feed.addedOn))}',
                      style:
                          Theme.of(context).primaryTextTheme.headline4.copyWith(
                                color: Theme.of(context).backgroundColor,
                                fontSize: 12.0,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 160.0,
                    child: Image.network(
                      "https://image.tmdb.org/t/p/w500${feed.poster}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${feed.name}",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline4
                            .copyWith(
                              color: Theme.of(context).backgroundColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                            ),
                      ),
                      Text(
                        "(${feed.status})",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline4
                            .copyWith(
                              color: Theme.of(context).backgroundColor,
                              fontSize: 12.0,
                            ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
