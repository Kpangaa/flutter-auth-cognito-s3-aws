// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:definitive_aws_image_amplify/providers/auth.dart';
import 'package:definitive_aws_image_amplify/screens/home_page.dart';
import 'package:definitive_aws_image_amplify/screens/login_screen.dart';
import 'package:definitive_aws_image_amplify/screens/session_details_screen.dart';
import 'package:provider/provider.dart';

import '../screens/image_picker_screen.dart';
import '../screens/show_images_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              title: const Text('AWS Amplify For Flutter'),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => HomePage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Show Session Details'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => SessionDetailsScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.cloud_upload),
              title: const Text('Upload Images'),
              onTap: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const SelectImage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.cloud_download),
              title: const Text('Download Images'),
              onTap: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => ListBucketScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () async {
                // Signout the user
                await auth.signOut();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => AuthScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
