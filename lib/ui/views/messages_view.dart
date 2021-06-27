import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:whatnext/viewmodels/messages_view_model.dart';

class MessagesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MessagesViewModel>.withConsumer(
      viewModelBuilder: () => MessagesViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Messages",
            style: Theme.of(context).primaryTextTheme.headline3,
          ),
          elevation: 0.0,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColorLight,
          onPressed: () {},
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
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor: Colors.orange[300],
                                radius: 24.0,
                                child: Icon(
                                  Icons.person,
                                  size: 24.0,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'John Doe',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline3
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      'EkdNTVRDIFJkLCBNTVRDIENvbG9ueSwgU2Fydm9kYXlhIEVuY2xhdmUsIE5ldyBEZWxoaSwgRGVsaGkgMTEwMDE3LCBJbmRpYSIuKiwKFAoSCSk109IG4gw5Edkjg4qckO_lEhQKEglrawz8A-IMORFLLQXQSa85Bg',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline5
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(
                                  right: 8.0,
                                  top: 30.0,
                                  bottom: 12.0,
                                  left: 16.0),
                              child: Text(
                                '45s ago',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline5
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor: Colors.orange[300],
                                radius: 24.0,
                                child: Icon(
                                  Icons.person,
                                  size: 24.0,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mia Nguen',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline3
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      'EkdNTVRDIFJkLCBNTVRDIENvbG9ueSwgU2Fydm9kYXlhIEVuY2xhdmUsIE5ldyBEZWxoaSwgRGVsaGkgMTEwMDE3LCBJbmRpYSIuKiwKFAoSCSk109IG4gw5Edkjg4qckO_lEhQKEglrawz8A-IMORFLLQXQSa85Bg',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline5
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(
                                  right: 8.0,
                                  top: 30.0,
                                  bottom: 12.0,
                                  left: 16.0),
                              child: Text(
                                '18m ago',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline5
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor: Colors.orange[300],
                                radius: 24.0,
                                child: Icon(
                                  Icons.person,
                                  size: 24.0,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Henna beck',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline3
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      'EkdNTVRDIFJkLCBNTVRDIENvbG9ueSwgU2Fydm9kYXlhIEVuY2xhdmUsIE5ldyBEZWxoaSwgRGVsaGkgMTEwMDE3LCBJbmRpYSIuKiwKFAoSCSk109IG4gw5Edkjg4qckO_lEhQKEglrawz8A-IMORFLLQXQSa85Bg',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline5
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(
                                  right: 8.0,
                                  top: 30.0,
                                  bottom: 12.0,
                                  left: 16.0),
                              child: Text(
                                '2h ago',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline5
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor: Colors.orange[300],
                                radius: 24.0,
                                child: Icon(
                                  Icons.person,
                                  size: 24.0,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tanim Mridha',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline3
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      'EkdNTVRDIFJkLCBNTVRDIENvbG9ueSwgU2Fydm9kYXlhIEVuY2xhdmUsIE5ldyBEZWxoaSwgRGVsaGkgMTEwMDE3LCBJbmRpYSIuKiwKFAoSCSk109IG4gw5Edkjg4qckO_lEhQKEglrawz8A-IMORFLLQXQSa85Bg',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline5
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(
                                  right: 8.0,
                                  top: 30.0,
                                  bottom: 12.0,
                                  left: 16.0),
                              child: Text(
                                '3d ago',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline5
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
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
      ),
    );
  }
}
