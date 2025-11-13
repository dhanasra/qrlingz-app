import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:qrlingz_app/constants/assets_const.dart';
import 'package:qrlingz_app/constants/color_const.dart';
import 'package:qrlingz_app/constants/string_const.dart';
import 'package:qrlingz_app/extensions/context_exten.dart';
import 'package:qrlingz_app/extensions/number_exten.dart';
import 'package:qrlingz_app/extensions/string_exten.dart';
import 'package:qrlingz_app/pages/scan/scanning/scan_viewmodel.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {

  late ScanViewModel _viewModel;
  bool flash = false;
  bool flip = false;

  @override
  void initState() {
    _viewModel = ScanViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                QRView(
                  key: _viewModel.qrKey, 
                  onQRViewCreated: (c)=> _viewModel.onQRViewCreated(c, context)
                ),
                
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
                    child: IconButton(onPressed: ()=>context.back(), icon: const Icon(Icons.arrow_back, color: Colors.white,)),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white,
                          )
                        ),
                        child: Lottie.asset(AssetsConst.scanning),
                      ),
                      24.h(),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 250),
                        child: StringConst.scanInfo.bs(context, color: Colors.white),  
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(32),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: ColorConst.primary,
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: ColorConst.primary,
                            child: IconButton(
                              onPressed: ()async{
                                await _viewModel.pickImage(context);
                              }, 
                              icon: const Icon(Icons.image_outlined, color: Colors.white, size: 20)),
                          ),
                        ),
                        32.w(),
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: ColorConst.primary,
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: flash ? Colors.white : ColorConst.primary,
                            child: IconButton(
                              onPressed: (){
                                _viewModel.controller?.toggleFlash();
                                setState((){
                                  flash = !flash;
                                });
                              }, 
                              icon: Icon(!flash ? Icons.flashlight_on_outlined : Icons.flashlight_off_outlined, color: flash ? ColorConst.primary : Colors.white, size: 20)),
                          ),
                        ),
                        32.w(),
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: ColorConst.primary,
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: flip ? Colors.white : ColorConst.primary,
                            child: IconButton(
                              onPressed: (){
                                _viewModel.controller?.flipCamera();
                                setState((){
                                  flip = !flip;
                                });
                              }, 
                              icon: Icon(!flip ? Icons.camera_front_outlined : Icons.camera_rear_outlined, color: flip ? ColorConst.primary : Colors.white, size: 20)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}