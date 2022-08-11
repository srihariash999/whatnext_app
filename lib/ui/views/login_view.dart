import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/ui/widgets/busy_button.dart';
import 'package:whatnext/ui/widgets/input_field.dart';
import 'package:whatnext/ui/widgets/text_link.dart';
import 'package:whatnext/providers/login_provider.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginProvider>.withConsumer(
      viewModelBuilder: () => LoginProvider(),
      builder: (context, model, child) => Scaffold(
          body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   'Login',
            //   style: Theme.of(context)
            //       .primaryTextTheme
            //       .headline1
            //       .copyWith(fontSize: 32.0),
            // ),
            Container(
              height: 100.0,
              width: 250.0,
              padding: EdgeInsets.all(16.0),
              child:
                  Image.asset('assets/whatnext_logo.png', fit: BoxFit.contain),
            ),
            verticalSpaceLarge,
            InputField(
              placeholder: 'Email',
              controller: emailController,
              textInputType: TextInputType.emailAddress,
            ),
            verticalSpaceSmall,
            InputField(
              placeholder: 'Password',
              password: true,
              controller: passwordController,
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
            ),
            verticalSpaceMedium,
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BusyButton(
                  title: 'Login',
                  busy: model.busy,
                  onPressed: () {
                    model.login(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  },
                )
              ],
            ),
            verticalSpaceMedium,
            TextLink(
              'Create an Account if you\'re new',
              onPressed: () {
                print(" wants to signup");
                model.navigateToSignUp();
              },
            ),
            verticalSpaceMedium,
            TextLink(
              'Reset password',
              onPressed: () {
                print(" Reset password");
                model.navigateToResetView();
              },
            )
          ],
        ),
      )),
    );
  }
}
