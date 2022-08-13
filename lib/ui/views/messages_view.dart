import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:whatnext/services/firestore_service.dart';
// import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/providers/messages_provider.dart';

class MessagesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MessagesProvider>.withConsumer(
      viewModelBuilder: () => MessagesProvider(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        key: model.scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Messages",
            style: Theme.of(context).primaryTextTheme.headline3,
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColorLight,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        floatingActionButton: model.busy
            ? Container()
            : FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColorLight,
                onPressed: () async {
                  model.newChatPressed();
                },
                child: Icon(
                  FeatherIcons.messageSquare,
                  color: Theme.of(context).backgroundColor,
                ),
              ),
        body: SafeArea(
          child: model.busy
              ? Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : model.availableChatRooms.length > 0
                  ? RefreshIndicator(
                      onRefresh: model.init,
                      child: ListView.separated(
                        separatorBuilder: (context, sepInd) {
                          return Divider(
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(0.70),
                              height: 0.10,
                              thickness: 0.10);
                        },
                        itemCount: model.availableChatRooms.length,
                        itemBuilder: (context, index) {
                          String _roomName = model.availableChatRooms[index];
                          return InkWell(
                            onTap: () {
                              model.navigateToChatScreen(
                                  '${_roomName.replaceAll(model.currentUser, '')}');
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12.0),
                                    alignment: Alignment.center,
                                    child: FutureBuilder(
                                        future: FirestoreService()
                                            .getUserProfilePicture(
                                                '${_roomName.replaceAll(model.currentUser, '')}'),
                                        builder: (context, snap) {
                                          if (snap.hasData) {
                                            print(
                                                " data from snap : ${snap.data}");
                                            if (snap.data != null) {
                                              return CircleAvatar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColorLight,
                                                radius: 18.0,
                                                backgroundImage:
                                                    NetworkImage(snap.data),
                                              );
                                            } else {
                                              return CircleAvatar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColorLight,
                                                radius: 18.0,
                                                child: Icon(
                                                  Icons.person,
                                                  size: 18.0,
                                                  color: Theme.of(context)
                                                      .backgroundColor,
                                                ),
                                              );
                                            }
                                          } else
                                            return CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColorLight,
                                              radius: 18.0,
                                              child: Icon(
                                                Icons.person,
                                                size: 18.0,
                                                color: Theme.of(context)
                                                    .backgroundColor,
                                              ),
                                            );
                                        }),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_roomName.replaceAll(model.currentUser, '')}',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .headline3
                                                .copyWith(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          FutureBuilder(
                                              future:
                                                  model.getMessageStatusOfRoom(
                                                      _roomName,
                                                      _roomName.replaceAll(
                                                          model.currentUser,
                                                          ''),
                                                      model.currentUser),
                                              builder: (context, snap) {
                                                if (snap.hasData) {
                                                  print(" snap : ${snap.data}");
                                                  if (snap.data == true) {
                                                    return Container(
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.circle,
                                                            color: Colors.red,
                                                            size: 14.0,
                                                          ),
                                                          Text(
                                                            ' New Messages ',
                                                            style: Theme.of(
                                                                    context)
                                                                .primaryTextTheme
                                                                .headline5
                                                                .copyWith(
                                                                  fontSize:
                                                                      10.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                } else {
                                                  return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.10,
                                                    child:
                                                        LinearProgressIndicator(
                                                      color: Theme.of(context)
                                                          .primaryColorLight,
                                                      minHeight: 2.0,
                                                    ),
                                                  );
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Container(
                        child: Text(
                          'No open chat threads. Create one to chat',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline3
                              .copyWith(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
