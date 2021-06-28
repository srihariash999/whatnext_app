import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/models/message.dart';
import 'package:whatnext/viewmodels/chat_view_model.dart';

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
      viewModelBuilder: () => ChatViewModel(),
      onModelReady: (model) => model.init(widget.toUserName),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${widget.toUserName}',
              style: Theme.of(context).primaryTextTheme.headline3,
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
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 6.0),
                                child: BubbleSpecialOne(
                                  text: _message.message,
                                  color: Color(0xFFE8E8EE),
                                  isSender: _message.to == model.toUserName,
                                ),
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
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline4,
                                  onChanged: (String d) {
                                    model.scrollToLast();
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Container(
                                padding: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                child: model.isMessageSending
                                    ? Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () async {
                                          await model.sendMessage();
                                          print(" here");
                                          WidgetsBinding.instance
                                              .addPostFrameCallback(
                                                  (_) => model.scrollToLast());
                                        },
                                        icon: Icon(
                                          FeatherIcons.send,
                                          color: Theme.of(context)
                                              .primaryColorLight,
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
