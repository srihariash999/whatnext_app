import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:whatnext/models/review.dart';

var formatter = DateFormat.yMMMd('en_US');

class ReviewsViewArguments {
  final String type;
  final List<Review> reviews;
  final String title;

  ReviewsViewArguments(
      {@required this.type, @required this.reviews, @required this.title});
}

class ReviewsView extends StatelessWidget {
  final ReviewsViewArguments reviewViewArguments;

  const ReviewsView({@required this.reviewViewArguments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Reviews ",
            style: Theme.of(context).primaryTextTheme.headline4),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${reviewViewArguments.title}",
                style: Theme.of(context).primaryTextTheme.headline1,
              ),
            ),
            Expanded(
              child: reviewViewArguments.reviews.length > 0
                  ? ListView.builder(
                      itemCount: reviewViewArguments.reviews.length,
                      itemBuilder: (context, int index) {
                        Review _review = reviewViewArguments.reviews[index];
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Card(
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Theme.of(context).primaryColorLight,

                            // : Colors.grey[300],
                            child: InkWell(
                              onTap: () {
                                // reviewDialog(context, review);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 24.0,
                                              child: Icon(
                                                Icons.person,
                                                size: 24.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16.0,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${_review.author ?? ""}',
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .headline4
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .backgroundColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16.0,
                                                    ),
                                              ),
                                              Row(
                                                children: [
                                                  SmoothStarRating(
                                                      allowHalfRating: false,
                                                      onRated: (v) {},
                                                      starCount: 5,
                                                      rating: _review
                                                                  .authorDetails
                                                                  .rating !=
                                                              null
                                                          ? _review
                                                              .authorDetails
                                                              .rating
                                                              .toDouble()
                                                          : 0.0,
                                                      size: 16.0,
                                                      isReadOnly: true,
                                                      color: Colors.orange[400],
                                                      borderColor:
                                                          Colors.orange[400],
                                                      spacing: 0.0),
                                                  SizedBox(
                                                    width: 14.0,
                                                  ),
                                                  Text(
                                                    '${formatter.format(DateTime.parse(_review.createdAt))}',
                                                    style: Theme.of(context)
                                                        .primaryTextTheme
                                                        .headline4
                                                        .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .backgroundColor
                                                              .withOpacity(
                                                                  0.70),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                          top: 6.0,
                                          bottom: 6.0),
                                      child: Text(
                                        // "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                        "${_review.content}",
                                        maxLines: 30,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline4
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                              fontSize: 14.0,
                                              height: 1.4,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: Text(
                        "No reviews to show",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline3
                            .copyWith(
                              color: Theme.of(context).primaryColorLight,
                              height: 1.4,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
