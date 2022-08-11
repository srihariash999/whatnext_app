import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/ui/widgets/tv_shows_list_widget.dart';
import 'package:whatnext/providers/home_provider.dart';

/* 
   arguments : {    
     'type' : 'popular' or 'top rated'
   }
*/

class TvShowVerticalView extends StatelessWidget {
  final arguments;
  const TvShowVerticalView({
    Key key,
    @required this.arguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "${arguments['type']}",
          style: Theme.of(context).primaryTextTheme.headline2,
        ),
        elevation: 0.0,
      ),
      body: ViewModelProvider<HomeProvider>.withConsumer(
        viewModelBuilder: () => HomeProvider(),
        onModelReady: (model) => model.onInit(),
        builder: (context, model, child) => Column(
          children: [
            verticalSpaceMedium,
            Expanded(
              child: RefreshIndicator(
                onRefresh: model.onInit,
                child: TvShowGridView(
                  tvShowsList: arguments['type'] == "Popular Tv Shows"
                      ? model.popularTvShowsList
                      : model.topRatedTvShowsList,
                  onTvShowTap: model.onItemTap,
                  loadMore: arguments['type'] == "Popular Tv Shows"
                      ? model.loadMorePopularTvShows
                      : model.loadMoreTopRatedTvShows,
                  direction: Axis.vertical,
                  height: 300.0,
                  width: 150.0,
                  showLoadMore: true,
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
