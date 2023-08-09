// import 'package:flutter/material.dart';
// import 'package:flutter_meedu_videoplayer/meedu_player.dart';
// import 'package:pillowchat/themes/ui.dart';

// class VideoEmbeds extends StatelessWidget {
//   VideoEmbeds(this.messageIndex, this.source, {super.key});
//   final dynamic messageIndex;

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

//   final String source;

//   @override
//   Widget build(BuildContext context) {
//     _videoController.setDataSource(
//       DataSource(
//         type: DataSourceType.network,
//         source: source,
//         formatHint: VideoFormat.other,
//       ),
//       autoplay: false,
//     );
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: messageIndex.embeds.length,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: AspectRatio(
//               aspectRatio: 16 / 9,
//               child: MeeduVideoPlayer(
//                 controller: _videoController,
//               ),
//             ),
//           ),
//           // ),
//         );
//       },
//     );
//   }
// }
