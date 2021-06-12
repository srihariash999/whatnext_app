import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:whatnext/ui/widgets/post_text_field.dart';
import 'package:whatnext/viewmodels/new_post_view_model.dart';

class NewPostView extends StatelessWidget {
  final TextEditingController _postBodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<NewPostViewModel>.withConsumer(
      viewModelBuilder: () => NewPostViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("New Post",
                style: Theme.of(context).primaryTextTheme.headline3),
            elevation: 0.0,
          ),
          body: Container(
            child: PostTextField(
              controller: _postBodyController,
            ),
          ),
        );
      },
    );
  }
}
