import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:whatnext/ui/shared/ui_helpers.dart';
import 'package:whatnext/ui/widgets/busy_button.dart';
import 'package:whatnext/ui/widgets/input_field.dart';
import 'package:whatnext/viewmodels/login_view_model.dart';

class ResetView extends StatelessWidget {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginViewModel>.withConsumer(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => Scaffold(
          body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100.0,
              width: 250.0,
              padding: EdgeInsets.all(16.0),
              child:
                  Image.asset('assets/whatnext_logo.png', fit: BoxFit.contain),
            ),
            verticalSpaceLarge,
            InputField(
              placeholder: 'Registered email',
              controller: emailController,
              textInputType: TextInputType.emailAddress,
            ),
            verticalSpaceSmall,
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BusyButton(
                  title: 'Send Reset link',
                  busy: model.busy,
                  onPressed: () {
                    model.resetPassword(
                      email: emailController.text.trim(),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
