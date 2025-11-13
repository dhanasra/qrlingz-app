import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:qrlingz_app/extensions/context_exten.dart';
import 'package:qrlingz_app/extensions/number_exten.dart';
import 'package:qrlingz_app/extensions/string_exten.dart';
import 'package:qrlingz_app/widgets/styled_button.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/assets_const.dart';
import '../../../constants/string_const.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/toast.dart';

class VideoUpload extends StatefulWidget {
  const VideoUpload({super.key});

  @override
  State<VideoUpload> createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  File? _file;
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(_file ?? File(''));
    _controller.initialize().then((_) {
      setState(() {
        _initialized = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _file != null
            ? Visibility(
                visible: _initialized,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            : Visibility(
                visible: true,
                child: DottedBorder(
                  options: const RoundedRectDottedBorderOptions(
                    radius: Radius.circular(8)
                  ),
                  child: Container(
                    height: 240,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        "Upload Video".hm(context),
                        Image.asset(AssetsConst.uploading, width: 100),
                        8.h(),
                        StyledButton(
                          w: 150,
                          onClick: ()async{
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.video,
                            );
                            if (result != null) {
                              File file = File(result.files.single.path!);
                              await file.length().then((fileSize)async{
                                if (fileSize > 4 * 1024 * 1024) {
                                  Toast.show(context, message: 'Video size should be less than 4MB', type: "error");
                                  return;
                                }

                                setState(() {
                                  _file = File(result.files.single.path!);
                                  _controller = VideoPlayerController.file(_file!);
                                  _controller.initialize().then((_) {
                                    setState(() {
                                      _initialized = true;
                                    });
                                    _controller.play();
                                  });
                                  
                                });
                              });
                            }
                          }, 
                          text: 'Pick Video'
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 16),
        const Text(
          "* Allowed formats are mp4, avi, mkv, mov, ogv, webm, mpg, rm. Max file size is 4MB.",
        ),
        32.h(),
        Visibility(
          visible: _file!=null,
          child: StyledButton(
            onClick: ()async{
              await _controller.pause().then((value){
                context.goto(Routes.customize, args: { "data": {"value": _file?.path}, "name": "Video", "isDynamic": true });   
              });
            }, 
            text: StringConst.create.toUpperCase())
        )
      ],
    );
  }
}
