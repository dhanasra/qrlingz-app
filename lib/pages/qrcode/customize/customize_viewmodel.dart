import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrlingz_app/base/base_viewmodel.dart';
import 'package:qrlingz_app/models/qr_data.dart';
import 'package:qrlingz_app/pages/qrcode/bloc/qr_code_bloc.dart';

import '../../../constants/data_const.dart';
import '../../../utils/utils.dart';

class CustomizeViewModel extends BaseViewModel {

  ValueNotifier<int?> active = ValueNotifier(null);

  late QRData qrData;
  late ValueNotifier<QRData> tempData;

  // text custom
  late TextEditingController textController;
  String? color;
  String? font;
  // pixcels
  String? type;
  String? corner;
  //color
  String? fg;
  String? fgg;
  String? bg;
  String? bgg;

  CustomizeViewModel(Map data, String name, { String? linkId }){
    qrData = QRData(id: "${DateTime.now().millisecondsSinceEpoch}", linkId: linkId ?? generateUniqueString(), type: 0, name: name, data: data, created: DateTime.now());
    tempData = ValueNotifier(QRData.fromMap(qrData.toMap()));

    textController = TextEditingController();
  }

  var options = [
    // {
    //   "type": 0,
    //   "name": "Templates",
    //   "icon": Icons.dashboard_outlined
    // },
    {
      "type": 1,
      "name": "Color",
      "icon": Icons.color_lens_outlined
    },
    {
      "type": 2,
      "name": "Logo",
      "icon": Icons.image_outlined
    },
    {
      "type": 3,
      "name": "Pixels",
      "icon": Icons.image_outlined
    },
    {
      "type": 4,
      "name": "Text",
      "icon": Icons.text_fields_outlined
    }
  ];

  getTitleText(){
    switch(active.value){
      // case 0: return "Templates";
      case 0: return "Color";
      case 1: return "Logo";
      case 2: return "Pixels";
      case 3: return "Text";
      default: return "Customize QR";
    }
  }

  saveTemp(){
    qrData = tempData.value;
    active.value = null;
  }

  clearTemp(){
    tempData.value = qrData;
    active.value = null;
  }

  saveQRCode(BuildContext context){
    var isDynamic = DataConst.dynamics.contains(qrData.name);
    context.read<QrCodeBloc>().add(SaveQREvent(qrData: qrData, isDynamic: isDynamic));
  }
  
  @override
  dispose() {

  }

}