import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:qrlingz_app/extensions/context_exten.dart';
import 'package:qrlingz_app/extensions/number_exten.dart';
import 'package:qrlingz_app/extensions/string_exten.dart';
import 'package:qrlingz_app/utils/toast.dart';
import 'package:qrlingz_app/widgets/styled_button.dart';

import '../../../constants/assets_const.dart';
import '../../../constants/string_const.dart';
import '../../../routes/app_routes.dart';

class AudioUpload extends StatelessWidget {
  const AudioUpload({super.key});

  @override
  Widget build(BuildContext context) {

    ValueNotifier<File?> picker = ValueNotifier(null);
    AudioPlayer player = AudioPlayer();

    return ValueListenableBuilder(
      valueListenable: picker,
      builder: (_, file, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: file==null,
              replacement: DottedBorder(
                options: const RoundedRectDottedBorderOptions(
                  radius: Radius.circular(8)
                ),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.volume_up_outlined, size: 64,),
                      8.h(),
                      "${file?.path.split('/').last}".hs(context),
                      16.h(),
                      TextButton(
                        onPressed: ()async{
                          await player.stop();
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.audio
                          );
                          if (result != null) {
                            picker.value = File(result.files.single.path!);
                            await player.play(DeviceFileSource(result.files.single.path??''), volume: 100);
                          } 
                        }, 
                        child: 'Change Audio'.ts(context, color: Colors.blue)),
                    ],
                  ),
                ),
              ),
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
                      "Upload Audio".hm(context),
                      Image.asset(AssetsConst.uploading, width: 100),
                      8.h(),
                      StyledButton(
                        w: 150,
                        onClick: ()async{
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.audio
                          );
                          
                          if (result != null) {
                            File file = File(result.files.single.path!);
                            await file.length().then((fileSize)async{
                              if (fileSize > 2 * 1024 * 1024) {
                                Toast.show(context, message: 'Audio size should be less than 2MB', type: "error");
                                return;
                              }
                              picker.value = file;
                              await player.play(DeviceFileSource(file.path), volume: 100);
                            });
                          } 
                        }, 
                        text: 'Pick Audio'),
                    ],
                  ),
                ),
              ),
            ),
            16.h(),
            "* Allowed formats are mp3, wav, ogg, etc. Max file size is 2MB.".bs(
              context, align: TextAlign.start, color: Theme.of(context).primaryColor),

            32.h(),
            Visibility(
              visible: file!=null,
              child: StyledButton(
                onClick: ()async{
                  await player.stop().then((v){
                    context.goto(Routes.customize, args: { "data": {"value": file?.path}, "name": "Audio", "isDynamic": true });   
                  });
                }, 
                text: StringConst.create.toUpperCase())
            )
          ],
        );
      }
    );
  }
}