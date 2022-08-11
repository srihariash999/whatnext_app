import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/ui/widgets/post_text_field.dart';
import 'package:whatnext/providers/new_post_provider.dart';

class NewPostView extends StatelessWidget {
  final TextEditingController _postBodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<NewPostProvider>.withConsumer(
      viewModelBuilder: () => NewPostProvider(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("New Post",
                style: Theme.of(context).primaryTextTheme.headline3),
            elevation: 0.0,
          ),
          body: Container(
            child: Column(
              children: [
                verticalSpaceLarge,
                Row(
                  children: [
                    horizontalSpaceMedium,
                    ElevatedButton(
                      onPressed: () {
                        model.goToSearchView();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Select a Movie/ TV Show',
                          style: Theme.of(context).primaryTextTheme.headline5,
                        ),
                      ),
                    ),
                    horizontalSpaceMedium,
                    horizontalSpaceMedium,
                    Container(
                      child: model.isItemSelected
                          ? Card(
                              child: Container(
                                height: 85.0,
                                width: 60.0,
                                child: model.itemType == "movie"
                                    ? Image.network(
                                        "https://image.tmdb.org/t/p/w500${model.movie.posterPath}",
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        "https://image.tmdb.org/t/p/w500${model.tvShow.posterPath}",
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            )
                          : Card(
                              child: Container(
                                height: 85.0,
                                width: 60.0,
                              ),
                            ),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                PostTextField(
                  controller: _postBodyController,
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (!model.isSubmitLoading) {
                          if (_postBodyController.text.length > 1) {
                            model.createPost(
                                postBody: _postBodyController.text);
                          } else {
                            model.showPostBodyErrorToast();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: model.isSubmitLoading
                            ? Lottie.asset(
                                'assets/load_black.json',
                                width: 60,
                                height: 30,
                              )
                            : Text(
                                'Submit Post',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline5,
                              ),
                      ),
                    ),
                    horizontalSpaceMedium,
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
