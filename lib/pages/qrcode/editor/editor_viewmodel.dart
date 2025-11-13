import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:qrlingz_app/base/base_viewmodel.dart';
import 'package:qrlingz_app/extensions/context_exten.dart';
import 'package:qrlingz_app/utils/toast.dart';
import 'package:screenshot/screenshot.dart';

class EditorViewModel extends BaseViewModel {

  final ScreenshotController controller = ScreenshotController();

  saveImage(BuildContext context)async{
    var bytes = await controller.capture();
    if(bytes!=null){
      await ImageGallerySaverPlus.saveImage(bytes);
    }
    Toast.show(context, message: "Saved To Gallery !");
    context.back();
  }
  
  @override
  dispose() {

  }

}