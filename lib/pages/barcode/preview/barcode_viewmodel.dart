import 'dart:io';

import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrlingz_app/base/base_viewmodel.dart';
import 'package:qrlingz_app/network/models/barcode_data.dart';
import 'package:qrlingz_app/utils/notifications.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class BarcodeViewModel extends BaseViewModel {
  final ScreenshotController controller = ScreenshotController();
  late BarcodeData barcodeData;

  BarcodeViewModel({data}){
    barcodeData = data;
  }

  shareQRCode()async{
    Directory directory = await getTemporaryDirectory();
    var imagePath = await controller.captureAndSave(directory.path, fileName: "captured_image.png");
    if(imagePath!=null){
      await Share.shareXFiles([XFile(imagePath)], text: barcodeData.name);
    }
  }

  saveToGallery()async{
    var bytes = await controller.capture();
    if(bytes!=null){
      var result = await ImageGallerySaverPlus.saveImage(bytes);
      AppNotification().showDownloadNotification(filePath: result?['filePath'] ?? '');
    }
  }
  
  @override
  dispose() {

  }
}