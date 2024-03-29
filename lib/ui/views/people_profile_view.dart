import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
// import 'package:whatnext/ui/shared/app_colors.dart';
// import 'package:whatnext/ui/shared/shared_styles.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/providers/people_profile_provider.dart';

class PeopleProfileView extends StatelessWidget {
  final String userName;
  PeopleProfileView({Key key, @required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<PeopleProfileProvider>.withConsumer(
      viewModelBuilder: () => PeopleProfileProvider(),
      onModelReady: (model) => model.onInit(userName),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: model.person.profilePicture != null ? Border() : Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: model.person.profilePicture != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                  model.person.profilePicture,
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
                        children: [
                          Container(
                            child: Text(
                              "${model.person.fullName}",
                              style: Theme.of(context).primaryTextTheme.headline2,
                            ),
                          ),
                          verticalSpaceSmall,
                          Container(
                            child: Text(
                              "@${model.person.userName}",
                              style: Theme.of(context).primaryTextTheme.headline4,
                            ),
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
                              style: Theme.of(context).primaryTextTheme.headline5,
                            ),
                          ),
                          horizontalSpaceSmall,
                          Container(
                            child: Text(
                              "${model.person.followingList.length}",
                              style: Theme.of(context).primaryTextTheme.headline5,
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
                              style: Theme.of(context).primaryTextTheme.headline5,
                            ),
                          ),
                          horizontalSpaceSmall,
                          Container(
                            child: Text(
                              "${model.person.followersList.length}",
                              style: Theme.of(context).primaryTextTheme.headline5,
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
                              style: Theme.of(context).primaryTextTheme.headline5,
                            ),
                          ),
                          horizontalSpaceSmall,
                          Container(
                            child: Text(
                              "${model.personWatchList.length}",
                              style: Theme.of(context).primaryTextTheme.headline5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(),
                  ),
                  verticalSpaceSmall,
                  Expanded(
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, childAspectRatio: 0.70),
                      children: model.personWatchList.map((movie) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 4.0, right: 4.0, top: 4.0, bottom: 4.0),
                          child: Container(
                            padding:
                                EdgeInsets.only(top: 6.0, bottom: 6.0, left: 6.0, right: 6.0),
                            decoration: BoxDecoration(
                                color: model.getColor(
                                  movie['status'].toString(),
                                ),
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                              alignment: Alignment.center,
                              child: Image.network(
                                "https://image.tmdb.org/t/p/w500${movie['poster']}",
                                fit: BoxFit.contain,
                              ),
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
