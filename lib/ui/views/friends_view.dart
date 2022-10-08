import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/constants/enums.dart';
import 'package:whatnext/models/user.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
// import 'package:whatnext/locator.dart';
// import 'package:whatnext/services/snackbar_service.dart';
import 'package:whatnext/providers/friends_provider.dart';

final TextEditingController _searchController = TextEditingController();

class FriendsView extends StatelessWidget {
  const FriendsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<FriendsProvider>.withConsumer(
      viewModelBuilder: () => FriendsProvider(),
      onModelReady: (model) => model.onInit(),
      builder: (context, model, child) {
        // print("############## build trig##########");
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0.0,
            title: Text("Find People", style: Theme.of(context).primaryTextTheme.headline1),
            iconTheme: IconThemeData(
              color: Theme.of(context).primaryColorLight,
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).primaryColorLight,
                ),
                onPressed: () {
                  model.onInit();
                },
              ),
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
                            hintStyle: Theme.of(context).primaryTextTheme.headline4,
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
                        child: ListView.builder(
                          itemCount: model.allUsers.length,
                          itemBuilder: (context, index) {
                            UserModel u = model.allUsers[index];
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).splashColor,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  margin: EdgeInsets.all(4.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Row(
                                            children: [
                                              u.profilePicture != null
                                                  ? Container(
                                                      alignment: Alignment.center,
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors.white,
                                                        backgroundImage:
                                                            NetworkImage(u.profilePicture),
                                                      ),
                                                    )
                                                  : Container(
                                                      alignment: Alignment.center,
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors.white,
                                                        child: Icon(Icons.person),
                                                      ),
                                                    ),
                                              SizedBox(
                                                width: 6.0,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${u.fullName}',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .primaryTextTheme
                                                          .headline4
                                                          .copyWith(
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                    ),
                                                    Text(
                                                      '@${u.userName}',
                                                      style: Theme.of(context)
                                                          .primaryTextTheme
                                                          .headline5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: FriendStatusWidget(
                                              u: u, fri: fri, model: model, toShow: _toShow),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class FriendStatusWidget extends StatefulWidget {
  const FriendStatusWidget({
    Key key,
    @required String toShow,
    @required FriendStatus fri,
    @required this.model,
    @required UserModel u,
  })  : _toShow = toShow,
        _u = u,
        _fri = fri,
        super(key: key);

  final String _toShow;
  final UserModel _u;
  final FriendStatus _fri;
  final FriendsProvider model;

  @override
  _FriendStatusWidgetState createState() => _FriendStatusWidgetState();
}

class _FriendStatusWidgetState extends State<FriendStatusWidget> {
  bool _localLoading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () async {
        setState(() {
          _localLoading = true;
        });
        await widget.model.friendAction(widget._u, widget._fri);
        setState(() {
          _localLoading = false;
        });
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Card(
          color: Theme.of(context).primaryColorLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: _localLoading
              ? Container(
                  width: 50.0,
                  child: LinearProgressIndicator(),
                )
              : Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    widget._toShow,
                    style: TextStyle(
                      color: Theme.of(context).cardColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
