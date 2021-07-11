import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:whatnext/services/firestore_service.dart';
// import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/viewmodels/messages_view_model.dart';

class MessagesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MessagesViewModel>.withConsumer(
      viewModelBuilder: () => MessagesViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        key: model.scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Messages",
            style: Theme.of(context).primaryTextTheme.headline3,
          ),
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
                      child: ListView.builder(
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
                                            print(" data from snap : ${snap.data}");
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
                                          Row(
                                            children: [
                                              Text(
                                                'chat with ',
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .headline3
                                                    .copyWith(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                              ),
                                              Text(
                                                '${_roomName.replaceAll(model.currentUser, '')}',
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .headline3
                                                    .copyWith(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                            ],
                                          ),
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
