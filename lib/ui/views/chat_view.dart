import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/models/message.dart';
import 'package:whatnext/services/firestore_service.dart';
import 'package:whatnext/viewmodels/chat_view_model.dart';
import 'package:whatnext/locator.dart';

class ChatView extends StatefulWidget {
  final String toUserName;
  ChatView({Key key, @required this.toUserName}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ChatViewModel>.withConsumer(
      disposeViewModel: false,
      viewModelBuilder: () => locator<ChatViewModel>(),
      onModelReady: (model) => model.init(widget.toUserName),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                FutureBuilder(
                    future: FirestoreService()
                        .getUserProfilePicture(widget.toUserName),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        String pic = snap.data;
                        if (pic != null) {
                          return Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).primaryColorLight,
                              radius: 20.0,
                              backgroundImage: NetworkImage(pic),
                            ),
                          );
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).primaryColorLight,
                              radius: 20.0,
                              child: Icon(
                                Icons.person,
                                size: 20.0,
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                          );
                        }
                      } else {
                        return Container(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).primaryColorLight,
                            radius: 20.0,
                            child: Icon(
                              Icons.person,
                              size: 20.0,
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                        );
                      }
                    }),
                SizedBox(
                  width: 16.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.toUserName}',
                      style:
                          Theme.of(context).primaryTextTheme.headline2.copyWith(
                                fontWeight: FontWeight.w300,
                              ),
                    ),
                    Text(
                      'Last seen : ${model.lastSeen}',
                      style:
                          Theme.of(context).primaryTextTheme.headline5.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                color: Theme.of(context)
                                    .primaryColorLight
                                    .withOpacity(0.70),
                              ),
                    ),
                  ],
                ),
              ],
            ),
            elevation: 0.0,
          ),
          body: model.busy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: model.scrollController,
                            itemCount: model.messages.length,
                            itemBuilder: (context, int index) {
                              Message _message = model.messages[index];
                              return ChatAndDateWidget(
                                message: _message,
                                model: model,
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: model.messageController,
                                  minLines: 1,
                                  maxLines: 4,
                                  readOnly: model.isMessageSending,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline4,
                                  onChanged: (String d) {
                                    model.scrollToLast();
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: model.isMessageSending
                                        ? Container(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.5,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 40.0,
                                                width: 1.0,
                                                color: Theme.of(context)
                                                    .primaryColorLight
                                                    .withOpacity(0.60),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  await model.sendMessage();
                                                  print(" here");
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) => model
                                                              .scrollToLast());
                                                },
                                                icon: Icon(
                                                  FeatherIcons.send,
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 0.50,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 0.50,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 0.50,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class ChatAndDateWidget extends StatelessWidget {
  const ChatAndDateWidget({
    Key key,
    @required Message message,
    @required this.model,
  })  : _message = message,
        super(key: key);

  final Message _message;
  final ChatViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: _message.to == model.toUserName
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          _message.to != model.toUserName
              ? Container()
              : Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        "${DateFormat('MMMd').format(
                          DateTime.parse(_message.addedOn),
                        )}, ${DateFormat('Hm').format(
                          DateTime.parse(_message.addedOn),
                        )}",
                        style: TextStyle(
                          fontSize: 9.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context)
                              .primaryColorLight
                              .withOpacity(0.50),
                        ),
                      ),
                    ),
                  ),
                ),
          BubbleSpecialOne(
            text: _message.message,
            color: Color(0xFFE8E8EE),
            isSender: _message.to == model.toUserName,
          ),
          _message.to == model.toUserName
              ? Container()
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      "${DateFormat('MMMd').format(
                        DateTime.parse(_message.addedOn),
                      )}, ${DateFormat('Hm').format(
                        DateTime.parse(_message.addedOn),
                      )}",
                      style: TextStyle(
                        fontSize: 9.0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(0.50),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
