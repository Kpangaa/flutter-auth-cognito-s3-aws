import 'package:flutter/material.dart';
import 'package:definitive_aws_image_amplify/providers/auth.dart';
import 'package:definitive_aws_image_amplify/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class SessionDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    final userName = auth.getCurrentUser();
    final isSignedIn = auth.fetchSession();
    final locura = auth.getUserAttributes();

    print(locura);

    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Australia'),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Item('username', userName),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Item('Used Logged In ?', isSignedIn),
            ),
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final Future<String> future;
  final String keyName;
  const Item(this.keyName, this.future);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Text('')
              : Text('$keyName ${snapshot.data}'),
    );
  }
}
