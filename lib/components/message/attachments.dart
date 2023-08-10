// // // CREDIT Rudresh Narwal on SO (https://stackoverflow.com/a/59151953) image.network placeholder

// import 'package:flutter/material.dart';
// import 'package:flutter_meedu_videoplayer/meedu_player.dart';
// import 'package:pillowchat/models/client.dart';
// import 'package:pillowchat/models/message/parts/embeds.dart';
// import 'package:pillowchat/themes/ui.dart';

// class Attachments extends StatelessWidget {
//   Attachments(this.messageIndex, this.attachmentIndex, {super.key});
//   final dynamic messageIndex;
//   final int attachmentIndex;

//   // VIDEO CONTROLLER

//   final _videoController = MeeduPlayerController(
//     screenManager: const ScreenManager(
//       forceLandScapeInFullscreen: false,
//     ),
//     colorTheme: Dark.accent.value,
//     controlsStyle: ControlsStyle.secondary,
//     loadingWidget: CircularProgressIndicator(
//       color: Dark.background.value,
//     ),
//     enabledButtons: const EnabledButtons(
//       videoFit: false,
//     ),
//     customIcons: CustomIcons(
//       play: Padding(
//         padding: const EdgeInsets.all(2),
//         child: Icon(
//           Icons.play_arrow_rounded,
//           size: 25,
//           color: Dark.background.value,
//         ),
//       ),
//       pause: Padding(
//         padding: const EdgeInsets.all(2),
//         child: Icon(
//           Icons.pause_rounded,
//           size: 25,
//           color: Dark.background.value,
//         ),
//       ),
//       sound: Padding(
//         padding: const EdgeInsets.all(2),
//         child: Icon(
//           Icons.volume_up_rounded,
//           size: 25,
//           color: Dark.background.value,
//         ),
//       ),
//       mute: Padding(
//         padding: const EdgeInsets.all(2),
//         child: Icon(
//           Icons.volume_down_rounded,
//           size: 25,
//           color: Dark.background.value,
//         ),
//       ),
//       fullscreen: Padding(
//         padding: const EdgeInsets.all(2),
//         child: Icon(
//           Icons.fullscreen_rounded,
//           size: 25,
//           color: Dark.background.value,
//         ),
//       ),
//       repeat: Padding(
//         padding: const EdgeInsets.all(2),
//         child: Icon(
//           Icons.replay,
//           size: 25,
//           color: Dark.background.value,
//         ),
//       ),
//     ),
//   );

//   @override
//   Widget build(BuildContext context) {
//     if (messageIndex.attachments[attachmentIndex].type == 'Video') {
//       // if (kDebugMode) print(
//       //     '$autumn/attachments/${messageIndex.attachments[attachmentIndex].id}');
//       _videoController.setDataSource(
//         DataSource(
//           type: DataSourceType.network,
//           source:
//               'https://autumn.revolt.chat/attachments/${messageIndex.attachments[attachmentIndex].id}',
//           formatHint: VideoFormat.other,
//         ),
//         autoplay: false,
//       );
//     }
//     // IF ATTACHMENTS ARE A MIX OF IMAGE(S) AND VIDEO(S)
//     if (messageIndex.attachments
//             .any((attachment) => attachment.type == "Image") &&
//         messageIndex.attachments
//             .any((attachment) => attachment.type == "Video")) {
//       if (messageIndex.attachments[attachmentIndex].type != 'Image') {
//         // if (kDebugMode) print(
//         //     '$autumn/attachments/${messageIndex.attachments[attachmentIndex].id}');
//         _videoController.setDataSource(
//           DataSource(
//             type: DataSourceType.network,
//             source:
//                 'https://autumn.revolt.chat/attachments/${messageIndex.attachments[attachmentIndex].id}',
//             formatHint: VideoFormat.other,
//           ),
//           autoplay: false,
//         );
//       }
//       return Column(
//         children: [
//           ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: messageIndex.attachments.length,
//               itemBuilder: (context, index) {
//                 if (messageIndex.attachments[index].type == "Image") {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4),
//                     child: InkWell(
//                       onTap: () {
//                         // messageIndex.attachments
//                         //     .forEach((attachment) => if (kDebugMode) print(attachment.id));
//                         Picture.view(
//                           context,
//                           '$autumn/attachments/${messageIndex.attachments[index].id}/${messageIndex.attachments[index].filename}',
//                           messageIndex.attachments[index].filename,
//                         );
//                       },
//                       child: Container(
//                         constraints: const BoxConstraints(
//                           maxWidth: 400,
//                           maxHeight: 300,
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(
//                             8,
//                           ),
//                           child: Image.network(
//                             '$autumn/attachments/${messageIndex.attachments[index].id}/${messageIndex.attachments[index].filename}',
//                             filterQuality: FilterQuality.medium,
//                             alignment: Alignment.topLeft,
//                             fit: BoxFit.contain,
//                             // height: messageIndex
//                             //     .attachments[attachmentIndex].height
//                             //     .toDouble(),
//                             // width: messageIndex
//                             //     .attachments[attachmentIndex].width
//                             //     .toDouble(),
//                             loadingBuilder: (BuildContext context, Widget child,
//                                 ImageChunkEvent? loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return Center(
//                                 child: CircularProgressIndicator(
//                                   color: Dark.accent.value,
//                                   value: loadingProgress.expectedTotalBytes !=
//                                           null
//                                       ? loadingProgress.cumulativeBytesLoaded /
//                                           loadingProgress.expectedTotalBytes!
//                                       : null,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 } else {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4),
//                     child: Container(
//                       constraints: const BoxConstraints(
//                         maxWidth: 400,
//                         maxHeight: 300,
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(
//                           8,
//                         ),
//                         child: AspectRatio(
//                           aspectRatio: 16 / 9,
//                           child: MeeduVideoPlayer(
//                             controller: _videoController,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//               }),
//         ],
//       );
//     } // IF ALL ATTACHMENTS ARE IMAGES
//     if (messageIndex.attachments
//         .any((attachment) => attachment.type == "Image")) {
//       return ListView.builder(
//           shrinkWrap: true,
//           itemCount: 1,
//           physics: const NeverScrollableScrollPhysics(),
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4),
//               child: InkWell(
//                 onTap: () {
//                   Picture.view(
//                     context,
//                     '$autumn/attachments/${messageIndex.attachments[attachmentIndex].id}/${messageIndex.attachments[attachmentIndex].filename}',
//                     messageIndex.attachments[attachmentIndex].filename,
//                   );
//                 },
//                 child: Container(
//                   constraints: const BoxConstraints(
//                     maxWidth: 400,
//                     maxHeight: 300,
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(
//                       8,
//                     ),
//                     child: Image.network(
//                       '$autumn/attachments/${messageIndex.attachments[attachmentIndex].id}/${messageIndex.attachments[attachmentIndex].filename}',
//                       filterQuality: FilterQuality.medium,
//                       alignment: Alignment.topLeft,
//                       fit: BoxFit.contain,
//                       // height: messageIndex.attachments[attachmentIndex].height
//                       //     .toDouble(),
//                       // width: messageIndex.attachments[attachmentIndex].width
//                       //     .toDouble(),
//                       loadingBuilder: (BuildContext context, Widget child,
//                           ImageChunkEvent? loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: Dark.accent.value,
//                             value: loadingProgress.expectedTotalBytes != null
//                                 ? loadingProgress.cumulativeBytesLoaded /
//                                     loadingProgress.expectedTotalBytes!
//                                 : null,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           });
//     } // IF ALL ATTACHMENTS ARE VIDEOS
//     return ListView.builder(
//       itemCount: 1,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 4),
//           child: Container(
//             constraints: const BoxConstraints(
//               maxWidth: 400,
//               maxHeight: 300,
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(
//                 8,
//               ),
//               child: AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: MeeduVideoPlayer(
//                   controller: _videoController,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
