import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/constants/enums.dart';
import 'package:whatnext/models/user.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
// import 'package:whatnext/locator.dart';
// import 'package:whatnext/services/snackbar_service.dart';
import 'package:whatnext/viewmodels/friends_view_model.dart';

final TextEditingController _searchController = TextEditingController();

class FriendsView extends StatelessWidget {
  const FriendsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<FriendsViewModel>.withConsumer(
      viewModelBuilder: () => FriendsViewModel(),
      onModelReady: (model) => model.onInit(),
      builder: (context, model, child) {
        print("############## build trig##########");
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Friends Page",
                style: Theme.of(context).primaryTextTheme.headline1),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).primaryColorLight,
                ),
                onPressed: () {
                  model.onInit();
                },
              )
            ],
          ),
          body: Center(
            child: model.busy
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      verticalSpaceMedium,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) => model.searchFilter(val),
                          style: Theme.of(context).primaryTextTheme.headline4,
                          decoration: InputDecoration(
                            hintText: "Search a user",
                            hintStyle:
                                Theme.of(context).primaryTextTheme.headline4,
                            suffixIcon: InkWell(
                              onTap: () {
                                _searchController.clear();
                                model.searchFilter("");
                              },
                              child: Icon(
                                Icons.clear,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColorLight,
                              ),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColorLight,
                              ),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                      ),
                      verticalSpaceMedium,
                      Expanded(
                        child: ListView(
                            children: model.allUsers.map((UserModel u) {
                          int ind = model.allUsers.indexOf(u);
                          FriendStatus fri = model.usersFriendStatus[ind];
                          String _toShow = " ... ";
                          if (fri == FriendStatus.available) {
                            _toShow = "Follow";
                          } else {
                            _toShow = "Following";
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                            ),
                            child: InkWell(
                              onTap: () {
                                model.navigateToPeopleProfileView(u.userName);
                              },
                              child: Card(
                                elevation: 1.4,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${u.fullName}',
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .bodyText1,
                                            ),
                                            Text(
                                              '@${u.userName}',
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .bodyText2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: InkWell(
                                          onTap: () {
                                            model.friendAction(u, fri);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1.0,
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                              ),
                                            ),
                                            child: Text(
                                              _toShow,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .bodyText1,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList()),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
