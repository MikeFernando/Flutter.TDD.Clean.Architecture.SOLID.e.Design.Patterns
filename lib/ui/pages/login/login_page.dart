import 'package:flutter/material.dart';

import '../../components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;
  const LoginPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              LoginHeader(),
              Form(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: StreamBuilder<String?>(
                      stream: presenter.emailErrorStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIconColor:
                                Theme.of(context).colorScheme.primary,
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email',
                            errorText: (snapshot.data == null ||
                                    snapshot.data!.isEmpty)
                                ? null
                                : snapshot.data,
                          ),
                          onChanged: presenter.validateEmail,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: StreamBuilder<String?>(
                      stream: presenter.passwordErrorStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          decoration: InputDecoration(
                            prefixIconColor:
                                Theme.of(context).colorScheme.primary,
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Senha',
                            errorText: snapshot.data?.isEmpty != false
                                ? null
                                : snapshot.data,
                          ),
                          onChanged: presenter.validatePassword,
                        );
                      },
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: presenter.isFormValidStream,
                    builder: (context, snapshot) {
                      return Button(
                        onPressed: () {},
                        label: 'Entrar',
                        enabled: snapshot.data ?? false,
                      );
                    },
                  ),
                  CustomTextButton(
                    onPressed: () {},
                    icon: Icons.person_add,
                    label: 'Criar conta',
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
