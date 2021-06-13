import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

import 'package:whatnext/viewmodels/new_post_view_model.dart';

var formatter = DateFormat.yMMMd('en_US');

class NewPostItemSearchView extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<NewPostViewModel>.withConsumer(
      viewModelBuilder: () => NewPostViewModel(),
      builder: (context, model, child) {
        print(" query: ${_searchController.text}");
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0.0,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 12.0),
                child: TextField(
                  controller: _searchController,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.70),
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                  ),
                  onSubmitted: (String query) {
                    if (query.length > 1) {
                      print(" query submitted");
                      model.fetchSearchReults(query);
                    }
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white.withOpacity(0.8),
                    filled: true,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (_searchController.text.length > 1) {
                          print(" query submitted");
                          model.fetchSearchReults(_searchController.text);
                        }
                      },
                      child: Icon(Icons.search_rounded),
                    ),
                    hintText: " Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    child: model.searchResults.length == 0
                        ? Container(
                            alignment: Alignment.center,
                            child: Text(
                              " Search for a movie / TV Show",
                              style:
                                  Theme.of(context).primaryTextTheme.headline3,
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: model.searchResults
                                  .map((Map<String, dynamic> result) {
                                String date;
                                if (result['media_type'] == 'movie') {
                                  if (result['item'].releaseDate.toString() !=
                                          "null" &&
                                      result['item'].releaseDate.toString() !=
                                          "") {
                                    date = result['item'].releaseDate;
                                  } else {
                                    date = "${DateTime.now()}";
                                  }
                                } else {
                                  if (result['item'].firstAirDate.toString() !=
                                          "null" &&
                                      result['item'].firstAirDate.toString() !=
                                          "") {
                                    date = result['item'].firstAirDate;
                                  } else {
                                    date = "${DateTime.now()}";
                                  }
                                }

                                return Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, bottom: 12.0, left: 12.0),
                                    child: ListTile(
                                      onTap: () {
                                        model.onItemSelect(result: result);
                                      },
                                      title: Text(
                                        result['media_type'] == 'movie'
                                            ? result['item'].title
                                            : result['item'].name,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline3
                                            .copyWith(
                                                fontWeight: FontWeight.w400),
                                      ),
                                      subtitle: Text(
                                        '${formatter.format(DateTime.parse(date))}',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline5,
                                      ),
                                      trailing: Container(
                                        height: 180.0,
                                        width: 150.0,
                                        child: result['item'].posterPath != null
                                            ? Image.network(
                                                "https://image.tmdb.org/t/p/w500${result['item'].posterPath}",
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                child: Icon(
                                                  Icons.not_interested,
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  size: 22.0,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )),
              ),
            ],
          ),
        );
      },
    );
  }
}
