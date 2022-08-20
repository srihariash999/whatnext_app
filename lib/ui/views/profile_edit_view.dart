import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/providers/profile_provider.dart';

class ProfileEditView extends StatelessWidget {
  const ProfileEditView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ProfileProvider>.withConsumer(
      viewModelBuilder: () => ProfileProvider(),
      onModelReady: (model) => model.onInit(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              "Edit Profile",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: model.imageFile != null
                          ? Image.file(
                              model.imageFile,
                              fit: BoxFit.cover,
                            )
                          : Icon(FeatherIcons.user),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[300]),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                        child: Text(
                          "Select Picture",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        model.pickImage();
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0),
                  child: TextField(
                    controller: model.controller,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.70),
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(0.8),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        hintText: "Type something here",
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.40),
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                ),
                verticalSpaceLarge,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[300]),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24.0, top: 8.0, bottom: 8.0),
                        child: Text(
                          "   Cancel   ",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.70),
                          ),
                        ),
                      ),
                      onPressed: () {
                        model.canceldelete();
                      },
                    ),
                    model.profileUpdating
                        ? Container(
                            height: 40.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14.0)),
                            child: Lottie.asset(
                              'assets/load_black.json',
                              width: 60,
                              height: 30,
                            ),
                          )
                        : TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue[300]),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0,
                                  right: 24.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Text(
                                "Update Profile",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              model.changeName();
                            },
                          ),
                  ],
                ),
                verticalSpaceLarge,
              ],
            ),
          ),
        );
      },
    );
  }
}
