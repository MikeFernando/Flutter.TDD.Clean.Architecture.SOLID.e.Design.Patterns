import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_tdd_clean_architecture/ui/components/components.dart';
import 'package:flutter_tdd_clean_architecture/ui/pages/pages.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([LoginPresenter])
void main() {
  late MockLoginPresenter presenter;
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockLoginPresenter();
    emailErrorController = StreamController<String?>();
    passwordErrorController = StreamController<String?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();

    when(presenter.emailErrorStream).thenAnswer(
        (_) => emailErrorController.stream.map((email) => email ?? ''));

    when(presenter.passwordErrorStream).thenAnswer((_) =>
        passwordErrorController.stream.map((password) => password ?? ''));

    when(presenter.isFormValidStream).thenAnswer(
        (_) => isFormValidController.stream.map((isValid) => isValid));

    when(presenter.isLoadingStream).thenAnswer(
        (_) => isLoadingController.stream.map((isLoading) => isLoading));

    final loginPage = MaterialApp(home: LoginPage(presenter: presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
  });

  testWidgets('Deve apresentar LoginPage com estado inicial correto',
      (tester) async {
    await loadPage(tester);

    final emailChildrenText = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );

    final passwordChildrenText = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );

    final button = tester.widget<Button>(find.byType(Button));

    expect(find.byType(CircularProgressIndicator), findsNothing);

    expect(
      emailChildrenText,
      findsOneWidget,
      reason:
          'quando um TextFormField tem apenas um filho de texto, significa que não há erros, já que um dos filhos é sempre o texto do label',
    );
    expect(
      passwordChildrenText,
      findsOneWidget,
      reason:
          'quando um TextFormField tem apenas um filho de texto, significa que não há erros, já que um dos filhos é sempre o texto do label',
    );

    expect(button.enabled, isFalse);
  });

  testWidgets('Deve chamar o validate com os dados corretos', (tester) async {
    await loadPage(tester);

    final button = find.byType(Button);
    await tester.tap(button);
  });

  testWidgets(
      'Deve chamar o presenter validateEmail e validatePassword quando o usuário digitar no campo Email e Senha',
      (tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);

    verify(presenter.validateEmail(email));
    verify(presenter.validatePassword(password));
  });

  testWidgets('Deve apresentar erro se o email ou senha for inválido',
      (tester) async {
    await loadPage(tester);

    emailErrorController.add('any_error');
    await tester.pump();

    passwordErrorController.add('any_error');
    await tester.pump();

    expect(find.text('any_error'), findsNWidgets(2));
  });

  testWidgets('Não deve apresentar erro se o email for válido', (tester) async {
    await loadPage(tester);

    emailErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Não deve apresentar erro se o email estiver com um string vazia',
      (tester) async {
    await loadPage(tester);

    emailErrorController.add('');
    await tester.pump();

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Deve mostrar mensagem de erro se a senha for inválida',
      (tester) async {
    await loadPage(tester);

    passwordErrorController.add('any_error');
    await tester.pump();

    expect(find.text('any_error'), findsOneWidget);
  });

  testWidgets(
      'Deve remover mensagem de erro se a senha for válida e não tiver erro',
      (tester) async {
    await loadPage(tester);

    passwordErrorController.add(null);
    await tester.pump();

    expect(find.text('any_error'), findsNothing);
  });

  testWidgets('Não deve apresentar erro se o senha estiver com um string vazia',
      (tester) async {
    await loadPage(tester);

    passwordErrorController.add('');
    await tester.pump();

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Deve habilitar o botão se o formulário for válido',
      (tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<Button>(find.byType(Button));

    expect(button.enabled, isTrue);
  });

  testWidgets('Deve desabilitar o botão se o formulário for inválido',
      (tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<Button>(find.byType(Button));

    expect(button.enabled, isFalse);
  });

  testWidgets('Deve mostrar loading', (tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Deve esconder loading', (tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets(
      'Deve chamar o método de autenticar quando o botão for pressionado',
      (tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = find.byType(Button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.auth()).called(1);
  });
}
