// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:qrlingz_app/base/base_viewmodel.dart';
import 'package:qrlingz_app/models/qr_data.dart';
import 'package:qrlingz_app/utils/global.dart';
import 'package:qrlingz_app/utils/toast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../network/local_db.dart';

class QrCodePreviewModel extends BaseViewModel {
  final ScreenshotController controller = ScreenshotController();
  late QRData qrdata;

  QrCodePreviewModel({data}){
    qrdata = data;
  }

  updateFavourite(isLiked){
    qrdata = qrdata.copyWith(isFavourite: isLiked);
    LocalDB().saveHistory(qrdata.toMap());
    if(isLiked){
      Global.favourites.value = [ ...Global.favourites.value, qrdata ];
    }else{
      Global.favourites.value = Global.favourites.value.where((element) => element.id!=qrdata.id).toList();
    }
  }

  shareQRCode()async{
    Directory directory = await getTemporaryDirectory();
    var imagePath = await controller.captureAndSave(directory.path, fileName: "captured_image.png");
    if(imagePath!=null){
      await Share.shareXFiles([XFile(imagePath)], text: qrdata.name);
    }
  }

  saveToGallery(BuildContext context)async{
    var bytes = await controller.capture();
    if(bytes!=null){
      final result = await ImageGallerySaverPlus.saveImage(bytes);
      Toast.show(context, message: 'Image downloaded successfully !', onOk: (){
        launchUrlString(result?['filePath'] ?? '');
      });
    }
  }

  
  @override
  dispose() {

  }

}