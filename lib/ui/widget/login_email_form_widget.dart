import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pumpmonitoring/core/auth/auth_firebase.dart';
import 'package:pumpmonitoring/ui/widget/custom_alert_dialog.dart';
import 'package:pumpmonitoring/ui/widget/email_model_widget.dart';
import 'package:provider/provider.dart';

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({Key? key, required this.model}) : super(key: key);
  final EmailSignInModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInModel>(
      create: (context) => EmailSignInModel(auth: auth),
      child: Consumer<EmailSignInModel>(
        builder: (context, model, _) => EmailSignInForm(
          model: model,
        ),
      ),
    );
  }

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController? emailController = TextEditingController();
  final TextEditingController? passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInModel get model => widget.model;

  Future<void> _submit() async {
    try {
      await model.submit();
    } on FirebaseException catch (e) {
      CustomAlertDialog(
        title: "Sign in failed",
        content: e.message!,
        defaultActionText: "OK",
      ).show(context);
    }
  }

  void _toogleFormType() {
    model.toggleFormType();
    emailController!.clear();
    passwordController!.clear();
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    return [
      _buildHeader(),
      const SizedBox(
        height: 20.0,
      ),
      _buildEmailTextField(),
      const SizedBox(
        height: 15.0,
      ),
      _buildPasswordTextField(),
      const SizedBox(
        height: 15.0,
      ),
      _buildFormActions(),
    ];
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          height: 120.0,
          width: 120.0,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 164, 221, 166),
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage('assets/images/logo.png'),
              fit: BoxFit.fill,
            ),
            shape: BoxShape.rectangle,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          model.headerText,
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );
  }

  Widget _buildEmailTextField() {
    return TextField(
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: emailController,
      decoration: InputDecoration(
          labelText: "Email",
          hintText: "test@test.com",
          border: const OutlineInputBorder(),
          icon: const Icon(Icons.mail),
          errorText: model.emailErrorText,
          enabled: model.isLoading == false),
      focusNode: _emailFocusNode,
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: model.updateEmail,
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
          labelText: "Password",
          border: const OutlineInputBorder(),
          icon: const Icon(Icons.lock),
          errorText: model.passwordErrorText,
          enabled: model.isLoading == false),
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: model.updatePassword,
    );
  }

  Widget _buildFormActions() {
    if (model.isLoading) {
      return const CircularProgressIndicator();
    }
    return Column(
      children: [
        ElevatedButton(
          onPressed: model.canSubmit ? _submit : null,
          // ignore: sort_child_properties_last
          child: Text(
            model.primaryButtonText,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.deepOrange[200],
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        ),
        TextButton(
            onPressed: !model.isLoading ? _toogleFormType : null,
            child: Text(
              model.secondaryButtonText,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: _buildChildren(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController!.dispose();
    passwordController!.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
