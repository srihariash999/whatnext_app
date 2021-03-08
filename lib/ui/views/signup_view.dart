import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/ui/widgets/busy_button.dart';
import 'package:whatnext/ui/widgets/input_field.dart';
import 'package:whatnext/viewmodels/signup_view_model.dart';
import 'package:whatnext/ui/widgets/expansion_list.dart';

class SignUpView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpViewModel>.withConsumer(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  onPressed: () {
                    model.goBack();
                  },
                ),
              ),
              verticalSpaceMedium,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Sign Up',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline1
                            .copyWith(fontSize: 36.0),
                      ),
                      verticalSpaceMedium,
                      InputField(
                        placeholder: 'Full Name',
                        controller: fullNameController,
                      ),
                      verticalSpaceSmall,
                      InputField(
                        placeholder: 'userName',
                        controller: userNameController,
                      ),
                      verticalSpaceSmall,
                      InputField(
                        placeholder: 'Email',
                        controller: emailController,
                      ),
                      verticalSpaceSmall,
                      InputField(
                        placeholder: 'Password',
                        password: true,
                        controller: passwordController,
                        additionalNote:
                            'Password has to be a minimum of 6 characters.',
                      ),
                      verticalSpaceMedium,
                      ExpansionList<String>(
                        items: ['Admin', 'User'],
                        title: model.selectedRole,
                        onItemSelected: model.setSelectedRole,
                      ),
                      verticalSpaceMedium,
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BusyButton(
                            title: 'Sign Up',
                            busy: model.busy,
                            onPressed: () {
                              model.signUp(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  userName: userNameController.text,
                                  fullName: fullNameController.text);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
