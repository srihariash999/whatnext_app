import 'package:flutter/material.dart';
import 'package:whatnext/models/tv_show.dart';

class TvShowListWidget extends StatelessWidget {
  final List tvShowsList;
  final Function onTvShowTap;
  final Function loadMore;
  final Axis direction;
  final double height;
  final double width;
  final bool showLoadMore;
  const TvShowListWidget({
    @required this.tvShowsList,
    @required this.onTvShowTap,
    @required this.loadMore,
    @required this.direction,
    @required this.height,
    @required this.width,
    this.showLoadMore,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _showLoadMore = showLoadMore ?? false;
    return ListView.builder(
      scrollDirection: direction,
      itemCount: tvShowsList.length + 1,
      itemBuilder: (context, ind) {
        if (ind < tvShowsList.length) {
          TvShow popTvShow = tvShowsList[ind];
          return InkWell(
            onTap: () {
              print(" tapped on ${tvShowsList[ind].id} ");
              onTvShowTap(tvShowsList[ind].id, 'tv');
            },
            child: Container(
              height: height,
              width: width,
              padding: EdgeInsets.only(left: 12.5, right: 12.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: height - 40.0,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        "https://image.tmdb.org/t/p/w500${popTvShow.posterPath}",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    height: 40.0,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      popTvShow.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).primaryTextTheme.headline4,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return !_showLoadMore
              ? Container()
              : Container(
                  height: height - 40.0,
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
