// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class EventWidgets {
//   static Widget buildImageSection(
//       BuildContext context, void Function() toggleLike) {
//     return Container(
//       height: 250.h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         image: DecorationImage(
//           image: NetworkImage(widget.event.imageUrl!),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: const CircleAvatar(
//                 child: Icon(CupertinoIcons.left_chevron),
//               ),
//             ),
//             GestureDetector(
//               onTap: toggleLike,
//               child: CircleAvatar(
//                 child: Icon(
//                   isLiked ? Icons.favorite : Icons.favorite_outline,
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
