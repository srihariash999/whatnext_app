import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatnext/models/feed.dart';

var formatter = DateFormat.yMMMd('en_US');

class FeedCardWidget extends StatelessWidget {
  final Feed feed;

  const FeedCardWidget({Key key, @required this.feed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
        bottom: 12.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Container(
        height: 600.0,
        width: 500.0,
        color: Theme.of(context).primaryColorLight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "@${feed.userName}",
                    style:
                        Theme.of(context).primaryTextTheme.headline4.copyWith(
                              color: Theme.of(context).backgroundColor,
                            ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${formatter.format(DateTime.parse(feed.addedOn))}',
                    style:
                        Theme.of(context).primaryTextTheme.headline4.copyWith(
                              color: Theme.of(context).backgroundColor,
                            ),
                  ),
                ),
              ],
            ),
            Container(
              height: 250.0,
              child: Image.network(
                "https://image.tmdb.org/t/p/w500${feed.poster}",
                fit: BoxFit.fill,
              ),
            ),
            Text(
              "${feed.name}",
              style: Theme.of(context).primaryTextTheme.headline4.copyWith(
                    color: Theme.of(context).backgroundColor,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            Text(
              "(${feed.status})",
              style: Theme.of(context).primaryTextTheme.headline4.copyWith(
                    color: Theme.of(context).backgroundColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
