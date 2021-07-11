import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatnext/models/feed.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';

var formatter = DateFormat.yMMMd('en_US');

class FeedListCardWidget extends StatelessWidget {
  // Feed object to use the data from.
  final Feed feed;

  const FeedListCardWidget({Key key, @required this.feed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 12.0, right: 12.0, top: 4.0, bottom: 4.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.80),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Theme.of(context).primaryColorLight.withOpacity(0.50),
              width: 0.50,
            ),
            boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey[300])]),
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  FutureBuilder(
                      future: FirestoreService()
                          .getUserProfilePicture(feed.userName),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          String pic = snap.data;
                          if (pic != null) {
                            return Container(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).primaryColorLight,
                                radius: 24.0,
                                backgroundImage: NetworkImage(pic),
                              ),
                            );
                          } else {
                            return Container(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).primaryColorLight,
                                radius: 24.0,
                                child: Icon(
                                  Icons.person,
                                  size: 24.0,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                            );
                          }
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).primaryColorLight,
                              radius: 24.0,
                              child: Icon(
                                Icons.person,
                                size: 24.0,
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                          );
                        }
                      }),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '@${feed.userName ?? ""}',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline4
                            .copyWith(
                              color: Colors.black.withOpacity(0.70),
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                            ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        '${feed.addedOn != null ? formatter.format(DateTime.parse(feed.addedOn)) : ''}',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline4
                            .copyWith(
                              color: Colors.black.withOpacity(0.45),
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black.withOpacity(0.30),
            ),
            feed.id != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 250.0,
                        width: 140.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w500${feed.poster}",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        "${feed.name}",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline3
                            .copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(0.70),
                            ),
                      ),
                      Divider(
                        color: Colors.black.withOpacity(0.30),
                      )
                    ],
                  )
                : Container(),
            verticalSpaceSmall,
            Container(
              padding: EdgeInsets.only(left: 12.0),
              alignment: Alignment.centerLeft,
              child: Text(
                "${feed.postBody ?? ''}",
                style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                      color: Colors.black.withOpacity(0.70),
                    ),
              ),
            ),
            verticalSpaceSmall,
          ],
        ),
      ),
    );
  }
}
