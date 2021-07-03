// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hey There,`
  String get HeyThere {
    return Intl.message(
      'Hey There,',
      name: 'HeyThere',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get WelcomeBack {
    return Intl.message(
      'Welcome Back!',
      name: 'WelcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Login to your account`
  String get LoginToYourAccount {
    return Intl.message(
      'Login to your account',
      name: 'LoginToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Custom Sign In`
  String get CustomSignIn {
    return Intl.message(
      'Custom Sign In',
      name: 'CustomSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign In with Google`
  String get SignInGoogle {
    return Intl.message(
      'Sign In with Google',
      name: 'SignInGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up with Google`
  String get SignUpGoogle {
    return Intl.message(
      'Sign Up with Google',
      name: 'SignUpGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Link Google Account`
  String get LinkGoogle {
    return Intl.message(
      'Link Google Account',
      name: 'LinkGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Sign In with Facebook`
  String get SignInFacebook {
    return Intl.message(
      'Sign In with Facebook',
      name: 'SignInFacebook',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up with Facebook`
  String get SignUpFacebook {
    return Intl.message(
      'Sign Up with Facebook',
      name: 'SignUpFacebook',
      desc: '',
      args: [],
    );
  }

  /// `Sign In with your Phone Number`
  String get SignInPhone {
    return Intl.message(
      'Sign In with your Phone Number',
      name: 'SignInPhone',
      desc: '',
      args: [],
    );
  }

  /// `Link Facebook Account`
  String get LinkFacebook {
    return Intl.message(
      'Link Facebook Account',
      name: 'LinkFacebook',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get SignIn {
    return Intl.message(
      'Sign In',
      name: 'SignIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get SignUp {
    return Intl.message(
      'Sign Up',
      name: 'SignUp',
      desc: '',
      args: [],
    );
  }

  /// `Already have an Account?`
  String get SignInInstead {
    return Intl.message(
      'Already have an Account?',
      name: 'SignInInstead',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an Account?`
  String get SignUpInstead {
    return Intl.message(
      'Don\'t have an Account?',
      name: 'SignUpInstead',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
