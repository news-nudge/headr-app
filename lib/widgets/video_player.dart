import 'dart:developer';

// import 'package:chewie/chewie.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        autoPlay: false,
        autoInitialize: true,
        videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl.toString())));
    flickManager.flickVideoManager!.videoPlayerController!.play();
    flickManager.flickVideoManager!.videoPlayerController!.setLooping(true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      width: 100.w,
      child: FlickVideoPlayer(
        flickManager: flickManager,
        flickVideoWithControls: FlickVideoWithControls(
            videoFit: BoxFit.cover,
            playerLoadingFallback: const CircularProgressIndicator(color: Colors.deepPurple,),
            controls: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 4.h,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: VideoProgressIndicator(
                    flickManager.flickVideoManager!.videoPlayerController!,
                    allowScrubbing: false,
                    colors: VideoProgressColors(
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      bufferedColor: Colors.transparent,
                      playedColor: Colors.white,
                    ),
                  ),
                ),
                // SizedBox(height: 2.h,),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       GestureDetector(
                //         child: Container(
                //           width: 10.w,
                //           height: 10.w,
                //           decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: Colors.black.withOpacity(0.2),
                //               border: Border.all(color: Get.theme.highlightColor.withOpacity(0.5))
                //           ),
                //           child: const Center(child: Icon(Icons.chevron_left_rounded,size: 25,),),
                //         ),
                //         onTap: () async{
                //           await flickManager.flickVideoManager!.videoPlayerController!.dispose();
                //           Get.back();
                //         },
                //       ),
                //     ],
                //   ),
                //
                // ),
              ],
            )
        ),
      ),
    );

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flickManager.dispose();
  }
}