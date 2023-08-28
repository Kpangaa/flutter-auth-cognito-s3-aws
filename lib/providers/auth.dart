// ignore_for_file: avoid_print

import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:definitive_aws_image_amplify/amplifyconfiguration.dart';

class Auth extends ChangeNotifier {
  bool isSignUpComplete = false;
  bool isSignedIn = false;
  String? username;

  Auth() {
    configureCognitoPluginWrapper();
  }

  Future<void> configureCognitoPluginWrapper() async {
    await configureCognitoPlugin();
  }

  Future<void> configureCognitoPlugin() async {
    // Add Cognito Plugin
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();

    await Amplify.addPlugins([authPlugin]);

    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }

    // Amplify.Hub.listen([HubChannel.Auth], (hubEvent){
    //   switch (hubEvent.eventName) {
    //     case "SIGNED_IN":
    //       print("USER IS SIGNED IN");
    //       break;
    //     case "SIGNED_OUT":
    //       print("USER IS SIGNED OUT");
    //       break;
    //     case "SESSION_EXPIRED":
    //       print("USER IS SIGNED IN");
    //       break;
    //   }
    // });
  }

  /// Signup a User
  Future<void> signUp(String username, String password, String email) async {
    try {
      final userAttributes = <AuthUserAttributeKey, String>{
        AuthUserAttributeKey.email: email,
        AuthUserAttributeKey.phoneNumber: '',
      };

      SignUpResult res = await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: SignUpOptions(
          userAttributes: userAttributes,
        ),
      );

      isSignUpComplete = res.isSignUpComplete;
    } on AuthException catch (e) {
      print(e);
      rethrow;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  /// Confirm User
  Future<void> confirm(String username, String confirmationCode) async {
    try {
      SignUpResult res = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: confirmationCode,
      );

      isSignUpComplete = res.isSignUpComplete;
    } on AuthException catch (e) {
      print(e);
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  /// Signin a User
  Future<void> signIn(String username, String password) async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
    } on AuthException catch (e) {
      print(e);
      rethrow;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<bool> _isSignedIn() async {
    final session = await Amplify.Auth.fetchAuthSession();
    return session.isSignedIn;
  }

  // Sign Out the User.
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String> fetchSession() async {
    try {
      AuthSession session = await Amplify.Auth.fetchAuthSession(
        options: const CognitoFetchAuthSessionOptions(getAWSCredentials: true),
      );

      // AuthSession session = await Amplify.Auth.fetchAuthSession(
      //   options: const FetchAuthSessionOptions(forceRefresh : true),
      // );

      return session.isSignedIn.toString();
    } on AuthException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String> getCurrentUser() async {
    try {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      return res.username;
    } on AuthException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<AuthUserAttribute>> getUserAttributes() async {
    List<AuthUserAttribute> attributes = [];

    if (await _isSignedIn()) {
      attributes = await Amplify.Auth.fetchUserAttributes();
      print(attributes);
    }
    return attributes;
  }
}
