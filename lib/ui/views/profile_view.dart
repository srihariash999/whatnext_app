import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/models/feed.dart';

import 'package:whatnext/ui/shared/shared_styles.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/ui/views/profile_edit_view.dart';
import 'package:whatnext/ui/widgets/feed_list_card.dart';
// import 'package:whatnext/locator.dart';
// import 'package:whatnext/services/snackbar_service.dart';
import 'package:whatnext/viewmodels/profile_view_model.dart';
import 'package:expandable/expandable.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ProfileViewModel>.withConsumer(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (model) => model.onInit(),
      builder: (context, model, child) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: model.busy
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: model.onInit,
                child: ListView(
                  children: [
                    verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: model.profilePicture != null
                                ? Border()
                                : Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: model.profilePicture != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    model.profilePicture,
                                    fit: BoxFit.cover,
                                    height: 75.0,
                                    width: 75.0,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.person,
                                    size: 38.0,
                                  ),
                                ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 200.0,
                                  child: Text(
                                    "${model.user.fullName}",
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileEditView(),
                                      ),
                                    );
                                    model.onInit();
                                  },
                                  icon: Icon(
                                    FeatherIcons.edit2,
                                    size: 16.0,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                              ],
                            ),
                            verticalSpaceSmall,
                            Container(
                              width: 200.0,
                              child: Text("@${model.user.userName}",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline3),
                            ),
                          ],
                        )
                      ],
                    ),
                    verticalSpaceMedium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text(
                                "Following : ",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline4,
                              ),
                            ),
                            horizontalSpaceSmall,
                            Container(
                              child: Text(
                                "${model.user.followingList.length}",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline4,
                              ),
                            ),
                          ],
                        ),
                        horizontalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text(
                                "Followers : ",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline4,
                              ),
                            ),
                            horizontalSpaceSmall,
                            Container(
                              child: Text(
                                "${model.user.followersList.length}",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline4,
                              ),
                            ),
                          ],
                        ),
                        horizontalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text(
                                "Movies : ",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline4,
                              ),
                            ),
                            horizontalSpaceSmall,
                            Container(
                              child: Text(
                                "${model.userWatchList.length}",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline4,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    verticalSpaceSmall,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      child: Container(
                        padding: EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.0),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text(
                                "Email : ",
                                style: namesTextStyle.copyWith(
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Container(
                              child: Text(
                                "${model.user.email}",
                                style: namesTextStyle.copyWith(
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpaceMedium,
                    ExpandablePanel(
                      header: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Connections:",
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ),
                      ),
                      theme: ExpandableThemeData(
                        iconColor: Theme.of(context).primaryColorLight,
                      ),
                      collapsed: Text(
                        "",
                      ),
                      expanded: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    model.changePage(0);
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    elevation:
                                        model.pageSelected == 0 ? 3.0 : 0.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Followers ",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            Container(
                                              height: 3.5,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: model.pageSelected == 0
                                                    ? Colors.green
                                                    : Colors.black38,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    model.changePage(1);
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    elevation:
                                        model.pageSelected == 1 ? 3.0 : 0.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Following ",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            Container(
                                              height: 3.5,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: model.pageSelected == 1
                                                    ? Colors.green
                                                    : Colors.black38,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalSpaceMedium,
                          Container(
                            height: 300.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(0.30),
                            ),
                            child: ListView(
                              children: model.peopleToShow.map((people) {
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: InkWell(
                                    onTap: () {
                                      model.navigateToPeopleProfileView(
                                          people['userName']);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        horizontalSpaceMedium,
                                        Container(
                                          alignment: Alignment.center,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 20.0,
                                            child: Icon(
                                              Icons.person,
                                              size: 20.0,
                                            ),
                                          ),
                                        ),
                                        horizontalSpaceMedium,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('@' + people['userName'],
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .headline4
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          verticalSpaceMedium,
                        ],
                      ),
                    ),
                    Column(
                      children: model.userFeedPosts
                          .map(
                            (Feed feedItem) => InkWell(
                              onTap: () {},
                              child: IntrinsicHeight(
                                child: Stack(
                                  children: [
                                    FeedListCardWidget(feed: feedItem),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10.0, top: 4.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () {
                                            _scaffoldKey.currentState
                                                .showBottomSheet(
                                              (context) => Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 0.5,
                                                    color: Colors.black
                                                        .withOpacity(0.30),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20.0),
                                                    topRight:
                                                        Radius.circular(20.0),
                                                  ),
                                                ),
                                                child: Column(
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
                                                          height: 4.0,
                                                          width: 28.0,
                                                          color: Colors.black54,
                                                        )
                                                      ],
                                                    ),
                                                    verticalSpaceLarge,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        TextButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                            .grey[
                                                                        300]),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 24.0,
                                                                    right: 24.0,
                                                                    top: 8.0,
                                                                    bottom:
                                                                        8.0),
                                                            child: Text(
                                                              "      Cancel     ",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.70),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            model
                                                                .canceldelete();
                                                          },
                                                        ),
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
                                                                    bottom:
                                                                        8.0),
                                                            child: Text(
                                                              "Delete this post",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            model
                                                                .deleteFeedpost(
                                                              index: model
                                                                  .userFeedPosts
                                                                  .indexOf(
                                                                      feedItem),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    verticalSpaceMedium,
                                                    Text(
                                                      '*This action cannot be undone',
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black
                                                            .withOpacity(0.70),
                                                      ),
                                                    ),
                                                    verticalSpaceLarge,
                                                  ],
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(22.0),
                                                  topRight:
                                                      Radius.circular(22.0),
                                                ),
                                              ),
                                            );
                                            // model.onAddTap(context);
                                          },
                                          icon: Icon(
                                            FeatherIcons.trash2,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
