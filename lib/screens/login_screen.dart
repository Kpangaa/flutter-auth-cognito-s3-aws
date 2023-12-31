// ignore_for_file: constant_identifier_names

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:definitive_aws_image_amplify/providers/auth.dart';
import 'package:definitive_aws_image_amplify/screens/home_page.dart';
import 'package:definitive_aws_image_amplify/widgets/signin_button.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login, ConfirmUser }

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordFocusNode = FocusNode();
  bool _showSpinner = false;

  // Default screen is Login mode.
  AuthMode _authMode = AuthMode.Login;

  String sessionExistsMsg =
      "There is already a user which is signed in. Please log out the user before calling showSignIn.";

  final Map<String, String> _authData = {
    'username': '',
    'email': '',
    'password': '',
    'confimationCode': '',
  };

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Alert Dialog to show any error messages.
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('An Error Occurred!'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void clearCache() {
    _authData['username'] = '';
    _authData['password'] = '';
    _authData['email'] = '';
    _authData['confimationCode'] = '';
  }

  // Sign Up functionality
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Fills "_authData" map with Signup details.
    _formKey.currentState!.save();

    try {
      await Provider.of<Auth>(context, listen: false).signUp(
        _authData['username']!,
        _authData['password']!,
        _authData['email']!,
      );

      // When a user is created in Cognito, he will need to be confirmed. An
      // auth code would have been sent to the user's email. Allow user
      // to enter confirmation code.
      setState(() {
        clearCache();
        _authMode = AuthMode.ConfirmUser;
      });
    } on AuthException catch (e) {
      var message = e.message;
      _showDialog(message);
    } catch (error) {
      var message = "Could not be Authenticated. Try later!";
      _showDialog(message);
    }
  }

  // Confirm User by entering his Confirmation Code
  Future<void> _confirmUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    try {
      await Provider.of<Auth>(context, listen: false).confirm(
        _authData['username']!,
        _authData['confimationCode']!,
      );

      // Once the User is confirmed, he can authenticate using his User name
      // and Password.
      setState(() {
        _authMode = AuthMode.Login;
      });
    } on AuthException catch (e) {
      var message = e.message;
      _showDialog(message);
    } catch (error) {
      var message = "Could not be Authenticated. Try later!";
      _showDialog(message);
    }
  }

  Future<void> _signIn() async {
    final auth = Provider.of<Auth>(context, listen: false);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _showSpinner = true;
      });

      await auth.signIn(
        _authData['username']!,
        _authData['password']!,
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => HomePage()));
    } on AuthException catch (e) {
      var message = e.message;
      if (message == sessionExistsMsg) {
        await auth.signOut();
        message = 'Try Again!';
      }
      _showDialog(message);

      setState(() {
        _showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Color.fromRGBO(120, 93, 155, 1),
      body: _showSpinner
          ? const Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ))
          : Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: [0.0, 1.0],
                        colors: [
                          Color.fromRGBO(170, 211, 182, 1),
                          Color.fromRGBO(93, 94, 155, 1),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: devicePadding.top + 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 200,
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Container(),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(166, 255, 255, 255),
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: TextFormField(
                                      key: const Key('Username'),
                                      initialValue: _authData['username'],
                                      decoration: const InputDecoration(
                                        hintText: 'User name',
                                        labelText: 'User name',
                                      ),
                                      textInputAction: TextInputAction.next,
                                      onSaved: (String? value) {
                                        if (value != null) {
                                          _authData['username'] = value;
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please provide a value!";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  if (_authMode == AuthMode.Signup)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: TextFormField(
                                        key: const Key('email'),
                                        initialValue: _authData['email'],
                                        decoration: const InputDecoration(
                                          hintText:
                                              "What's your email address?",
                                          labelText: 'Email',
                                        ),
                                        textInputAction: TextInputAction.next,
                                        onSaved: (value) {
                                          if (value != null) {
                                            _authData['email'] = value;
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please provide a value!";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  if (_authMode == AuthMode.Signup ||
                                      _authMode == AuthMode.Login)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: TextFormField(
                                        key: const Key('password'),
                                        initialValue: '',
                                        obscureText: true,
                                        decoration: const InputDecoration(
                                          hintText: "Enter password",
                                          labelText: 'Password',
                                        ),
                                        textInputAction: TextInputAction.next,
                                        onSaved: (value) {
                                          if (value != null) {
                                            _authData['password'] = value;
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please provide a value!";
                                          }
                                          return null;
                                        },
                                        focusNode: _passwordFocusNode,
                                      ),
                                    ),
                                  if (_authMode == AuthMode.ConfirmUser)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: TextFormField(
                                        key: const Key('confirmationCode'),
                                        initialValue:
                                            _authData['confimationCode'],
                                        decoration: const InputDecoration(
                                          hintText: 'Confirmation Code',
                                          labelText: 'Confirmation Code',
                                        ),
                                        textInputAction: TextInputAction.next,
                                        onSaved: (value) {
                                          if (value != null) {
                                            _authData['confimationCode'] =
                                                value;
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please provide a value!";
                                          }

                                          return null;
                                        },
                                      ),
                                    ),
                                  // When the mode is "Login", show "SignIn" button.
                                  // Show "SignUp" and "Confirm User" below.
                                  if (_authMode == AuthMode.Login)
                                    Column(
                                      children: [
                                        SigninButton(
                                          child: const Text(
                                            "Sign In",
                                            style: TextStyle(
                                                fontFamily: "RobotoMedium",
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            await _signIn();
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              child: const Text(
                                                'Sign Up',
                                                style: TextStyle(
                                                  fontFamily: 'RobotoMedium',
                                                  fontSize: 16,
                                                  color: Colors.purple,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  clearCache();
                                                  _authMode = AuthMode.Signup;
                                                });
                                              },
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  clearCache();
                                                  _authMode =
                                                      AuthMode.ConfirmUser;
                                                });
                                              },
                                              child: const Text(
                                                'Confirm User',
                                                style: TextStyle(
                                                  fontFamily: 'RobotoMedium',
                                                  fontSize: 16,
                                                  color: Colors.purple,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  if (_authMode == AuthMode.Signup)
                                    Column(
                                      children: [
                                        SigninButton(
                                          onPressed: _signUp,
                                          child: const Text(
                                            "Sign Up",
                                            style: TextStyle(
                                                fontFamily: "RobotoMedium",
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              child: const Text(
                                                'Sign In',
                                                style: TextStyle(
                                                  fontFamily: 'RobotoMedium',
                                                  fontSize: 16,
                                                  color: Colors.purple,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  clearCache();
                                                  _authMode = AuthMode.Login;
                                                });
                                              },
                                            ),
                                            TextButton(
                                              child: const Text(
                                                'Confirm User',
                                                style: TextStyle(
                                                  fontFamily: 'RobotoMedium',
                                                  fontSize: 16,
                                                  color: Colors.purple,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  clearCache();
                                                  _authMode =
                                                      AuthMode.ConfirmUser;
                                                });
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  if (_authMode == AuthMode.ConfirmUser)
                                    Column(
                                      children: [
                                        SigninButton(
                                          onPressed: _confirmUser,
                                          child: const Text(
                                            "Confirm User",
                                            style: TextStyle(
                                                fontFamily: "RobotoMedium",
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              child: const Text(
                                                'Sign Up',
                                                style: TextStyle(
                                                  fontFamily: 'RobotoMedium',
                                                  fontSize: 16,
                                                  color: Colors.purple,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  clearCache();
                                                  _authMode = AuthMode.Signup;
                                                });
                                              },
                                            ),
                                            TextButton(
                                              child: const Text(
                                                'Sign In',
                                                style: TextStyle(
                                                  fontFamily: 'RobotoMedium',
                                                  fontSize: 16,
                                                  color: Colors.purple,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    clearCache();

                                                    _authMode = AuthMode.Login;
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
