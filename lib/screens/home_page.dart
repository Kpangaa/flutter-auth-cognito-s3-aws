import 'package:flutter/material.dart';
// import 'package:definitive_aws_image_amplify/providers/auth.dart';
import 'package:definitive_aws_image_amplify/widgets/app_drawer.dart';
// import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AWS Amplify for Flutter'),
      ),
      drawer: AppDrawer(),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '''AWS Amplify is a set of tools and services that can be used together or on their own, to help front-end web and mobile developers build scalable full stack applications, powered by AWS.
          ''',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   final images = [
//     'great-ocean-road-1.jpg',
//     'great-ocean-road-2.jpg',
//     'manali-1.jpg',
//     'manali-2.jpg',
//     'manali-3.jpg',
//     'tasmania-1.jpg',
//     'twelve-apostles.jpg',
//     'warrnambool-1.jpg',
//     'warrnambool-2.jpg',
//     'warrnambool-3.jpg',
//     'warrnambool-4.jpg',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<Auth>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Travel Australia'),
//       ),
//       drawer: AppDrawer(),
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 10,
//           crossAxisSpacing: 10,
//         ),
//         itemBuilder: (ctx, i) {
//           return SampleItem(images[i]);
//         },
//         itemCount: images.length,
//         padding: const EdgeInsets.all(10),
//       ),
//     );
//   }
// }

// class SampleItem extends StatelessWidget {
//   final String imageName;
//   const SampleItem(this.imageName);

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: GridTile(
//         child: GestureDetector(
//           onTap: () {},
//           child: Image.asset(
//             'assets/images/$imageName',
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }
