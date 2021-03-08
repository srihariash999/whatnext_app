import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

import 'package:whatnext/ui/shared/shared_styles.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
// import 'package:whatnext/locator.dart';
// import 'package:whatnext/services/snackbar_service.dart';
import 'package:whatnext/viewmodels/profile_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ProfileViewModel>.withConsumer(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (model) => model.onInit(),
      builder: (context, model, child) => Scaffold(
        // key: locator<SnackbarService>().scaffoldKey,
        appBar: AppBar(),
        body: model.busy
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 36.0,
                          child: Icon(
                            Icons.person,
                            size: 38.0,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            child: Text(
                              "${model.user.fullName}",
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                          ),
                          verticalSpaceSmall,
                          Container(
                            child: Text("@${model.user.userName}",
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
                              style:
                                  Theme.of(context).primaryTextTheme.headline4,
                            ),
                          ),
                          horizontalSpaceSmall,
                          Container(
                            child: Text(
                              "${model.user.followingList.length}",
                              style:
                                  Theme.of(context).primaryTextTheme.headline4,
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
                              style:
                                  Theme.of(context).primaryTextTheme.headline4,
                            ),
                          ),
                          horizontalSpaceSmall,
                          Container(
                            child: Text(
                              "${model.user.followersList.length}",
                              style:
                                  Theme.of(context).primaryTextTheme.headline4,
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
                              style:
                                  Theme.of(context).primaryTextTheme.headline4,
                            ),
                          ),
                          horizontalSpaceSmall,
                          Container(
                            child: Text(
                              "${model.userWatchList.length}",
                              style:
                                  Theme.of(context).primaryTextTheme.headline4,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          model.changePage(0);
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: model.pageSelected == 0 ? 3.0 : 0.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                      InkWell(
                        onTap: () {
                          model.changePage(1);
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: model.pageSelected == 1 ? 3.0 : 0.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                    ],
                  ),
                  verticalSpaceMedium,
                  Expanded(
                    child: ListView(
                      children: model.peopleToShow.map((people) {
                        print("people: $people");
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: InkWell(
                            onTap: () {
                              model.navigateToPeopleProfileView(
                                  people['userName']);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                horizontalSpaceMedium,
                                Column(
                                  children: [
                                    Text(
                                      people['fullName'],
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline4
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                    Text('@' + people['userName'],
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline4),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
